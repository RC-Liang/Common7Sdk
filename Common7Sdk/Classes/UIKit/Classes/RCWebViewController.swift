import RxSwift
import SnapKit
import UIKit
import WebKit

public class RCWebViewController: RCBaseViewController {
   
    public func show() {
        let currentVC = UIKitCommon.currentViewController()
        if currentVC?.navigationController != nil {
            isPush = true
            hidesBottomBarWhenPushed = true
            currentVC?.pushViewController(self)
        } else {
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.modalPresentationStyle = .fullScreen
            self.showBackButton = true
            currentVC?.present(navigationController, animated: true)
        }
    }

    public convenience init(title: String?, path: String?) {
        self.init()
        titleText = title
        urlPath = path
    }

    var url: URL?

    var urlPath: String?

    var titleText: String?

    var isPush: Bool = false

    private let disposeBag = DisposeBag()

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = titleText
        view.backgroundColor = .white
        
        configFunc()

        var loadUrl: URL?

        if urlPath != nil {
            loadUrl = URL(string: urlPath ?? "")
        } else {
            loadUrl = url
        }

        guard let loadUrl = loadUrl else {
            return
        }

        let request = URLRequest(url: loadUrl)
        webView.load(request)

        activityIndicator.startAnimating()

        if !isPush {
            addBarButtonItem(image: UIImage(systemName: "xmark"), isLeft: true) { [weak self] in
                guard let self = self else {
                    return
                }
                self.dismiss(animated: true)
            }
        }
    }

    fileprivate lazy var configuration: WKWebViewConfiguration = {
        let wkUController = WKUserContentController()

        // 自适应屏幕宽度js
        let jSString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"

        let wkUserScript = WKUserScript(source: jSString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

        // 添加自适应屏幕宽度js调用的方法
        wkUController.addUserScript(wkUserScript)

        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        return wkWebConfig
    }()

    fileprivate lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        self.view.addSubview(webView)

        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return webView
    }()

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        
        let activity = UIActivityIndicatorView()
        
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        
        view.insertSubview(activity, aboveSubview: webView)

        activity.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }

        return activity
    }()

    func configFunc() {
        let funcView = UIView()
        funcView.backgroundColor = .white
        view.insertSubview(funcView, aboveSubview: webView)
        funcView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(UIKitCommon.safeBottom)
            make.height.equalTo(50)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        funcView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let backBtn = UIButton()
        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.imageView?.tintColor = .black
        stackView.addArrangedSubview(backBtn)

        let forwardBtn = UIButton()
        forwardBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        forwardBtn.imageView?.tintColor = .black
        stackView.addArrangedSubview(forwardBtn)
        forwardBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalToSuperview()
        }

        _ = backBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            if self.webView.canGoBack {
                var backlist = self.webView.backForwardList.backList // 获得存储的栈
                var lastItem = backlist.popLast()
                let currentItem = self.webView.backForwardList.currentItem
                while lastItem?.url.relativePath == currentItem?.url.relativePath { // 比较返回页和当前页的url的realtive部分，相同的话就不断的弹出栈
                    lastItem = backlist.popLast()
                }
                if let lastitem = lastItem {
                    self.webView.go(to: lastitem) // 调用go函数，直接调转到要返回的web页
                    _ = backlist.popLast() // 因为上面调用了go函数，backlist中会增加此次web跳转，所以弹出此次跳转
                }
            }
        })

        _ = forwardBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            if self.webView.canGoForward {
                self.webView.goForward()
            }
        })
    }
}

extension RCWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        if navigationAction.request.url?.scheme == "alipays" {
            if let url = navigationAction.request.url, UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
            }
        }

        return .allow
    }
}

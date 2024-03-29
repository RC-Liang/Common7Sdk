import Foundation
import RxSwift

open class RCBaseViewController: UIViewController {
    
    open var backAction: (() -> Void)?

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard navigationController?.viewControllers.count != 1 else {
            return
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    // 设置状态栏颜色 --- 默认黑色

    fileprivate var statusBarStyle: UIStatusBarStyle = .default

    open func setPreferredStatusBarStyle(_ style: UIStatusBarStyle) {
        statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }

    // 设置返回按钮图片 --- 默认白色返回按钮

    open func setBackButtonImage(_ image: String) {
        backButton.setImage(UIImage(named: image), for: .normal)
    }

    open func setBackButtonImage(_ image: UIImage) {
        backButton.setImage(image, for: .normal)
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }

    fileprivate lazy var backButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }
        button.tintColor = UIColor.black
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        button.contentHorizontalAlignment = .left
        
        _ = button.rx.tap.subscribe(onNext: { [weak self] _ in
            
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                guard let backAction = self.backAction else {
                    
                    if self.navigationController?.viewControllers.count == 1 || self.navigationController == nil {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }

                    return
                }

                backAction()
            }
            
        })
        return button
    }()
}

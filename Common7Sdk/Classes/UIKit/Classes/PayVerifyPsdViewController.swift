import RxSwift
import UIKit

public class PayVerifyPsdViewController: UIViewController {
    public typealias ToVerify = (_ psd: String) -> Void

    /// 输入密码
    /// - Parameters:
    ///   - desc: 描述
    ///   - amount: 数量(单位分)
    public class func show(desc: String, amount: Int?, toVerify: ToVerify?) {
        let verifyVC = PayVerifyPsdViewController(nibName: identifier, bundle: UIKitCommon.resourceBundle(type: .components))
        verifyVC.modalPresentationStyle = .overFullScreen
        verifyVC.loadViewIfNeeded()
        verifyVC.toVerify = toVerify
        verifyVC.descLabel.text = desc
        if let amount = amount {
            verifyVC.amountLabel.isHidden = false
            verifyVC.amountLabel.text = "¥\(String(format: "%.2f", CGFloat(amount) / 100.0))"
        } else {
            verifyVC.amountLabel.isHidden = true
        }
        UIKitCommon.currentViewController()?.present(verifyVC, animated: false)
    }

    public class func close() {
        UIKitCommon.currentViewController()?.view.endEditing(true)
        UIKitCommon.currentViewController()?.dismiss(animated: false)
    }

    @IBOutlet var descLabel: UILabel!

    @IBOutlet var amountLabel: UILabel!

    @IBOutlet var psdView: PayPasswordView!

    @IBOutlet var closeBtn: UIButton!

    /// 垃圾袋
    private let disposeBag = DisposeBag()

    var toVerify: ToVerify?

    @IBOutlet var payTypeBtn: UIButton!
    /// 生物支付按钮
    @IBOutlet var facePayBtn: UIButton!

    let FaceIDPayKey = "FaceIDPayKey"

    override public func viewDidLoad() {
        super.viewDidLoad()

        facePayBtn.backgroundColor = UIKitCommon.ThemeColor

        // TODO: 后期需要优化
        if let psd = UserDefaults.standard.string(forKey: FaceIDPayKey) {
            showPassword(isPsd: false)

//            _ = facePayBtn.rx.tap.subscribe(onNext: { [weak self] in
//                guard let self = self else {
//                    return
//                }
//                SimIDHelper.authID(showError: false) { result in
//                    if result {
//                        self.toVerify?(psd)
//                    }
//                }
//            })
//
//            _ = payTypeBtn.rx.tap.subscribe(onNext: { [weak self] in
//                guard let self = self else {
//                    return
//                }
//                self.payTypeBtn.isSelected = !self.payTypeBtn.isSelected
//                self.showPassword(isPsd: self.payTypeBtn.isSelected)
//            })
        } else {
            payTypeBtn.isHidden = true
            showPassword(isPsd: true)
        }

        configAction()
    }

    func showPassword(isPsd: Bool) {
        // TODO:
//        if isPsd {
//            payTypeBtn.setTitle(SimIDHelper.IDPayTitle() + "支付", for: .normal)
//            psdView.autoShowKeyboard = true
//            facePayBtn.isHidden = true
//            psdView.isHidden = false
//        } else {
//            payTypeBtn.setTitle("密码支付", for: .normal)
//            facePayBtn.isHidden = false
//            psdView.clearInput()
//            psdView.endEditing(true)
//            psdView.isHidden = true
//        }
    }

    func configAction() {
        psdView.endInput = { [weak self] password in
            guard let self = self else {
                return
            }
            self.verifyPsdRequest(password)
        }

        closeBtn.rx.tap.subscribe { [weak self] event in

            if case .next() = event {
                guard let self = self else {
                    return
                }
                self.dismiss(animated: false)
            }
        }.disposed(by: disposeBag)
    }

    func verifyPsdRequest(_ password: String) {
        view.endEditing(true)
        toVerify?(password)
    }
}

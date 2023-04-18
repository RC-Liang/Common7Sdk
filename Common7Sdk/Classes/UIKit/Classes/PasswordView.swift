import RxSwift
import UIKit

public class PasswordView: UIView {
    // 容器
    @IBOutlet private var contentView: UIView!
    // 密码输入框
    @IBOutlet private var passwordTextField: UITextField!
    // 显示隐藏密码按钮
    @IBOutlet private var showPsdBtn: UIButton!

    @IBOutlet var lineView: UIView!

    private let disposeBag = DisposeBag()

    @IBInspectable public var placeholder: String = "输入密码" {
        didSet {
            passwordTextField.placeholder = placeholder
        }
    }

    /// 密码订阅
    public var passwordTextObservable: Observable<String> {
        return passwordTextField.rx.text.orEmpty.asObservable()
    }

    /// 密码
    public var password: String {
        passwordTextField.text ?? ""
    }

    /// 清理密码
    public func clearPassword() {
        passwordTextField.text = ""
    }

    /// 是否是空
    public var isEmpty: Bool {
        password.isEmpty
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }

    private final func loadViewFromNib() {
       
        let nib = UINib(nibName: Self.identifier, bundle: UIKitCommon.resourceBundle(type: .components))
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = bounds
        lineView.backgroundColor = UIColor.hexColor("EBEDF0")
        addSubview(contentView)

        // 隐藏显示密码
        showPsdBtn.rx.tap.subscribe { [weak self] event in
            guard let self = self else {
                return
            }
            if case .next() = event {
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
                self.showPsdBtn.isSelected = !self.showPsdBtn.isSelected
            }
        }.disposed(by: disposeBag)

        #if DEBUG
            passwordTextField.text = "a123456"
        #endif
    }
}

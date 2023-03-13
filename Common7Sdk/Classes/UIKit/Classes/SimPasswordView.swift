import UIKit
import RxSwift

public class SimPasswordView: UIView {
    //容器
    @IBOutlet private var contentView: UIView!
    //密码输入框
    @IBOutlet private weak var passwordTextField: UITextField!
    //显示隐藏密码按钮
    @IBOutlet private weak var showPsdBtn: UIButton!
    
    @IBOutlet weak var lineView: UIView!
    
    private let disposeBag = DisposeBag()
    
    @IBInspectable public var placeholder: String = "输入密码" {
        didSet {
            self.passwordTextField.placeholder = placeholder
        }
    }
    
    /// 密码订阅
    public var passwordTextObservable: Observable<String> {
        return self.passwordTextField.rx.text.orEmpty.asObservable()
    }
    
    /// 密码
    public var password: String {
        self.passwordTextField.text ?? ""
    }
    
    /// 清理密码
    public func clearPassword() {
        self.passwordTextField.text = ""
    }
    
    /// 是否是空
    public var isEmpty: Bool {
        password.isEmpty
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadViewFromNib()
    }
    
    
    private final func loadViewFromNib() {
        
        let nib = UINib(nibName: Self.identifier, bundle: UIKitCommon.resourceBundle(type: .components))
        self.contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        self.contentView.frame = bounds
        lineView.backgroundColor = UIColor.hexColor("EBEDF0")
        self.addSubview(self.contentView)
        
        //隐藏显示密码
        showPsdBtn.rx.tap.subscribe { [weak self]event in
            guard let self = self else {
                return
            }
            if case .next() = event {
                self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
                self.showPsdBtn.isSelected = !self.showPsdBtn.isSelected
            }
        }.disposed(by: disposeBag)
        
        #if DEBUG
        self.passwordTextField.text = "a123456"
        #endif
    }
}

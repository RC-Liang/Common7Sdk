import UIKit
import RxCocoa

public class SimUserAgreementView: UIView {
    
    public func configURL(privatePolicy: String?, userPolicy: String?) {
        self.privatePolicy = privatePolicy
        self.userPolicy = userPolicy
    }
    
    var privatePolicy: String?
    var userPolicy: String?

    // 容器
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet weak var agreeBtn: UIButton!
    
    @IBOutlet weak var privateBtn: UIButton!
    
    @IBOutlet weak var userBtn: UIButton!
    
    public var isAgree = false {
        didSet {
            if self.isAgree {
                self.agreeBtn.tintColor = UIKitCommon.ThemeColor
                self.agreeBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            }else {
                self.agreeBtn.tintColor = .hexColor("333333")
                self.agreeBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }
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
        self.addSubview(self.contentView)
        
        privateBtn.setTitleColor(UIKitCommon.ThemeColor, for: .normal)
        userBtn.setTitleColor(UIKitCommon.ThemeColor, for: .normal)
        
        _ = agreeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.isAgree = !self.isAgree
        })
    }
    
    
    @IBAction func privateAgreementAction(_ sender: UIButton) {
        SimWebViewController(title: "隐私协议", path: privatePolicy).show()
    }
    
    @IBAction func userAgreementAction(_ sender: UIButton) {
        SimWebViewController(title: "用户协议", path: userPolicy).show()
    }
    
}

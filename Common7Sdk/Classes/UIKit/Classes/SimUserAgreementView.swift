import RxCocoa
import UIKit

public class SimUserAgreementView: UIView {
    public func configURL(privatePolicy: String?, userPolicy: String?) {
        self.privatePolicy = privatePolicy
        self.userPolicy = userPolicy
    }

    var privatePolicy: String?
    var userPolicy: String?

    // 容器
    @IBOutlet private var contentView: UIView!

    @IBOutlet var agreeBtn: UIButton!

    @IBOutlet var privateBtn: UIButton!

    @IBOutlet var userBtn: UIButton!

    public var isAgree = false {
        didSet {
            if self.isAgree {
                self.agreeBtn.tintColor = UIKitCommon.ThemeColor
                if #available(iOS 13.0, *) {
                    self.agreeBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                }
                
            } else {
                self.agreeBtn.tintColor = .hexColor("333333")
                if #available(iOS 13.0, *) {
                    self.agreeBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                }
            }
        }
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
        addSubview(contentView)

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
        RCWebViewController(title: "隐私协议", path: privatePolicy).show()
    }

    @IBAction func userAgreementAction(_ sender: UIButton) {
        RCWebViewController(title: "用户协议", path: userPolicy).show()
    }
}

import UIKit
import RxSwift
import RxCocoa

@IBDesignable
public class MobileView: UIView {
    
    /// 背景颜色
    @IBInspectable public var bgColor: UIColor = .white {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    //容器
    @IBOutlet private var contentView: UIView!
    //country
    @IBOutlet weak var countryBtn: UIButton!
    //手机号
    @IBOutlet public weak var mobileTextField: SimMobileTextField!
    
    @IBOutlet weak var rowView: UIView!
    
    @IBOutlet weak var lineView: UIView!
    
    private let disposeBag = DisposeBag()
    
    //手机号
    public var mobileObservable: Observable<String> {
        return self.mobileTextField.rx.text.orEmpty.asObservable()
    }
    
    /// 数据值
    public var mobileText: String {
        return self.mobileTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
    }
    
    /// 是否为空
    public var isEmpty: Bool {
        self.mobileText.isEmpty
    }
    
    /// 编辑状态
    public var searchTextFieldStatusObservable = PublishSubject<SimSearchStatus>()
    
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
        rowView.backgroundColor = UIColor.hexColor("EBEDF0")
        lineView.backgroundColor = UIColor.hexColor("EBEDF0")
        self.addSubview(self.contentView)
        
        #if DEBUG
        mobileTextField.text = "16666666666"
        #endif
    }
}

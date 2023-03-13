import UIKit
import RxSwift
import RxCocoa

@IBDesignable public class SimSmsCodeView: UIView {
    
    /// 背景颜色
    @IBInspectable public var bgColor: UIColor = .white {
        didSet {
            self.contentView.backgroundColor = bgColor
        }
    }
    
    //容器
    @IBOutlet private var contentView: UIView!
    //验证码输入框
    @IBOutlet weak var smsCodeTextField: UITextField!
    
    //发送按钮
    @IBOutlet public weak var sendCodeBtn: UIButton!
    
    @IBOutlet weak var lineView: UIView!
    
    ///输入框订阅
    public var smsCodeTextObservable: Observable<String> {
        return self.smsCodeTextField.rx.text.orEmpty.asObservable()
    }
    
    ///发送验证码订阅
    public var smsCodeSendObservable: Observable<Void> {
        return self.sendCodeBtn.rx.tap.asObservable()
    }
    
    public func smsCodeValue() -> Int? {
        guard let inputText = smsCodeTextField.text else {
            return nil
        }
        return Int(inputText) ?? nil
    }
    
    /// 是否为空值
    public var isEmpty: Bool {
        smsCodeTextField.text?.isEmpty == true
    }
    
    /// 倒计时
    var countdown = DisposeBag()
    public func configCountdown(countdown: Observable<Void>) {
        self.countdown = DisposeBag()
        countdown.subscribe(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.beginCountdown()
        }).disposed(by: self.countdown)
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
        
        if UIKitCommon.ThemeColor != nil {
            sendCodeBtn.setTitleColor(UIKitCommon.ThemeColor, for: .normal)
        }
    }
    
    var timer: DisposeBag?
    
    /// 开始倒计时
    public func beginCountdown() {
        self.timer = DisposeBag()
        self.sendCodeBtn.isEnabled = false
        // 时间定时器
        var time = 60
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).subscribeNext { [weak self] _ in
            time -= 1
            self?.sendCodeBtn.setTitle("重新获取(\(time))", for: .normal)
            if time == 1 {
                self?.sendCodeBtn.isEnabled = true
                self?.sendCodeBtn.setTitle("获取验证码", for: .normal)
                self?.timer = nil
            }
        }.disposed(by: self.timer!)
    }
}

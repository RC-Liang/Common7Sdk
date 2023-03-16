import UIKit
import RxSwift

class PayPasswordView: UIView {
    
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var inputTF: SimPayPasswordTextFiled!
    
    @IBOutlet var codes: [UILabel]!
    
    /// 结束输入
    var endInput: ((_ psd: String) -> Void)?
    
    var changeInput: ((_ pwd: String) -> Void)?
    
    @IBInspectable var autoShowKeyboard: Bool = false {
        didSet {
            if autoShowKeyboard {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.inputTF.becomeFirstResponder()
                }
            }
        }
    }
    
    /// 垃圾袋
    private let disposeBag = DisposeBag()

    override init(frame: CGRect = .zero) {
        let width = CGFloat(50 * 6 + 40)
        let rect = CGRect(x: (UIScreen.main.bounds.width - width) / 2, y: 0, width: width, height: 59)
        super.init(frame: rect)
        self.loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadViewFromNib()
    }
    
    private final func loadViewFromNib() {
        let nib = UINib(nibName: Self.identifier, bundle: UIKitCommon.resourceBundle(type: .components))
        contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        contentView.frame = bounds
        self.addSubview(contentView)
        
        configTF()
    }
    
    func clearInput() {
        codes.forEach {
            $0.text = ""
        }
        inputTF.text = ""
    }
    
    func configTF() {
        inputTF.delegate = self
        // TODO: 原因不清楚
//        inputTF.rx.text.orEmpty.subscribeNext { [weak self] text in
//            guard let self = self else {
//                return
//            }
//
//            for (idx, label) in self.codes.enumerated() {
//                if idx < text.count {
//                    label.text = "●"
//                }else {
//                    label.text = ""
//                }
//            }
//
//            if text.count >= 6 {
//                self.endInput?(text.subString(to: 6))
//            }
//        }.disposed(by: disposeBag)
    }
}

extension PayPasswordView: UITextFieldDelegate {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard var text = textField.text else {
            return true
        }
        
        let newValue: NSMutableString = NSMutableString(string: textField.text ?? "")
        newValue.replaceCharacters(in: range, with: string)
        let value: String = newValue as String
        if value.count > 6 {
            return false
        }
        
        changeInput?(value)

        if string == "" {
            if text.count <= codes.count {
                codes[text.count - 1].text = ""
            }
        } else {
            text += string
            if text.count <= codes.count {
                codes[text.count - 1].text = "●"
            }
            if text.count == 6 {
                textField.text = text
                endInput?(text.subString(to: 6))
            }
        }

        return true
    }
}

class SimPayPasswordTextFiled: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

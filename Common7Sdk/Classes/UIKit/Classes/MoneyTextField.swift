import UIKit

public class SimMoneyDelegateObject: NSObject, UITextFieldDelegate {
    var maxNumber: Float = 100000.0
    var minNumber: Float = 0.0
    static let shared = SimMoneyDelegateObject()

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Float(textField.text! + string) ?? 0 > maxNumber {
            return false
        }
        if Float(textField.text! + string) ?? 0 < minNumber {
            return false
        }

        if !(string == "") && !(string == ".") {
            let pattern = "^[0-9]"
            let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
            if !pred.evaluate(with: string) {
                return false
            }
        }

        var maxLength = 6

        // 判断第一位
        if range.location == 0 {
            if string == "." {
                textField.text = "0."
                return false
            }
        }

        //
        if range.location == 1 {
            // 如果第一位是0则替换
            if textField.text == "0" {
                // 替换为0 则不变
                if string == "0" {
                    return false
                } else if string == "." {
                    return true
                }

                textField.text = string
                return false
            }
        }

        // 只能输入一个小数点
        if string == "." {
            maxLength += 1
            if textField.text?.contains(".") == true {
                return false
            }
        }

        if textField.text?.contains(".") == true {
            maxLength += 3
            
            
            
            let pointRange = ((textField.text ?? "") as NSString).range(of: ".")//(textField.text ?? "" as NSString).range(of: ".") // "".nsRange(from: (textField.text?.range(of: "."))!)
            // 小数点后只允许输入两位
            if range.location - pointRange.location > 2 {
                return false
            }
        }

        if range.location > maxLength {
            return false
        }

        return true
    }
}

public class MoneyTextField: UITextField {
    public var maxNumber: Float! {
        didSet {
            obj.maxNumber = maxNumber
        }
    }

    public var minNumber: Float! {
        didSet {
            obj.minNumber = minNumber
        }
    }

    var obj: SimMoneyDelegateObject = SimMoneyDelegateObject()
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        delegate = obj
        keyboardType = .decimalPad
        textColor = UIColor.hexColor("131111")
        tintColor = UIColor.hexColor("131111")
    }
    
    public init() {
        super.init(frame: .zero)
        delegate = obj
        keyboardType = .decimalPad
        textColor = UIColor.hexColor("131111")
        tintColor = UIColor.hexColor("131111")
    }
}

import Foundation

public class MobileTextField: UITextField {
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
}

extension MobileTextField: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        
        if string.isEmpty {
            switch range.location {
            case 4, 9:
                textField.text?.removeLast()
            default:
                break
            }
            return true
        }
        
        let text = textField.text ?? ""
        switch text.filter({ !$0.isWhitespace }).count {
        case 3, 7:
            textField.text = text + " "
        case 11:
            return false
        default:
            break
        }
        
        return true
    }
}

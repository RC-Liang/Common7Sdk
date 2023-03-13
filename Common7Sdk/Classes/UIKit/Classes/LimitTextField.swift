import UIKit

public class LimitTextField: UITextField {

    //限制字符
    @IBInspectable public var limitCount: Int = 100 {
        didSet {
            self._configLimitCount()
        }
    }
    
    private func _configLimitCount() {
        _ = self.rx.controlEvent(.editingChanged).subscribe { [weak self]_ in
            if let self = self {
                if self.text!.count > self.limitCount {
                    self.text = String(self.text!.prefix(self.limitCount))
                }
            }
        }
    }

}

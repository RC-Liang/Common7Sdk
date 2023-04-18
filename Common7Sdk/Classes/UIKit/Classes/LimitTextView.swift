import RxCocoa
import RxSwift
import UIKit

public class SimLimitTextView: UITextView {
   
    // 限制字符
    @IBInspectable public var limitCount: Int = 100 {
        didSet {
            _configLimitCount()
        }
    }

    private func _configLimitCount() {
        _ = rx.didChange.subscribe { [weak self] _ in
            if let self = self {
                if self.text!.count > self.limitCount {
                    self.text = String(self.text!.prefix(self.limitCount))
                }
            }
        }
    }
}

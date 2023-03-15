
import UIKit

extension UIView {
    // 获取view所在的 视图控制器
    var viewController: UIViewController? {
        var nextResponder = next
        while nextResponder != nil {
            if nextResponder is UIViewController {
                return nextResponder as! UIViewController?
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    // 获取view所在的 导航控制器
    var navController: UINavigationController? {
        var nextResponder = next
        while nextResponder != nil {
            if nextResponder is UINavigationController {
                return nextResponder as! UINavigationController?
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }

    // 获取view所在的 标签控制器
    var tabBarController: UITabBarController? {
        var nextResponder = next
        while nextResponder != nil {
            if nextResponder is UITabBarController {
                return nextResponder as! UITabBarController?
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}

@IBDesignable public extension UIView {
    
    // MARK: =========== border
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    // MARK: =========== shadow

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var masksToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
}

public extension UIView {
  
    /// left coordinate
    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set(left) {
            frame.origin.x = left
        }
    }

    /// right coordinate
    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set(right) {
            frame.origin.x = right - frame.size.width
        }
    }

    /// top coordinate
    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set(top) {
            frame.origin.y = top
        }
    }

    /// bottom coordinate
    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set(bottom) {
            frame.origin.y = bottom - frame.size.height
        }
    }

    /// width
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(width) {
            frame.size.width = width
        }
    }

    /// height
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set(height) {
            frame.size.height = height
        }
    }

    /// x axis coordinate
    var centerX: CGFloat {
        get {
            return center.x
        }
        set(x) {
            center.x = x
        }
    }

    /// y axis coordinate
    var centerY: CGFloat {
        get {
            return center.y
        }
        set(y) {
            center.x = y
        }
    }
}

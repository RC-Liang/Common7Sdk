
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

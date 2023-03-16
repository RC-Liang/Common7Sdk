import UIKit
import MBProgressHUD

public class UIKitCommon {
    
    public static let screenWidth = UIScreen.main.bounds.width
    public static let screenHeight = UIScreen.main.bounds.height
    
    private static let window = UIApplication.shared.windows.first
    public static let safeBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
    public static let safeTop: CGFloat = window?.safeAreaInsets.top ?? 0
    
    /// 获取状态栏高度
    public static func statusBarHeight() -> CGFloat {
        var height: CGFloat
        if #available(iOS 13.0,*) {
            let windowScene = UIApplication.shared.windows.first?.windowScene
            height = windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        } else {
            height = UIApplication.shared.statusBarFrame.height
        }
        return height
    }
    
    /// 获取  keyWindow
    
    public static func keyWindow() -> UIWindow? {
       
        let windows = UIApplication.shared.windows
        
        if windows.count == 1 { return windows.first }
        
        for window in UIApplication.shared.windows {
            if window.windowLevel == UIWindow.Level.normal { 
                return window
            }
        }
        return nil
    }
    
    /// 获取 -> 根viewController

    public static func rootViewController() -> UIViewController? {
       
        if #available(iOS 13.0, *) {
           
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowScene = (scene as? UIWindowScene),
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                return nil
            }

            return rootViewController

        } else {
            
            guard let window: UIWindow = UIApplication.shared.windows.first else {
                return nil
            }
            
            return window.rootViewController
        }
    }
    
    /// 获取当前viewController 循环取
    
    public static func currentViewController() -> UIViewController? {
        
        guard let rootViewController = UIKitCommon.rootViewController() else {
            return nil
        }
        
        var currentVC: UIViewController? = rootViewController
        
        while true {
            
            guard let currentViewController = currentVC else {
                return nil
            }
            
            guard currentViewController.presentedViewController == nil else {
                return currentViewController.presentedViewController
            }
            
            if currentViewController.isKind(of: UINavigationController.classForCoder()) {
                guard let navigationController: UINavigationController = currentViewController as? UINavigationController else {
                    return nil
                }
                currentVC = navigationController.visibleViewController
            } else if currentViewController.isKind(of: UITabBarController.classForCoder()) {
                
                guard let tabBarController: UITabBarController = currentViewController as? UITabBarController,
                      let selectedViewController = tabBarController.selectedViewController else {
                    return nil
                }
                currentVC = selectedViewController
            } else {
                break
            }
        }
        
        return currentVC
    }
    
    /// 获取当前viewController 循环取
    
    public static func currentVC() -> UIViewController? {
        
        // 获取 rootViewController
        guard let rootViewController = UIKitCommon.rootViewController() else {
            return nil
        }
        
        // present
        if rootViewController.presentedViewController != nil {
           
            guard let presentedViewController = rootViewController.presentedViewController else {
                return nil
            }
            
            // navigationController
            if presentedViewController.isKind(of: UINavigationController.classForCoder()) {
               
                guard let navigationController: UINavigationController = presentedViewController as? UINavigationController else {
                    return nil
                }
                return navigationController.visibleViewController
            }
            
            // tabBarController
            if presentedViewController.isKind(of: UITabBarController.classForCoder()) {
               
                guard let tabBarController: UITabBarController = presentedViewController as? UITabBarController,
                      let selectedViewController = tabBarController.selectedViewController else {
                    return nil
                }
                
                if selectedViewController.isKind(of: UINavigationController.classForCoder()) {
                    guard let navigationController: UINavigationController = selectedViewController as? UINavigationController  else {
                        return nil
                    }
                    return navigationController.visibleViewController
                }
                return selectedViewController
            }
            
            return presentedViewController
        }

        // 非 present
        // tabBarController
        if rootViewController.isKind(of: UITabBarController.classForCoder()) {

            guard let tabBarController: UITabBarController = rootViewController as? UITabBarController,
                  let selectedViewController = tabBarController.selectedViewController else {
                return nil
            }
            
            if selectedViewController.isKind(of: UINavigationController.classForCoder()) {
                guard let navigationController: UINavigationController = selectedViewController as? UINavigationController  else {
                    return nil
                }
                return navigationController.visibleViewController
            }
            return selectedViewController
        }

        // navigationController
        if rootViewController.isKind(of: UINavigationController.classForCoder()) {
            guard let navigationController: UINavigationController = rootViewController as? UINavigationController else {
                return nil
            }
            if let tabBarController: UITabBarController = navigationController.visibleViewController as? UITabBarController,
                let selectedViewController = tabBarController.selectedViewController {
                return selectedViewController
            }
            
            return navigationController.visibleViewController
        }
        
        return rootViewController
    }
    
    public static func cornerRadius(view: UIView, radius: CGFloat, corner: UIRectCorner? = nil) {
        
        guard radius > 0 else {
            return
        }
        
        let rectCorner = (corner == nil ? [.topLeft, .topRight, .bottomLeft, .bottomRight] : corner)!
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.frame = view.bounds
        view.layer.mask = shapeLayer
    }
}

/// HUD
extension UIKitCommon {
    
    public typealias Completion = (() -> Void)?
    
    public static func showText(_ text: String, completion: Completion = nil) {
        DispatchQueue.main.async {
            self.showText(text, time: 2, completion: completion)
        }
    }
    
    public static func showText(_ text: String, time: Double, completion: Completion = nil) {
       
        DispatchQueue.main.async {
            guard let containerView = keyWindow() else {
                return
            }
            
            let hud = MBProgressHUD.showAdded(to: containerView, animated: true)
            hud.label.text = text
            hud.label.numberOfLines = 0
            hud.mode = .text
            hud.contentColor = .white
            hud.bezelView.style = .solidColor
            hud.bezelView.layer.cornerRadius = 20
            hud.bezelView.layer.masksToBounds = true
            hud.bezelView.backgroundColor = UIColor.hexColor("333333")
            hud.removeFromSuperViewOnHide = true
            hud.show(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                hud.hide(animated: true)
                completion?()
            }
        }
    }
    
    public static func hide() {
        
        DispatchQueue.main.async {
            guard let containerView = keyWindow() else {
                return
            }
            
            MBProgressHUD.hide(for: containerView, animated: true)
        }
    }
    
    public static func showLoading(text: String? = nil, inWindow: Bool = false) {
        DispatchQueue.main.async {
            guard let container = self.keyWindow() else {
                return
            }
            
            if let _ = MBProgressHUD.forView(container) {
                return
            }
            
            let indicator = UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self])
            indicator.color = .white
            
            let hud = MBProgressHUD.showAdded(to: container, animated: true)
            hud.mode = MBProgressHUDMode.indeterminate
            hud.animationType = .zoom
            hud.removeFromSuperViewOnHide = true
            hud.bezelView.layer.cornerRadius = 14
            hud.bezelView.style = .solidColor
            hud.bezelView.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            hud.detailsLabel.text = text
            hud.detailsLabel.numberOfLines = 0
            hud.detailsLabel.textColor = .white
        }
    }
}


// MARK: - Color
public extension UIKitCommon {
    /// 主题色
    static let ThemeColor = UIKitCommon.configure?.themeColor
    /// 主题文本颜色
    
    /// 主题背景色
}

public struct UIKitConfigure {
    
    /// 主题色
    public var themeColor: UIColor = UIColor.hexColor("333333")
    
    /// 用户默认头像
    public var userDefault: UIImage?
    
    public init(themeColor: UIColor, userDefault: UIImage?) {
        self.themeColor = themeColor
        self.userDefault = userDefault
    }
}



public extension UIKitCommon {
    static var configure: UIKitConfigure?
    
    static func configUI(configure: UIKitConfigure) {
        UIKitCommon.configure = configure
    }
}

// MARK: - Bundle

enum UIKitCommonBundle: String {
    case common = "Common"
    case components = "Components"
}

extension UIKitCommon {
    
    static func resourceBundle(type: UIKitCommonBundle) -> Bundle? {
        return UIKitCommon.resourceBundle(type.rawValue)
    }
    
    static func resourceBundle(_ bundleString: String) -> Bundle? {
        
        guard let url = Bundle(for: UIKitCommon.self).url(forResource: bundleString, withExtension: "bundle"),
              let bundle = Bundle(url: url)
        else {
            return nil
        }
        
        return bundle
        
    }
}

import UIKit

public class UIKitCommon {
    
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
}

import Foundation
import RxSwift
import RxCocoa

public extension UIViewController {
    
    func back(block: (() -> Void)? = nil) {
        
        if let buttonItem  = navigationItem.leftBarButtonItem?.customView as? UIButton {
            
            // 取消上次的监听
            disposable?.dispose()
            // 重新添加新监听
            _ = buttonItem.rx.tap.subscribe(onNext: { [weak self] _ in
                block?()
                self?.popViewController()
            })
        } else {
            block?()
            self.popViewController()
        }
    }
    
    func pushViewController(_ controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        if navigationController?.viewControllers.count ?? 0 > 0 {
            let buttonItem = backButton()
            controller.disposable = buttonItem.rx.tap.subscribe(onNext: { _ in
                controller.popViewController()
                controller.disposable?.dispose()
            })
            controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonItem)
        } else {
            controller.navigationItem.leftBarButtonItem = nil
        }
        
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion?() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }

    func popViewController(toRoot: Bool = false, animated: Bool = true) {
        if toRoot {
            navigationController?.popToRootViewController(animated: animated)
        } else {
            navigationController?.popViewController(animated: animated)
        }
    }

    /// 移除指定controller
    func removeAppointController<T: UIViewController>(type: T.Type) {
        guard var controllers = navigationController?.viewControllers else {
            return
        }

        if let targetVc = controllers.last(where: { $0.isKind(of: T.self) }) {
            controllers.remove(targetVc)
        }
        navigationController?.setViewControllers(controllers, animated: false)
        // self.navigationController?.viewControllers = controllers
    }

    /// 移除指定controller
    func removeAppointControllers(types: [UIViewController.Type]) {
        guard var controllers = navigationController?.viewControllers else {
            return
        }
        types.forEach { type in
            if let index = controllers.firstIndex(where: { $0.isKind(of: type.self) }) {
                controllers.remove(at: index)
            }
        }

        navigationController?.setViewControllers(controllers, animated: false)
    }

    fileprivate func backButton() -> UIButton {
        // MARK: 返回按钮
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor.black
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        button.contentHorizontalAlignment = .left
        
        return button
    }
    
    /// 添加图片按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - isLeft: 位置
    ///   - tapAction: 点击事件
    func addBarButtonItem(image: UIImage?, isLeft: Bool = false, _ tapAction: @escaping () -> Void) {
       
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
            tapAction()
        })

        let barItem = UIBarButtonItem(customView: button)

        if isLeft {
            var leftBarItems = navigationItem.leftBarButtonItems ?? []
            leftBarItems.append(barItem)
            navigationItem.leftBarButtonItems = leftBarItems
        } else {
            var rightBarItems = navigationItem.rightBarButtonItems ?? []
            rightBarItems.append(barItem)
            navigationItem.rightBarButtonItems = rightBarItems
        }
    }

    /// 添加文字按钮
    /// - Parameters:
    ///   - text: 文字
    ///   - isLeft: 位置
    ///   - tapAction: 点击事件
    func addBarButtonItem(text: String, isLeft: Bool = false, _ tapAction: @escaping () -> Void) {
        let button = UIButton(type: .custom)
        button.setTitle(text, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { _ in
            tapAction()
        })

        let barItem = UIBarButtonItem(customView: button)
        
        if isLeft {
            var leftBarItems = navigationItem.leftBarButtonItems ?? []
            leftBarItems.append(barItem)
            navigationItem.leftBarButtonItems = leftBarItems
        } else {
            var rightBarItems = navigationItem.rightBarButtonItems ?? []
            rightBarItems.append(barItem)
            navigationItem.rightBarButtonItems = rightBarItems
        }
    }
}

public extension UIViewController {
    
    private struct AssociatedKeys {
        static var disposable = "Disposable_dis"
        static var showBackButton = "showBackButton_btn"
    }
    
    private var disposable: Disposable? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.disposable) as? Disposable }
        set { objc_setAssociatedObject(self, &AssociatedKeys.disposable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var showBackButton: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.showBackButton) as? Bool ?? true }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.showBackButton, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if showBackButton {
                if let buttonItem  = navigationItem.leftBarButtonItem?.customView as? UIButton {
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonItem)
                } else {
                    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton())
                }
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
}


// MARK: - 导航栏颜色相关

public extension UIViewController {
    // 重置导航栏颜色
    func resetNavigationBarColor() {
        if navigationController?.navigationBar.standardAppearance.backgroundColor == .clear {
            return
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        appearance.backgroundEffect = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // 导航栏白色
    func whiteNavigationBar() {
        if navigationController?.navigationBar.standardAppearance.backgroundColor == UIColor.hexColor("#FFFFFF", alpha: 0.8) {
            return
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.hexColor("#FFFFFF", alpha: 0.8)
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        appearance.backgroundEffect = UIBlurEffect(style: .light)

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }

    // 设置导航栏
    func setNavigationBarColor(_ color: UIColor) {
        if navigationController?.navigationBar.standardAppearance.backgroundColor == color {
            return
        }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        if color == .clear {
            appearance.backgroundEffect = nil
        } else {
            appearance.backgroundEffect = UIBlurEffect(style: .light)
        }

        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }

    func setNavigationTitleColor(_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

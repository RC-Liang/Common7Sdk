import Foundation

public extension UIViewController {
    
    func pushViewController(controller: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        
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

    /// 添加图片按钮
    /// - Parameters:
    ///   - image: 图片
    ///   - isLeft: 位置
    ///   - tapAction: 点击事件
    func addImageNaviButton(image: UIImage?, isLeft: Bool = false, _ tapAction: @escaping () -> Void) {
        let naviBtn = UIButton(type: .custom)
        naviBtn.tintColor = .hexColor("333333")
        naviBtn.setImage(image, for: .normal)
        _ = naviBtn.rx.controlEvent(.touchUpInside).subscribeNext { _ in
            tapAction()
        }

        let barItem = UIBarButtonItem(customView: naviBtn)

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
    func addTextNaviButton(text: String, isLeft: Bool = false, _ tapAction: @escaping () -> Void) {
        let naviBtn = UIButton(type: .custom)
        naviBtn.setTitle(text, for: .normal)
        naviBtn.setTitleColor(.hexColor("212424"), for: .normal)
        naviBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        _ = naviBtn.rx.controlEvent(.touchUpInside).subscribeNext { _ in
            tapAction()
        }

        let barItem = UIBarButtonItem(customView: naviBtn)
        if isLeft {
            navigationItem.leftBarButtonItem = barItem
        } else {
            navigationItem.rightBarButtonItem = barItem
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

import UIKit

public class TabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 设置 tabBar 选中和非选中 字体颜色
        tabBar.unselectedItemTintColor = .hexColor("#CCCCCC")
        tabBar.tintColor = .hexColor("212021")
        
        // 针对iOS 15.0 以上, 设置tableview group 的 top padding
        if #available(iOS 15.0, *) {
            UITableView.appearance().fillerRowHeight = 0
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        setTabBarBackgroundColor(UIKitCommon.navigationBarDefaultColor)
    }

    fileprivate func setTabBarBackgroundColor(_ color: UIColor) {

        let appearance = tabBar.standardAppearance
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear // 底部线的颜色
        appearance.shadowImage = UIImage.create(color: .clear)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        // 不加高斯模糊 使用再带高斯模糊效果
        // let effectView = UIVisualEffectView()
        // effectView.effect = UIBlurEffect(style: .light)
        // var frame = tabBar.bounds
        // frame.size.height = frame.size.height + UIKitCommon.safeBottom
        // effectView.frame = frame
        // tabBar.insertSubview(effectView, at: 0)
        
        //        insertImControllers()
        //
        //        self.viewControllers?.forEach {
        //            if let navi = $0 as? UINavigationController {
        //                navi.viewControllers.first?.view.setNeedsLayout()
        //            }
        //        }
    }
}

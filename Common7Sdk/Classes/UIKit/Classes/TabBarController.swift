import UIKit

public class TabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 设置 tabBar 选中和非选中 字体颜色
        tabBar.unselectedItemTintColor = .hexColor("#CCCCCC")
        tabBar.tintColor = .hexColor("212021")
        
        setTabBarBackgroundColor(UIColor.hexColor("#FFFFFF", alpha: 0.95))
    }

    fileprivate func setTabBarBackgroundColor(_ color: UIColor) {

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        let effectView = UIVisualEffectView()
        effectView.effect = UIBlurEffect(style: .light)
        var frame = tabBar.bounds
        frame.size.height = frame.size.height + UIKitCommon.safeBottom
        effectView.frame = frame
        tabBar.insertSubview(effectView, at: 0)
    }
}

import UIKit

public class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化 默认 带点透明度的 白色 
        let appearance = navigationBar.standardAppearance
        appearance.backgroundColor = UIKitCommon.navigationBarDefaultColor
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        if UIKitCommon.navigationBarDefaultColor == .clear {
            appearance.backgroundEffect = nil
        } else {
            appearance.backgroundEffect = UIBlurEffect(style: .extraLight)
        }
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

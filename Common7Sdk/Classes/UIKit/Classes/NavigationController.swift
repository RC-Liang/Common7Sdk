import UIKit

public class NavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage.create(color: .clear)
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

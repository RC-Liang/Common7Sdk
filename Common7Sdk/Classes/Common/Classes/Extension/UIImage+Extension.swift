import UIKit

public extension UIImage {
   
    static func bundle(image name: String, bundle: Bundle? = nil) -> UIImage? {
        if bundle != nil {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }

        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    // 根据颜色创建图片
    static func create(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return colorImage
    }
}

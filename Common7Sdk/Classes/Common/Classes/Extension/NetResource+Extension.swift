import Foundation
import Kingfisher

public enum PlaceholderSize {
    case small, middle, large
}

public extension UIImageView {
    
    func loadAvatar(url: String?, size: PlaceholderSize = .middle) {
    
        let placeholderImage = UIKitCommon.configure?.userDefault
        guard let url = url else {
            image = placeholderImage
            return
        }
        self.kf.setImage(with: URL(string: url), placeholder: placeholderImage)
    }

    func loadNetImage(url: String?, size: PlaceholderSize = .middle, placeholderImage: UIImage? = nil) {
       
        var placeholder = placeholderImage

        if placeholderImage == nil {
            placeholder = UIImage(named: "image_default", in: UIKitCommon.resourceBundle(type: .common), compatibleWith: nil)
        }

        guard let url = url else {
            image = placeholder
            return
        }
        self.kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
}

public extension UIButton {
    
    func loadAvatar(url: String?, size: PlaceholderSize = .middle, status: UIControl.State = .normal) {
       
        let placeholderImage = UIKitCommon.configure?.userDefault
        guard let url = url else {
            setImage(placeholderImage, for: status)
            return
        }
        self.kf.setImage(with: URL(string: url), for: status, placeholder: placeholderImage)
    }

    func loadNetImage(url: String?, size: PlaceholderSize = .middle, status: UIControl.State = .normal) {
      
        let placeholderImage = UIImage(named: "image_default", in: UIKitCommon.resourceBundle(type: .common), compatibleWith: nil)
        guard let url = url else {
            setImage(placeholderImage, for: status)
            return
        }
        self.kf.setImage(with: URL(string: url), for: status, placeholder: placeholderImage)
    }
}

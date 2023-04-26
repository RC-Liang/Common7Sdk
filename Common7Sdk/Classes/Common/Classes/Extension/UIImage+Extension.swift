import UIKit

public extension UIImage {
   
    static func bundle(image name: String, bundle: Bundle? = nil) -> UIImage? {
        if bundle != nil {
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }

        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }

    // 根据颜色创建图片
    static func create(color: UIColor, rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)) -> UIImage? {

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return colorImage
    }
    
    // 剪切图片大小
    func resize(_ size: CGSize) -> UIImage? {
        
        let factor = self.size.width / self.size.height
        
        UIGraphicsBeginImageContext(size)
        let size = CGRect(x: (size.width - size.height * factor) / 2, y: 0, width: size.height * factor, height: size.height)
        self.draw(in: size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    // 根据url获取图片
    static func from(_ path: String, resize: CGSize?) -> UIImage? {
      
        guard let imageUrl = URL(string: path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: imageUrl)
            let image = UIImage(data: data)
            
            guard let size = resize else { return image }
            return image?.resize(size)
            
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    static func from(_ path: String, resize: CGSize?, success: @escaping (_ image: UIImage?) -> Void) {
        
        let queue: DispatchQueue = DispatchQueue(label: "LoadImage")
        
        queue.async {
            let image =  self.from(path, resize:resize)
            DispatchQueue.main.async {
                success(image)
            }
        }
    }
}


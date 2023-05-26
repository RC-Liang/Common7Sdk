import UIKit

enum ImagePosition {
    case left
    case right
    case top
    case bottom
}

extension UIButton {
   
    /// 设置图片和文字之后 -> 调用，且button的大小要大于 图片大小+文字大小+spacing
    func setImagePosition(_ postion: ImagePosition = .left, spacing: CGFloat) {
    
        setTitle(currentTitle, for: .normal)
        setImage(currentImage, for: .normal)

        let imageSize: CGSize = imageView?.image?.size ?? .zero
        let labelSize: CGSize = titleLabel?.text?.size(constrained: .greatestFiniteMagnitude, font: titleLabel?.font ?? UIFont.systemFont(ofSize: 17)) ?? .zero

        // image中心移动的x距离
        let imageOffsetX: CGFloat = (imageSize.width + labelSize.width) / 2 - imageSize.width / 2
        // image中心移动的y距离
        let imageOffsetY: CGFloat = imageSize.height / 2 + spacing / 2
        // label中心移动的x距离
        let labelOffsetX: CGFloat = (imageSize.width + labelSize.width / 2) - (imageSize.width + labelSize.width) / 2
        // label中心移动的y距离
        let labelOffsetY: CGFloat = labelSize.height / 2 + spacing / 2

        let tempWidth: CGFloat = max(labelSize.width, imageSize.width)
        let changedWidth: CGFloat = labelSize.width + imageSize.width - tempWidth
        let tempHeight: CGFloat = max(labelSize.height, imageSize.height)
        let changedHeight: CGFloat = labelSize.height + imageSize.height + spacing - tempHeight

        switch postion {
        case .left:
            let padding = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: padding)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: -padding)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        case .right:
            let imagePadding = labelSize.width + spacing / 2
            let labelPadding = imageSize.width + spacing / 2
            let contentPadding = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: imagePadding, bottom: 0, right: -imagePadding)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -labelPadding, bottom: 0, right: labelPadding)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: contentPadding, bottom: 0, right: contentPadding)
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: -changedWidth / 2, bottom: changedHeight - imageOffsetY, right: -changedWidth / 2)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            contentEdgeInsets = UIEdgeInsets(top: changedHeight - imageOffsetY, left: -changedWidth / 2, bottom: imageOffsetY, right: -changedWidth / 2)
        }
    }
}

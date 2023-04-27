import UIKit

public extension CGPoint {
    init(x: CGFloat) {
        self.init(x: x, y: 0)
    }
    
    init(y: CGFloat) {
        self.init(x: 0, y: y)
    }
}

public extension CGSize {
    init(width: CGFloat) {
        self.init(width: width, height: 0)
    }
    
    init(height: CGFloat) {
        self.init(width: 0, height: height)
    }
}

public extension CGRect {
    
    init(width: CGFloat, height: CGFloat) {
        self.init(origin: .zero, size: CGSize(width: width, height: height))
    }
    
    init(x: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: x, y: 0, width: width, height: height)
    }
    
    init(y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: y, width: width, height: height)
    }
}

public extension UIEdgeInsets {
    
    //******************* 一边 边距 ************************
    init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
    
    init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }
    
    init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }
    
    init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }
    //*****************************************************
    
    //******************* 两边 边距 ************************
    
    init(left: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }
    
    init(top: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }
    /// 水平
    init(horizontal: CGFloat) {
        self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
    }
    /// 垂直
    init(vertical: CGFloat) {
        self.init(top: vertical, left: 0, bottom: vertical, right: 0)
    }
    
    //*****************************************************
    
    //******************* 三边 边距 ************************
    
    init(left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: bottom, right: right)
    }
    
    init(top: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.init(top: top, left: 0, bottom: bottom, right: right)
    }
    
    init(top: CGFloat, left: CGFloat, right: CGFloat) {
        self.init(top: top, left: left, bottom: 0, right: right)
    }
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: 0)
    }
    
    //*****************************************************
    
    //******************* 四边 边距一致 ************************
    // 边距一样
    init(edge: CGFloat) {
        self.init(top: edge, left: edge, bottom: edge, right: edge)
    }
    
    //*****************************************************
}

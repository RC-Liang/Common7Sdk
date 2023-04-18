import Foundation
import UIKit

public protocol IdentifierProtocol {
    static var identifier: String { get }
}

public extension IdentifierProtocol where Self: UIViewController {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

public extension IdentifierProtocol where Self: UIView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

public extension IdentifierProtocol where Self: NSObject {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension NSObject: IdentifierProtocol {}

/// 根据拼音排序协议
public protocol SortTitleProtocol {
    var pin_yin: String { get }
}

private var kPerformOnceKey: Void?

public extension NSObject {
    public var performOnceFlag: Bool {
        get {
            return objc_getAssociatedObject(self, &kPerformOnceKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &kPerformOnceKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public func performOnce(aselector: Selector) {
        if performOnceFlag {
            return
        }
        performOnceFlag = true
        perform(aselector)
    }

    public func performOnceBlock(aselector: () -> Void) {
        if performOnceFlag {
            return
        }
        performOnceFlag = true
        aselector()
    }
}

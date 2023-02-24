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

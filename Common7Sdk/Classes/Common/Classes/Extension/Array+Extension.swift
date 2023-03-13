import Foundation

public extension Array where Element: Equatable {
   
    mutating func update(_ object: Element) {
        if let index = firstIndex(of: object) {
            self[index] = object
        }
    }

    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

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
    
    /// 获取数组中的元素，增加了数组越界的判断
    func safeIndex(_ index: Int) -> Array.Iterator.Element? {
        guard !isEmpty, count > abs(index) else {
            return nil
        }
        
        for item in self.enumerated() {
            if item.offset == index {
                return item.element
            }
        }
        return nil
    }
}

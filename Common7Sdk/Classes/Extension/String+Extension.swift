import Foundation

public extension String {
    /// 从某个位置开始截取：
    /// - Parameter index: 起始位置
    func subString(from index: Int) -> String {
        if count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex ..< self.endIndex]
            return String(subString)
        } else {
            return ""
        }
    }
    
    /// 从零开始截取到某个位置：
    /// - Parameter index: 达到某个位置
    func subString(to index: Int) -> String {
        if count > index {
            let endindex = self.index(startIndex, offsetBy: index)
            let subString = self[self.startIndex ..< endindex]
            return String(subString)
        } else {
            return self
        }
    }
    
    /// 某个范围内截取
    /// - Parameter rangs: 范围
    func subString(rang: NSRange) -> String {
        var string = String()
        if (rang.location >= 0) && (count >= (rang.location + rang.length)) {
            let startIndex = index(self.startIndex, offsetBy: rang.location)
            let endIndex = index(self.startIndex, offsetBy: rang.location + rang.length)
            let subString = self[startIndex ..< endIndex]
            string = String(subString)
        }
        return string
    }
}

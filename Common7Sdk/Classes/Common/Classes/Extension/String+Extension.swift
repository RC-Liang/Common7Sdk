import Foundation

public extension String {
    /// 从某个位置开始截取：
    /// - Parameter index: 起始位置
    func subString(from index: Int) -> String {
        if count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex ..< endIndex]
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
            let subString = self[startIndex ..< endindex]
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

    func size(constrained width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.size
    }

    func height(constrained width: CGFloat, font: UIFont) -> CGFloat {
        return size(constrained: width, font: font).height
    }

    /// 中文转拼音
    func transformChinese() -> String {
        let str = NSMutableString(string: self) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) {
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) {
                return str as String
            }
        }
        print("transform faild !!")
        return ""
    }

    /// 首字母
    func firstLetter(uppercased: Bool = true) -> String {
        let letter = transformChinese().replacingOccurrences(of: " ", with: "")

        guard letter.count > 0, let first = letter.first else {
            return "#"
        }

        if uppercased {
            return first.uppercased()
        } else {
            return first.lowercased()
        }
    }
}

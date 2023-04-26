import Foundation
import CryptoKit

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
    
    /// md5加密
    func md5() -> String {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        return Insecure.MD5.hash(data: data).map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func size(constrained width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return boundingBox.size
    }

    func height(constrained width: CGFloat, font: UIFont) -> CGFloat {
        return size(constrained: width, font: font).height
    }
}

 
// extension String {
//
//     /// 给定最大宽计算高度，传入字体、行距、对齐方式（便捷调用）
//     func heightForLabel(width: CGFloat, font: UIFont, lineSpacing: CGFloat = 5, alignment: NSTextAlignment = .left) -> CGFloat {
//         let paragraphStyle = NSMutableParagraphStyle()
//         paragraphStyle.lineSpacing = lineSpacing
//         paragraphStyle.alignment = alignment
//         let attributes: [String : Any] = [
//             NSFontAttributeName: font,
//             NSParagraphStyleAttributeName: paragraphStyle
//         ]
//         let textSize = textSizeForLabel(width: width, height: CGFloat(Float.greatestFiniteMagnitude), attributes: attributes)
//         return textSize.height
//     }
//
//     /// 给定最大宽计算高度，传入属性字典（便捷调用）
//     func heightForLabel(width: CGFloat, attributes: [String: Any]) -> CGFloat {
//         let textSize = textSizeForLabel(width: width, height: CGFloat(Float.greatestFiniteMagnitude), attributes: attributes)
//         return textSize.height
//     }
//
//     /// 给定最大高计算宽度，传入字体（便捷调用）
//     func widthForLabel(height: CGFloat, font: UIFont) -> CGFloat {
//         let labelTextAttributes = [NSFontAttributeName: font]
//         let textSize = textSizeForLabel(width: CGFloat(Float.greatestFiniteMagnitude), height: height, attributes: labelTextAttributes)
//         return textSize.width
//     }
//
//     /// 给定最大高计算宽度，传入属性字典（便捷调用）
//     func widthForLabel(height: CGFloat, attributes: [String: Any]) -> CGFloat {
//         let textSize = textSizeForLabel(width: CGFloat(Float.greatestFiniteMagnitude), height: height, attributes: attributes)
//         return textSize.width
//     }
//
//     /// 给定最大宽高计算宽度和高度，传入字体、行距、对齐方式（便捷调用）
//     func textSizeForLabel(width: CGFloat, height: CGFloat, font: UIFont, lineSpacing: CGFloat = 5, alignment: NSTextAlignment = .left) -> CGSize {
//         let paragraphStyle = NSMutableParagraphStyle()
//         paragraphStyle.lineSpacing = lineSpacing
//         paragraphStyle.alignment = alignment
//         let attributes: [String : Any] = [
//             NSFontAttributeName: font,
//             NSParagraphStyleAttributeName: paragraphStyle
//         ]
//         let textSize = textSizeForLabel(width: width, height: height, attributes: attributes)
//         return textSize
//     }
//
//     /// 给定最大宽高计算宽度和高度，传入属性字典（便捷调用）
//     func textSizeForLabel(size: CGSize, attributes: [String: Any]) -> CGSize {
//         let textSize = textSizeForLabel(width: size.width, height: size.height, attributes: attributes)
//         return textSize
//     }
//
//     /// 给定最大宽高计算宽度和高度，传入属性字典（核心)
//     func textSizeForLabel(width: CGFloat, height: CGFloat, attributes: [String: Any]) -> CGSize {
//         let defaultOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
//         let maxSize = CGSize(width: width, height: height)
//         let rect = self.boundingRect(with: maxSize, options: defaultOptions, attributes: attributes, context: nil)
//         let textWidth: CGFloat = CGFloat(Int(rect.width) + 1)
//         let textHeight: CGFloat = CGFloat(Int(rect.height) + 1)
//         return CGSize(width: textWidth, height: textHeight)
//     }
// }


 /*
 extension NSAttributedString {
     
     /// 根据最大宽计算高度（便捷调用)
     func heightForLabel(width: CGFloat) -> CGFloat {
         let textSize = textSizeForLabel(width: width, height: CGFloat(Float.greatestFiniteMagnitude))
         return textSize.height
     }
     
     /// 根据最大高计算宽度（便捷调用)
     func widthForLabel(height: CGFloat) -> CGFloat {
         let textSize = textSizeForLabel(width: CGFloat(Float.greatestFiniteMagnitude), height: height)
         return textSize.width
     }
     
     /// 计算宽度和高度（核心)
     func textSizeForLabel(width: CGFloat, height: CGFloat) -> CGSize {
         let defaultOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
         let maxSize = CGSize(width: width, height: height)
         let rect = self.boundingRect(with: maxSize, options: defaultOptions, context: nil)
         let textWidth: CGFloat = CGFloat(Int(rect.width) + 1)
         let textHeight: CGFloat = CGFloat(Int(rect.height) + 1)
         return CGSize(width: textWidth, height: textHeight)
     }
 }
  
  */
 
  /*
 
 extension String {
     
     ///  寻找在 startString 和 endString 之间的字符串
     func substring(between startString: String, and endString: String?, options: String.CompareOptions = .caseInsensitive) -> String? {
         let range = self.range(of: startString, options: options)
         if let startIndex = range?.upperBound {
             let string = self.substring(from: startIndex)
             if let endString = endString {
                 let range = string.range(of: endString, options: options)
                 if let startIndex = range?.lowerBound {
                     return string.substring(to: startIndex)
                 }
             }
             return string
         }
         return nil
     }
     
     ///  寻找 prefix 字符串，并返回从 prefix 到尾部的字符串
     func substring(prefix: String, options: String.CompareOptions = .caseInsensitive, isContain: Bool = true) -> String? {
         let range = self.range(of: prefix, options: options)
         if let startIndex = range?.upperBound {
             var resultString = self.substring(from: startIndex)
             if isContain {
                 resultString = "\(prefix)\(resultString)"
             }
             return resultString
         }
         return nil
     }
     
     ///  寻找 suffix 字符串，并返回从头部到 suffix 位置的字符串
     func substring(suffix: String, options: String.CompareOptions = .caseInsensitive, isContain: Bool = false) -> String? {
         let range = self.range(of: suffix, options: options)
         if let startIndex = range?.lowerBound {
             var resultString = self.substring(to: startIndex)
             if isContain {
                 resultString = "\(resultString)\(suffix)"
             }
             return resultString
         }
         return nil
     }
     
     ///  从 N 位置到尾位置的字符串
     func substring(from: IndexDistance) -> String? {
         let index = self.index(self.startIndex, offsetBy: from)
         return self.substring(from: index)
     }
     
     ///  从头位置到 N 位置的字符串
     func substring(to: IndexDistance) -> String? {
         let index = self.index(self.startIndex, offsetBy: to)
         return self.substring(to: index)
     }
     
     /// 以 lower 为起点，偏移 range 得到的字符串
     func substring(_ lower: IndexDistance, _ range: IndexDistance) -> String? {
         let lowerIndex = self.index(self.startIndex, offsetBy: lower)
         let upperIndex = self.index(lowerIndex, offsetBy: range)
         let range = Range(uncheckedBounds: (lowerIndex, upperIndex))
         return self.substring(with: range)
     }
 }
 
 */

public extension String {
    
    // MARK: 匹配手机号
    func isMatchPhone() -> Bool {
        let mobile = "[\\+]?[0-9\\x20]{1,}"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        return predicate.evaluate(with: self) && self.count >= 7 && self.count <= 15
    }
    
    // MARK: 匹配url链接
    func isMatchUrl() -> Bool {
        let url = "((http://|https://|www.)+([:\\d+])?([\\w-./@?^=%&:;¤/~+#]*[\\w-@?^=%&/~+#])?)"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
    
    // MARK: 创建正则表达式
    func isMatch(pattern: String) -> Bool {
        return self.matches(pattern: pattern).count > 0
    }
    
    // MARK: 通过正则表达式匹配替换
    func replacing(string pattern: String, template: String) -> String {
        var content = self
        do {
            let range = NSRange(location: 0, length: content.count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            content = expression.stringByReplacingMatches(in: content, options: .reportCompletion, range: range, withTemplate: template)
        } catch {
            print("regular expression error")
        }
        return content
    }

    // MARK: 通过正则表达式匹配返回结果
    func matches(pattern: String) -> [NSTextCheckingResult] {
        do {
            let range = NSRange(location: 0, length: count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matchResults = expression.matches(in: self, options: .reportCompletion, range: range)
            return matchResults
        } catch {
            print("regular expression error")
        }
        return []
    }

    // MARK: 通过正则表达式返回第一个匹配结果
    func first(match pattern: String) -> NSTextCheckingResult? {
        do {
            let range = NSRange(location: 0, length: count)
            let expression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let match = expression.firstMatch(in: self, options: .reportCompletion, range: range)
            return match

        } catch {
            print("regular expression error")
        }
        return nil
    }
    
    func match(pattern: String) -> String {
        
        let matches = matches(pattern: pattern)
        var results = [String]()
        
        matches.forEach { match in
            for i in 0 ..< match.numberOfRanges {
                results.append(self.subString(rang: match.range(at: i)))
            }
        }
        
        var result = ""
        results.forEach { sub in
            result.append(sub)
        }
        return result
    }
}

/// 移除非数字字符串
public extension RangeReplaceableCollection where Self: StringProtocol {
    
    mutating func removeAllNonNumeric() {
        removeAll { !$0.isNumber }
    }
}

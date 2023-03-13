public extension UIColor {
    
    static func hexColor(_ value: String) -> UIColor {
        return hexColor(value, alpha: 1)
    }

    static func hexColor(_ value: String, alpha: CGFloat) -> UIColor {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0

        var hex: String = value.lowercased()
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        if hex.hasPrefix("0x") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }

        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0

        guard scanner.scanHexInt64(&hexValue) else {
            return UIColor.clear
        }

        if hex.count == 6 {
            r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(hexValue & 0x0000FF) / 255.0
        } else {
            return UIColor.clear
        }

        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

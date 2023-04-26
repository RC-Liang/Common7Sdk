
/// 写入文件

import HandyJSON
import UIKit

public protocol Cacheable: HandyJSON {
    
    static var identifier: String { get } // 标识 ，文件名字

    /// 保存
    @discardableResult
    func save() -> Bool
    /// 读取
    static func query() -> Self?
    /// 删除
    static func delete()
    func delete()
}

extension Cacheable {
   
    @discardableResult
    func save() -> Bool {
       
        guard let jsonStr = toJSONString(), let path = Self.localPath() else {
            return false
        }
        let jsonData = jsonStr.data(using: .utf8)

        do {
            try jsonData?.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            return false
        }
    }

    static func query() -> Self? {
        guard let path = Self.localPath(),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let jsonStr = String(data: data, encoding: .utf8)
        return JSONDeserializer<Self>.deserializeFrom(json: jsonStr)
    }
    
    static func delete() {
        self.delete()
    }
    
    func delete() {
        guard let path = Self.localPath() else {
            return
        }
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
            }
        }
    }

    static func localPath() -> String? {
        guard let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return nil
        }
        return documentDir + "/" + identifier + ".txt"
    }
}

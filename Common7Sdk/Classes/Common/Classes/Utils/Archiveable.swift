// 归档

import UIKit

public protocol Archiveable {
    
    static var identifier: String { get } // 标识 ，文件名字
   
    var archive: NSDictionary { get }
    init?(unarchive: NSDictionary?)
    
    /// 保存
    @discardableResult
    func save() -> Bool
    /// 读取
    static func query() -> Self?
    /// 删除
    @discardableResult
    static func delete() -> Bool
    
    @discardableResult
    func delete() -> Bool
}

extension Archiveable {
    
    static func localPath() -> String? {
        guard let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first else {
            return nil
        }
        return documentDir + "/" + identifier
    }
    
    // MARK: ============= objects archive
    
    @discardableResult
    func save() -> Bool {
        
        guard let path = Self.localPath() else {
            return false
        }
        
        do {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: self.archive, requiringSecureCoding: false)
            try data?.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    static func query() -> Self? {
        guard let path = Self.localPath() else {
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            guard let jsonDic = object as? NSDictionary else {
                return nil
            }
            return Self(unarchive: jsonDic)
        } catch {
            return nil
        }
    }
    
    /// 删除归档文件
    @discardableResult
    static func delete() -> Bool {
        self.delete()
    }
    
    @discardableResult
    func delete() -> Bool {
        guard let path = Self.localPath() else {
            return false
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    // ============================================
}

public struct ArchiveableUtils {

    // MARK: ============= objects archive

    @discardableResult
    public static func archiveObjects<T: Archiveable>(lists: [T]) -> Bool {
        guard let path = T.localPath() else {
            return false
        }

        let encodedLists = lists.map { $0.archive }
        
        do {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: encodedLists, requiringSecureCoding: false)
            try data?.write(to: URL(fileURLWithPath: path))
            return true
        } catch {
            print(error)
            return false
        }
    }

    public static func unarchiveObjects<T: Archiveable>() -> [T]? {
        guard let path = T.localPath() else {
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let list = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            guard let decodedLists = list as? [NSDictionary] else {
                return nil
            }
            return decodedLists.compactMap { return T(unarchive: $0) }
        } catch {
            return nil
        }
    }
}

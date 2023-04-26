import UIKit

extension CacheUtils {
    
    public static func fileSize() -> String {
        
        let size = getCacheSize()
        if size <= 10 {
            return "暂无缓存"
        }
        
        return fileSize(getCacheSize())
    }

    public static func clearCache() {
       
        // 取出cache文件夹目录
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first,
              let fileArr = FileManager.default.subpaths(atPath: cachePath) else {
            return
        }
        // 遍历删除
        fileArr.forEach { file in
            let path = (cachePath as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                }
            }
        }
    }
}


public struct CacheUtils {
    
    static let bytes: Double = 1000

    private static func getCacheSize() -> Double {
        // 取出cache文件夹目录
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            // 取出文件夹下所有文件数组
            let fileArr = FileManager.default.subpaths(atPath: cachePath)
            // 快速枚举出所有文件名 计算文件大小
            var size = 0
            for file in fileArr! {
                // 把文件名拼接到路径中
                let path = cachePath + "/\(file)"
                // 取出文件属性
                let floder = try! FileManager.default.attributesOfItem(atPath: path)
                // 用元组取出文件大小属性
                for (key, fileSize) in floder {
                    // 累加文件大小
                    if key == FileAttributeKey.size {
                        size += (fileSize as AnyObject).integerValue
                    }
                }
            }
            
            let totalCache = Double(size)
            
            return totalCache
        }
        return 0
    }
    
    // 根据数据计算出大小
    private static func fileSize(_ size: Double) -> String {
        if size == 0 {
            return ""
        } else if size < bytes {
            return String(format: "%.0fB", size)
        } else if size < bytes * bytes {
            return String(format: "%.0fK", size / bytes)
        } else if size < bytes * bytes * bytes {
            return String(format: "%.1fM", size / (bytes * bytes))
        } else {
            return String(format: "%.1fG", size / (bytes * bytes * bytes))
        }
    }
}

import UIKit

struct LocalLogUtils {
   
    static let queue = DispatchQueue(label: "writeData", qos: .background)
    
    public static func save(content: String, maxSize: Int = 5, directory: String = NSHomeDirectory(), fileName: String = "default.txt") {
        
        guard content.count > 0 else {
            return
        }
        
        queue.async {
            print(content)
            let path = self.createFile(directory: directory, fileName: fileName)
            let writeInfo = self.currentDate().appending(" ").appending(content).appending("\n")
            let writePath = deleteHalfContent(path: path, maxSize: maxSize)
            self.write(toPath: writePath, content: writeInfo)
        }
    }

    @discardableResult
    static func createFile(directory: String, fileName: String) -> String {
       
        let path = directory.appending("/").appending(fileName)

        if FileManager.default.fileExists(atPath: path) == false {
            if FileManager.default.fileExists(atPath: directory, isDirectory: nil) == false {
                do {
                    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("创建文件夹失败", directory, error)
                }
            }
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return path
    }

    static func write(toPath path: String, content: String) {
        let fileHandle = FileHandle(forWritingAtPath: path)
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(content.data(using: .utf8) ?? Data())
        fileHandle?.closeFile()
    }

    static func currentDate() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm:ss:SSS"
        return formater.string(from: Date())
    }

    public static func deleteHalfContent(path: String, maxSize: Int) -> String {
        
        do {
            let info = try FileManager.default.attributesOfItem(atPath: path)
            let fileSize = info[FileAttributeKey.size] as! UInt64

            if fileSize > maxSize * 1024 * 1024 {
                let fileName = (path as NSString).lastPathComponent
                let directory = (path as NSString).components(separatedBy: fileName).first
                let tempPath = createFile(directory: directory!, fileName: "temp_" + fileName)

                let tempFileInfo = try FileManager.default.attributesOfItem(atPath: tempPath)
                let tempFileSize = tempFileInfo[FileAttributeKey.size] as! UInt64
                if tempFileSize > maxSize * 1024 * 1024 / 2 {
                    /// 删除原本文件
                    try? FileManager.default.removeItem(atPath: path)
                    /// 然后重命名
                    try? FileManager.default.moveItem(atPath: tempPath, toPath: path)
                    return path
                } else {
                    return tempPath
                }
            }

        } catch {
            print("文件不存在")
        }

        return path
    }
}

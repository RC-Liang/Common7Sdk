//  contacts  -> Privacy - Contacts Usage Description
//
//  photo     -> Privacy - Photo Library Usage Description,
//               Privacy - Photo Library Additions Usage Description
//
//  camera    -> Privacy - Camera Usage Description
//
//  microphone     -> Privacy - Microphone Usage Description
//
//  location  -> Privacy - Location Always Usage Description,
//               Privacy - Location Always and When In Use Usage Description,
//               Privacy - Location When In Use Usage Description

import UIKit

//import Contacts
import Photos
//import CoreLocation
import Foundation

public enum PermissionType {
    case unknown    // 未知
    case contacts   // contacts
    case photo      // photo
    case camera     // camera
    case microphone // 麦克风
    case location   // location
}

public struct PermissionUtils {
    
    static public func permission(type: PermissionType, success: (() -> Void)? = nil) {
        
        switch type {
        case .contacts:
            contactPermission(success)
        case .photo:
            photoPermission(success)
        case .camera:
            cameraPermission(success)
        case .microphone:
            microphonePermission(success)
        case .location:
            locationPermission(success)
        default:
            break
        }
    }
    
    // MARK: contacts权限
    static fileprivate func contactPermission(_ success: (() -> Void)?) {

//        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
//
//        switch authStatus {
//
//        case .notDetermined:
//            CNContactStore().requestAccess(for: .contacts) { granted, error in
//
//                DispatchQueue.main.async {
//                    if !granted {
//                        self.configError(type: .contacts)
//                    }
//                    if granted {
//                        success()
//                    }
//                }
//            }
//
//        case .restricted, .denied:
//            self.configError(type: .contacts)
//        case .authorized:
//            success()
//        @unknown default:
//            break
//        }
    }

    // MARK: photo权限
    static func photoPermission(_ success: (() -> Void)? = nil) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .authorized {
            success?()
        } else if authStatus == .restricted || authStatus == .denied {
            configError(type: .photo)
        } else if #available(iOS 14, *), authStatus == .limited {
            success?()
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    
                    if status == .authorized {
                        success?()
                    } else if status == .restricted || status == .denied {
                        self.configError(type: .photo)
                    } else if #available(iOS 14, *), status == .limited {
                        success?()
                    }
                }
            }
        }
    }
    
    // MARK: camera权限
    static fileprivate func cameraPermission(_ success: (() -> Void)? = nil) {
        
        // 模拟器没有摄像头
        guard !(TARGET_OS_IPHONE == 1 && TARGET_IPHONE_SIMULATOR == 1)  else {
            alertSimulator()
            return
        }
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch authStatus {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        success?()
                    } else {
                        self.configError(type: .camera)
                    }
                }
            }
        case .restricted, .denied:
            configError(type: .camera)
        case .authorized:
            success?()
        @unknown default:
            break
        }
    }
    
    // MARK: 麦克风权限
    static fileprivate func microphonePermission(_ success: (() -> Void)? = nil) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
        
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        success?()
                    } else {
                        self.configError(type: .microphone)
                    }
                }
            }
            
        case .restricted, .denied:
            configError(type: .microphone)
        case .authorized:
            success?()
        @unknown default:
            break
        }
    }
    
    // MARK: location权限
    static fileprivate func locationPermission(_ success: (() -> Void)? = nil) {

//        let manager = CLLocationManager()

//        if #available(iOS 14.0, *) {
//            switch manager.authorizationStatus {
//
//            case .notDetermined:
//                manager.requestLocation()
//                // manager.requestAlwaysAuthorization()
//                // manager.requestWhenInUseAuthorization()
//
//            case .restricted, .denied:
//                self.configError(type: .location)
//            case .authorizedAlways, .authorizedWhenInUse:
//                success()
//            @unknown default:
//                break
//            }
//        } else {
//
//            let authStatus = CLLocationManager.authorizationStatus()
//
//            if authStatus == .notDetermined {
//                manager.requestLocation()
//            } else if authStatus == .restricted || authStatus == .denied {
//                self.configError(type: .location)
//            } else if authStatus == .authorizedAlways || authStatus == .authorizedWhenInUse {
//                success()
//            }
//
//        }

    }
    
    // MARK: 无权限 弹窗提示
    static fileprivate func configError(type: PermissionType, isChinese: Bool = true) {
        
        let name = config(type: type, isChinese: isChinese)
        
        // 无法访问\(name)权限
        var title = ""
        
        if isChinese {
            title = name == "未知权限" ? "未知权限" : "无法访问 \(name) 权限"
        } else {
            title = name == "unknown" ? "Unknown" : "Cannot access \(name) permissions"
        }
        
        // 可以到手机系统“设置-隐私-%@“中开启
        var message = ""
        if isChinese {
            message = name == "未知权限" ? "未知权限" : "可以到手机系统“设置-隐私-\(name.capitalized)“中开启"
        } else {
            message = name == "unknown" ? "Unknown" : "It can be turned on in the phone system “Settings-Privacy-\(name.capitalized)“"
        }
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: isChinese ? "取消" : "Cancel", style: .cancel, handler: nil)
        
        if name != "unknown" && name != "未知权限" {
            let open = UIAlertAction.init(title: isChinese ? "打开" : "Open", style: .default) { action in
                if let url: URL = URL.init(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url)  {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(open)
        }
        
        alertController.addAction(cancel)
        DispatchQueue.main.async {
            UIKitCommon.currentVC()?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: 获取提示权限的名字
    static fileprivate func config(type: PermissionType, isChinese: Bool) -> String {
        
        switch type {
        case .contacts:
            return isChinese ? "联系人" : "contacts"
        case .photo:
            return isChinese ? "相册" : "photo"
        case .camera:
            return isChinese ? "照相机" : "camera"
        case .microphone:
            return isChinese ? "麦克风" : "audio"
        case .location:
            return isChinese ? "位置" : "location"
        default:
            return isChinese ? "未知权限" : "unknown"
        }
    }
    
    // 模拟器没有相机权限
    static fileprivate func alertSimulator(_ isChinese: Bool = true) {
       
        let alertController = UIAlertController.init(title: "提示", message: "模拟器没有摄像头权限", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: isChinese ? "取消" : "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        DispatchQueue.main.async {
            UIKitCommon.rootViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
}

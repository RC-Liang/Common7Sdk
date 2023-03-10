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
    case unknown   // 未知
    // case contacts  // contacts
    case photo     // photo
    case camera    // camera
    case audio     // 麦克风
    // case location  // location
}

public struct PermissionTool {
    
    static public func permission(type: PermissionType, success: @escaping () -> ()) {
        
        switch type {
        case .unknown:
            break
//        case .contacts:
//            self.contactPermission(success)
        case .photo:
            self.photoPermission(success)
        case .camera:
            self.cameraPermission(success)
        case .audio:
            self.microphonePermission(success)
//        case .location:
//            self.locationPermission(success)
            
        }
    }
    
    // MARK: contacts权限
//    static fileprivate func contactPermission(_ success: @escaping () -> ()) {
//
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
//    }

    // MARK: photo权限
    static func photoPermission(_ success: @escaping () -> ()) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .authorized {
            success()
        } else if authStatus == .restricted || authStatus == .denied {
            self.configError(type: .photo)
        } else if #available(iOS 14, *), authStatus == .limited {
            success()
        } else if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    
                    if status == .authorized {
                        success()
                    } else if status == .restricted || status == .denied {
                        self.configError(type: .photo)
                    } else if #available(iOS 14, *), status == .limited {
                        success()
                    }
                }
            }
        }
    }
    
    // MARK: camera权限
    static fileprivate func cameraPermission(_ success: @escaping () -> ()) {
        
        // 模拟器没有摄像头
        guard !(TARGET_OS_IPHONE == 1 && TARGET_IPHONE_SIMULATOR == 1)  else {
            self.configError(type: .unknown)
            return
        }
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch authStatus {
        
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        success()
                    } else {
                        self.configError(type: .camera)
                    }
                }
            }
        case .restricted, .denied:
            self.configError(type: .camera)
        case .authorized:
            success()
        @unknown default:
            break
        }
    }
    
    // MARK: 麦克风权限
    static fileprivate func microphonePermission(_ success: @escaping () -> ()) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
        
        case .notDetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        success()
                    } else {
                        self.configError(type: .audio)
                    }
                }
            }
            
        case .restricted, .denied:
            self.configError(type: .audio)
        case .authorized:
            success()
        @unknown default:
            break
        }
    }
    
    // MARK: location权限
//    static fileprivate func locationPermission(_ success: @escaping () -> ()) {
//
//        let manager = CLLocationManager()
//
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
//
//    }
    
    // MARK: 无权限 弹窗提示
    static fileprivate func configError(type: PermissionType) {
        
        let name = self.config(type: type)
        // 无法访问\(name)权限
        let title = name == "unknown" ? "Unknown" : "Cannot access \(name) permissions"
        // 可以到手机系统“设置-隐私-%@“中开启
        let message = name == "unknown" ? "Unknown" : "It can be turned on in the phone system “Settings-Privacy-\(name.capitalized)“"
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        if name != "unknown" {
            let open = UIAlertAction.init(title: "Open", style: .default) { action in
                
                // UIApplicationOpenSettingsURLString
                guard let url: URL = URL.init(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            alertController.addAction(open)
        }
        
        alertController.addAction(cancel)
    
        UIKitCommon.rootViewController()?.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: 获取提示权限的名字
    static fileprivate func config(type: PermissionType) -> String {
        
        switch type {
        
        case .unknown:
            return "unknown"
            // case .contacts:
            // return "contacts"
        case .photo:
            return "photo"
        case .camera:
            return "camera"
        case .audio:
            return "audio"
            // case .location:
            // return "location"
        }
    }
}

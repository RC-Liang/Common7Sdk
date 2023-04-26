import UIKit
import AudioToolbox

public enum RingType {
    case all     // 声音+震动
    case voice   // 声音
    case vibrate // 震动
}

public struct CommonUtils {

    /// 震动反馈
    public static func impactFeedback() {
        let feed = UIImpactFeedbackGenerator(style: .medium)
        feed.prepare()
        feed.impactOccurred()
    }
    
    /// 震动或者响铃
    public static func ringing(_ type: RingType? = nil) {
        
        switch type {
            
        case .all:
            AudioServicesPlaySystemSound(1012)
        case .voice:
            var sound: SystemSoundID = 0
            let path = String(format: "/System/Library/Audio/UISounds/%@.%@", "sms-received1","caf")
            AudioServicesCreateSystemSoundID(NSURL(fileURLWithPath: path), &sound)
            AudioServicesPlaySystemSound(sound)
        case .vibrate:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        case .none:
            break
        }
    }
}

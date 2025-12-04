import Flutter
import UIKit

public class SystemShortcutsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "system_shortcuts", binaryMessenger: registrar.messenger())
        let instance = SystemShortcutsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "home":
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            result(true)
        case "back":
            UIApplication.shared.keyWindow?.rootViewController?.navigationController?.popViewController(animated: true)
            result(true)
        case "vol":
            let vol = AVAudioSession.sharedInstance().outputVolume
            result(vol)
        case "setVol":
            let arguments = call.arguments as! [String : Any];
            let volBefore = _arguments["value"] as? Float
            MPVolumeView.setVolume(volBefore ?? 0.5)
            let volAfter = AVAudioSession.sharedInstance().outputVolume
            result(volAfter)
        case "volUp":
            let volBefore = AVAudioSession.sharedInstance().outputVolume
            MPVolumeView.setVolume(volBefore + 0.1)
            let volAfter = AVAudioSession.sharedInstance().outputVolume
            result(volAfter)
        case "volDown":
            let volBefore = AVAudioSession.sharedInstance().outputVolume
            MPVolumeView.setVolume(volBefore - 0.1)
            let volAfter = AVAudioSession.sharedInstance().outputVolume
            result(volAfter)
        case "orientLandscapeLeft":
            let val = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(val, forKey: "orientation")
            result(nil)
        case "orientLandscapeRight":
            let val = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(val, forKey: "orientation")
            result(nil)
        case "orientLandscape":
            let val = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(val, forKey: "orientation")
            result(nil)
            break;
        case "orientPortrait":
            let val = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(val, forKey: "orientation")
            result(nil)
            break;
        case "orientPortraitUpsideDown":
            let val = UIInterfaceOrientation.portraitUpsideDown.rawValue
            UIDevice.current.setValue(val, forKey: "orientation")
            result(nil)
        case "wifi":
            // It's not possible to Change Wifi Global Setting on iOS
            result(nil)
        case "checkWifi":
            result(nil)
        case "bluetooth":
            result(nil)
        case "checkBluetooth":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

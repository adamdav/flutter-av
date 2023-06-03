import Flutter
import UIKit

public class AvPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "av", binaryMessenger: registrar.messenger())
    let instance = AvPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "prepareToRecordMpeg4Aac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareMpeg4Aac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, bitRate: arguments["bitRate"] ?? 256000)
        error == nil ? result(urlString) : result(error)
        // result(AvPluginAudioRecorder.prepareMpeg4Aac())
      case "prepareToRecordAlac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareAlac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2)
        error == nil ? result(urlString) : result(error)
        // result(AvPluginAudioRecorder.prepareAlac())
      case "startRecording":
        result(AvPluginAudioRecorder.start())
        // result(audioRecorder?.record())
      case "stopRecording":
        result(AvPluginAudioRecorder.stop())
        // audioRecorder?.stop()
        // result(nil)

    // case "getPlatformVersion":
    //   result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}


// public class AvPlugin: NSObject, FlutterPlugin {
//   public static func register(with registrar: FlutterPluginRegistrar) {
//     let channel = FlutterMethodChannel(name: "av", binaryMessenger: registrar.messenger)
//     let instance = AvPlugin()
//     registrar.addMethodCallDelegate(instance, channel: channel)
//   }

//   private var audioRecorder: AVAudioRecorder?

//   public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//     switch call.method {
//       case "prepareToRecordMpeg4Aac":
//         let arguments = call.arguments as! [String: Any]
//         let settings = [
//           AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//           AVSampleRateKey: arguments["sampleRate"] ?? 44100,
//           AVNumberOfChannelsKey: arguments["numberOfChannels"] ?? 2,
//           AVEncoderBitRateKey: arguments["bitRate"] ?? 256000,
//           AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//         ]
//         let directory = NSTemporaryDirectory()
//         let filename = UUID().uuidString + ".m4a"
//         let urlString: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
//         print(urlString);
//         audioRecorder = try? AVAudioRecorder(url: URL(string: urlString!)!, settings: settings)
//         result(audioRecorder!.prepareToRecord() ? urlString : nil)
//       case "prepareToRecordAlac":
//         // do {
//         //   let session = AVAudioSession.sharedInstance()
//         //   try session.setCategory(.record);
//         //   try session.setActive(true)
//         // } catch {
//         //   result(FlutterError(code: "prepareToRecordAlac", message: "Failed to set category .record on shared audio session instance", details: "\(error)"))
//         // }
//         let arguments = call.arguments as! [String: Any]
//         let settings = [
//           AVFormatIDKey: Int(kAudioFormatAppleLossless),
//           AVSampleRateKey: arguments["sampleRate"] ?? 44100,
//           AVNumberOfChannelsKey: arguments["numberOfChannels"] ?? 2,
//         ]
//         // let url = URL(string: arguments["filename"] as! String);
//         // print(url);
//         let directory = NSTemporaryDirectory()
//         let filename = UUID().uuidString + ".m4a"
//         let urlString: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
//         audioRecorder = try? AVAudioRecorder(url: URL(string: urlString!)!, settings: settings)
//         result(audioRecorder!.prepareToRecord() ? urlString : nil)
//       case "startRecording":
//         result(audioRecorder?.record())
//       case "stopRecording":
//         result(audioRecorder?.stop())

//     // case "getPlatformVersion":
//     //   result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
//     default:
//       result(FlutterMethodNotImplemented)
//     }
//   }
// }

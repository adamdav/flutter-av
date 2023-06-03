import Flutter
import UIKit

public class AvPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "av", binaryMessenger: registrar.messenger())
    let instance = AvPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private var recordingDestinationUrlString: String?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "prepareToRecordMpeg4Aac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareToRecordMpeg4Aac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, bitRate: arguments["bitRate"] ?? 256000)
        recordingDestinationUrlString = urlString
        error == nil ? result(urlString) : result(error)
      case "prepareToRecordAlac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareToRecordAlac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2)
        recordingDestinationUrlString = urlString
        error == nil ? result(urlString) : result(error)
      case "startRecording":
        result(AvPluginAudioRecorder.startRecording())
      case "stopRecording":
        AvPluginAudioRecorder.stopRecording()
        result(recordingDestinationUrlString)
      case "deleteRecording":
        result(AvPluginAudioRecorder.deleteRecording())
      case "prepareToPlay":
        let arguments = call.arguments as! [String: String]
        let (didPrepareToPlay, error) = AvPluginAudioPlayer.prepareToPlay(url: arguments["url"]!)
        error == nil ? result(didPrepareToPlay) : result(error)
      case "startPlaying":
        result(AvPluginAudioPlayer.startPlaying())
      case "stopPlaying":
        AvPluginAudioPlayer.stopPlaying()

    // case "getPlatformVersion":
    //   result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
      default:
        result(FlutterMethodNotImplemented)
    }
  }
}

import Flutter
import UIKit
import AVFAudio

public class AvPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, AVAudioPlayerDelegate {
  // private static var audioPlayerEventStreamHandler = AudioPlayerEventStreamHandler()
  // private static var audioRecorderEventStreamHandler = AudioRecorderEventStreamHandler()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(name: "av/methods", binaryMessenger: registrar.messenger())
    let instance: AvPlugin = AvPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    let eventChannel = FlutterEventChannel(name: "av/events", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
    // let audioPlayerEventChannel = FlutterEventChannel(name: "av/events/audio_player", binaryMessenger: registrar.messenger())
    // let audioRecorderEventChannel = FlutterEventChannel(name: "av/events/audio_recorder", binaryMessenger: registrar.messenger())
    // audioPlayerEventChannel.setStreamHandler(audioPlayerEventStreamHandler)
    // audioRecorderEventChannel.setStreamHandler(audioRecorderEventStreamHandler)
    // registrar.addApplicationDelegate(instance)
  }

  private var recordingDestinationUrlString: String?
  private var audioPlayer: AVAudioPlayer?
  private var eventSink: FlutterEventSink?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "prepareToRecordMpeg4Aac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareToRecordMpeg4Aac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, bitRate: arguments["bitRate"] ?? 256000, onEvent: {
          (event: Any) -> () in
          // audioRecorderEventStreamHandler?.eventSink()
        })
        recordingDestinationUrlString = urlString
        error == nil ? result(urlString) : result(error)
      case "prepareToRecordAlac":
        let arguments = call.arguments as! [String: Int]
        let (urlString, error) = AvPluginAudioRecorder.prepareToRecordAlac(sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, onEvent: {
          (event: Any) -> () in
          // audioRecorderEventStreamHandler?.eventSink()
        })
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
        let (audioPlayer, error) = AvPluginAudioPlayer.prepareToPlay(url: arguments["url"]!)
        if audioPlayer != nil {
          // audioPlayer.delegate = AudioPlayerDelegate(onDidFinishPlaying: onDidFinishPlaying)
          self.audioPlayer = audioPlayer
          self.audioPlayer!.delegate = self
        }
        error == nil ? result(true) : result(error)
      case "startPlaying":
        result(AvPluginAudioPlayer.startPlaying(audioPlayer))
      case "pausePlaying":
        result(AvPluginAudioPlayer.pausePlaying(audioPlayer))

    // case "getPlatformVersion":
    //   result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
      default:
        result(FlutterMethodNotImplemented)
    }
  }

  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print("didFinishPlaying")
    eventSink?([
      "type": "audioPlayer/didFinishPlaying",
      "payload": [
        "success": flag,
      ],
    ])
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  

  // public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
  //   eventSink = events
  //   return nil
  // }

  // public func onCancel(withArguments arguments: Any?) -> FlutterError? {
  //   eventSink = nil
  //   return nil
  // }
}

// private class AudioPlayerEventStreamHandler: NSObject, FlutterStreamHandler {
//   public var eventSink: FlutterEventSink?

//   public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//     eventSink = events
//     return nil
//   }

//   public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//     eventSink = nil
//     return nil
//   }
// }

// private class AudioRecorderEventStreamHandler: NSObject, FlutterStreamHandler {
//   public var eventSink: FlutterEventSink?

//   public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//     eventSink = events
//     return nil
//   }

//   public func onCancel(withArguments arguments: Any?) -> FlutterError? {
//     eventSink = nil
//     return nil
//   }
// }


// public class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
//   private var onDidFinishPlaying: (Bool) -> Void
//   init(onDidFinishPlaying: @escaping (Bool) -> Void) {
//     self.onDidFinishPlaying = onDidFinishPlaying
//   }
  // public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
  //   print("didFinishPlaying")
  //   onDidFinishPlaying(flag)
  // }
// }

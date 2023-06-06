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

  private var recordingDestinationUrl: String?
  private var audioPlayer: AVAudioPlayer?
  private var audioRecorder: AVAudioRecorder?
  private var eventSink: FlutterEventSink?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "prepareToRecordMpeg4Aac":
        let arguments = call.arguments as! [String: Int]
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString + ".m4a"
        let url: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
        let (audioRecorder, error) = AvPluginAudioRecorder.prepareToRecordMpeg4Aac(url: url!, sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, bitRate: arguments["bitRate"] ?? 256000)
        if audioRecorder != nil {
          self.audioRecorder = audioRecorder
        }
        recordingDestinationUrl = url
        error == nil ? result(recordingDestinationUrl) : result(error)
      case "prepareToRecordAlac":
        let arguments = call.arguments as! [String: Int]
        let directory = NSTemporaryDirectory()
        let filename = UUID().uuidString + ".alac"
        let url: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
        let (audioRecorder, error) = AvPluginAudioRecorder.prepareToRecordAlac(url: url!, sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2)
        if audioRecorder != nil {
          // audioRecorder.delegate = AudioRecorderDelegate(onDidFinishRecording: onDidFinishRecording)
          self.audioRecorder = audioRecorder
          // self.audioRecorder!.delegate = self
        }
        recordingDestinationUrl = url
        error == nil ? result(recordingDestinationUrl) : result(error)
      case "startRecording":
        if (audioRecorder == nil) {
          result(FlutterError(code: "startRecording", message: "prepareToRecord has not been called", details: nil))
          return
        }
        result(AvPluginAudioRecorder.startRecording(audioRecorder!))
      case "stopRecording":
        if (audioRecorder == nil) {
          result(FlutterError(code: "stopRecording", message: "prepareToRecord has not been called", details: nil))
          return
        }
        AvPluginAudioRecorder.stopRecording(audioRecorder!)
        result(recordingDestinationUrl)
      case "deleteRecording":
        if (audioRecorder == nil) {
          result(FlutterError(code: "deleteRecording", message: "prepareToRecord has not been called", details: nil))
          return
        }
        result(AvPluginAudioRecorder.deleteRecording(audioRecorder!))
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
        if (audioPlayer == nil) {
          result(FlutterError(code: "startPlaying", message: "prepareToPlay has not been called", details: nil))
          return
        }
        result(AvPluginAudioPlayer.startPlaying(audioPlayer!))
      case "pausePlaying":
        if (audioPlayer == nil) {
          result(FlutterError(code: "pausePlaying", message: "prepareToPlay has not been called", details: nil))
          return
        }
        result(AvPluginAudioPlayer.pausePlaying(audioPlayer!))
      case "skip":
        if (audioPlayer == nil) {
          result(FlutterError(code: "skip", message: "prepareToPlay has not been called", details: nil))
          return
        }
        let arguments = call.arguments as! [String: Double]
        result(AvPluginAudioPlayer.skip(audioPlayer!, interval: arguments["interval"]!))

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

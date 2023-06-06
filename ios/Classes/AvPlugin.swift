import Flutter
import UIKit
import AVFAudio
import Accelerate

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

  private var audioRecordingFile: AVAudioFile?
  private var audioPlayer: AVAudioPlayer?
  private var audioRecorder: AVAudioRecorder?
  private var audioEngine: AVAudioEngine?
  private var audioMixerNode: AVAudioMixerNode?
  private var eventSink: FlutterEventSink?

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "prepareToRecordMpeg4Aac":
        do {
          let session: AVAudioSession = AVAudioSession.sharedInstance()
          try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
          try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
          result(FlutterError(code: "prepareToRecordMpeg4Aac", message: "Failed to set category .record on shared audio session instance", details: "\(error)"))
          return
        }

        audioEngine = AVAudioEngine()
        audioMixerNode = AVAudioMixerNode()

        // Set volume to 0 to avoid audio feedback while recording.
        audioMixerNode!.volume = 0

        audioEngine!.attach(audioMixerNode!)

        let audioEngineInputNodeOutputFormat = audioEngine!.inputNode.outputFormat(forBus: 0)
        audioEngine!.connect(audioEngine!.inputNode, to: audioMixerNode!, format: audioEngineInputNodeOutputFormat)

        let audioMixerNodeOutputFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: audioEngineInputNodeOutputFormat.sampleRate, channels: 1, interleaved: false)
        
        // let audioMixerNodeOutputFormat: AVAudioFormat = audioMixerNode!.outputFormat(forBus: 0)
        audioEngine!.connect(audioMixerNode!, to: audioEngine!.mainMixerNode, format: audioMixerNodeOutputFormat)

        print("audioEngineInputNodeOutputFormat: \(audioEngineInputNodeOutputFormat)")
        print("audioMixerNodeInputFormat: \(audioMixerNode!.inputFormat(forBus: 0))")
        print("audioMixerNodeOutputFormat: \(audioMixerNode!.outputFormat(forBus: 0))")
        print("audioEngineMainMixerNodeInputFormat: \(audioEngine!.mainMixerNode.inputFormat(forBus: 0))")
        print("audioEngineMainMixerNodeOutputFormat: \(audioEngine!.mainMixerNode.outputFormat(forBus: 0))")
        
        // Prepare the engine in advance, in order for the system to allocate the necessary resources.
        audioEngine!.prepare()

        result(true)

        // result("")
        // audioRecordingFile = try AVAudioFile(forWriting: audioRecordingUrl, settings: audioMixerNodeOutputFormat.settings)

        // audioRecordingFile != nil ? result(audioRecordingFile!.url.absoluteString) : result(FlutterError(code: "prepareToRecord", message: "Failed to create audio recording file", details: nil))

        // let arguments = call.arguments as! [String: Int]
        // let directory = NSTemporaryDirectory()
        // let filename = UUID().uuidString + ".m4a"
        // let url: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
        // let (audioRecorder, error) = AvPluginAudioRecorder.prepareToRecordMpeg4Aac(url: url!, sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2, bitRate: arguments["bitRate"] ?? 256000)
        // if audioRecorder != nil {
        //   self.audioRecorder = audioRecorder
        // }
        // audioRecordingUrl = url
        // error == nil ? result(audioRecordingUrl) : result(error)
      // case "prepareToRecordAlac":
      //   let arguments = call.arguments as! [String: Int]
      //   // let directory = NSTemporaryDirectory()
      //   // let filename = UUID().uuidString + ".alac"
      //   // let url: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
      //   let (audioRecorder, error) = AvPluginAudioRecorder.prepareToRecordAlac(url: url!, sampleRate: arguments["sampleRate"] ?? 44100, numberOfChannels: arguments["numberOfChannels"] ?? 2)
      //   if audioRecorder != nil {
      //     // audioRecorder.delegate = AudioRecorderDelegate(onDidFinishRecording: onDidFinishRecording)
      //     self.audioRecorder = audioRecorder
      //     // self.audioRecorder!.delegate = self
      //   }
      //   audioRecordingUrl = url
      //   error == nil ? result(audioRecordingUrl) : result(error)
      case "startRecording":
        do {
          let audioRecordingUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(UUID().uuidString + ".caf")

          // AVAudioFile uses the Core Audio Format (CAF) to write to disk.
          // So we're using the caf file extension.
          do {
            audioRecordingFile = try AVAudioFile(forWriting: audioRecordingUrl, settings: audioMixerNode!.outputFormat(forBus: 0).settings)
            // result(audioRecordingFile!.url.absoluteString)
          } catch {
            result(FlutterError(code: "startRecording", message: "Failed to create audio recording file", details: "\(error)"))
            return
          }

          // let audioFile: AVAudioFile = try AVAudioFile(forWriting: audioRecordingUrl!, settings: audioMixerNodeOutputFormat.settings)
          let audioMixerNodeOutputFormat = audioMixerNode!.outputFormat(forBus: 0)

          let levelLowpassTrig: Float = 0.3
          var averagePower: Float = 0
          // var averagePowerForChannel1: Float = 0

          audioMixerNode!.installTap(onBus: 0, bufferSize: 1024, format: audioMixerNodeOutputFormat, block: {
            (buffer: AVAudioPCMBuffer, time: AVAudioTime) in
            let inNumberFrames:UInt = UInt(buffer.frameLength)
            // if buffer.format.channelCount > 0 {
            let samples = (buffer.floatChannelData![0])
            var maxAmp:Float32 = 0
            var avgAmp:Float32 = 0
            vDSP_meamgv(samples,1 , &avgAmp, inNumberFrames)
            vDSP_maxmgv(samples, 1, &maxAmp, inNumberFrames)
            // var v:Float = -100
            // if avgValue != 0 {
            //     v = 20.0 * log10f(avgValue)
            // }
            // averagePower = (levelLowpassTrig * v) + ((1 - levelLowpassTrig) * averagePower)
            // averagePowerForChannel1 = averagePower
            // print("averagePower: \(averagePower)")

            self.eventSink?([
              "type": "audioRecorder/metered",
              "payload": [
                "avgAmplitude": avgAmp,
                "maxAmplitude": maxAmp,
                // "sample": buffer.floatChannelData![0][0],
                // "sampleTime": time.sampleTime,
                // "sampleRate": time.sampleRate,
              ],
            ])
            try? self.audioRecordingFile!.write(from: buffer)
          })

          try audioEngine!.start()
          result(true)
        } catch {
          result(FlutterError(code: "startRecording", message: "Failed to start audio engine", details: "\(error)"))
          return
        }
        // if (audioRecorder == nil) {
        //   result(FlutterError(code: "startRecording", message: "prepareToRecord has not been called", details: nil))
        //   return
        // }
        // result(AvPluginAudioRecorder.startRecording(audioRecorder!))
      case "stopRecording":
        audioMixerNode?.removeTap(onBus: 0)
        audioEngine?.stop()
        // if (audioRecorder == nil) {
        //   result(FlutterError(code: "stopRecording", message: "prepareToRecord has not been called", details: nil))
        //   return
        // }
        // AvPluginAudioRecorder.stopRecording(audioRecorder!)
        result(audioRecordingFile?.url.absoluteString)
      case "deleteRecording":
        do {
          try FileManager.default.removeItem(at: audioRecordingFile!.url)
          result(true)
        } catch {
          result(FlutterError(code: "deleteRecording", message: "Failed to delete audio recording file", details: "\(error)"))
          return
        }
        // result(FileManager.default.removeItem(at: audioRecordingFile!.url))
        // if (audioRecorder == nil) {
        //   result(FlutterError(code: "deleteRecording", message: "prepareToRecord has not been called", details: nil))
        //   return
        // }
        // result(AvPluginAudioRecorder.deleteRecording(audioRecorder!))
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
    eventSink?([
      "type": "audioPlayer/finishedPlaying",
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
}

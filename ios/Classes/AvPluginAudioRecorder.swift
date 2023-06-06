import Flutter
import AVFoundation

public class AvPluginAudioRecorder: NSObject {
  // private static var audioRecorder: AVAudioRecorder?

  public static func prepareToRecordMpeg4Aac(url: String, sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (AVAudioRecorder?, FlutterError?) {
    return prepareToRecordLossy(url: url, errorCode: "prepareToRecordMpeg4Aac", formatIdKey: Int(kAudioFormatMPEG4AAC), sampleRate: sampleRate, numberOfChannels: numberOfChannels, bitRate: bitRate)
  }

  public static func prepareToRecordAlac(url: String, sampleRate: Int, numberOfChannels: Int) -> (AVAudioRecorder?, FlutterError?) {
    return prepareToRecordLossless(url: url, errorCode: "prepareToRecordAlac", formatIdKey: Int(kAudioFormatAppleLossless), sampleRate: sampleRate, numberOfChannels: numberOfChannels)
  }

  public static func startRecording(_ audioRecorder: AVAudioRecorder) -> Bool {
    return audioRecorder.record()
  }
  
  public static func stopRecording(_ audioRecorder: AVAudioRecorder) {
    audioRecorder.stop()
  }

  public static func deleteRecording(_ audioRecorder: AVAudioRecorder) -> Bool {
    return audioRecorder.deleteRecording()
  }

  private static func prepareToRecordLossy(url: String, errorCode: String, formatIdKey: Int, sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (AVAudioRecorder?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate,
      AVNumberOfChannelsKey: numberOfChannels,
      AVEncoderBitRateKey: bitRate,
    ]

    return prepareToRecord(url: url, errorCode: errorCode, formatIdKey: formatIdKey, settings: settings)
  }

  private static func prepareToRecordLossless(url: String, errorCode: String, formatIdKey: Int, sampleRate: Int, numberOfChannels: Int) -> (AVAudioRecorder?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate,
      AVNumberOfChannelsKey: numberOfChannels,
    ]

    return prepareToRecord(url: url, errorCode: errorCode, formatIdKey: formatIdKey, settings: settings)
  }


  private static func prepareToRecord(url: String, errorCode: String, formatIdKey: Int, settings: [String : Int]) -> (AVAudioRecorder?, FlutterError?) {
    let session = AVAudioSession.sharedInstance()

    do {
      try session.setCategory(.record)
    } catch {
      return (nil, FlutterError(code: errorCode, message: "Failed to set category .record on shared audio session instance", details: "\(error)"))
    }

    do {
      try session.setActive(true)
    } catch {
      return (nil, FlutterError(code: errorCode, message: "Failed to activate audio session instance", details: "\(error)"))
    }

    // let directory = NSTemporaryDirectory()
    // let filename = UUID().uuidString + fileExtension
    // let urlString: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
    let audioRecorder = try? AVAudioRecorder(url: URL(string: url)!, settings: settings)
    let didPrepareToRecord = audioRecorder?.prepareToRecord() ?? false
    return didPrepareToRecord ? (audioRecorder, nil) : (nil, FlutterError(code: errorCode, message: "Failed to prepare to record", details: nil))
  }
}

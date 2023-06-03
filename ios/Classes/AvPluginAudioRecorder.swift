import Flutter
import AVFoundation

public class AvPluginAudioRecorder: NSObject {
  private static var audioRecorder: AVAudioRecorder?

  public static func prepareToRecordMpeg4Aac(sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (String?, FlutterError?) {
    return prepareToRecordLossy(errorCode: "prepareToRecordMpeg4Aac", formatIdKey: Int(kAudioFormatMPEG4AAC), fileExtension: ".m4a", sampleRate: sampleRate, numberOfChannels: numberOfChannels, bitRate: bitRate)
  }

  public static func prepareToRecordAlac(sampleRate: Int, numberOfChannels: Int) -> (String?, FlutterError?) {
    return prepareToRecordLossless(errorCode: "prepareToRecordAlac", formatIdKey: Int(kAudioFormatAppleLossless), fileExtension: ".alac", sampleRate: sampleRate, numberOfChannels: numberOfChannels)
  }

  public static func startRecording() -> Bool {
    return audioRecorder?.record() != nil
  }
  
  public static func stopRecording() {
    audioRecorder?.stop()
  }

  public static func deleteRecording() -> Bool {
    return audioRecorder?.deleteRecording() != nil
  }

  private static func prepareToRecordLossy(errorCode: String, formatIdKey: Int, fileExtension: String, sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (String?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate,
      AVNumberOfChannelsKey: numberOfChannels,
      AVEncoderBitRateKey: bitRate,
    ]

    return prepareToRecord(errorCode: errorCode, formatIdKey: formatIdKey, fileExtension: fileExtension, settings: settings)
  }

  private static func prepareToRecordLossless(errorCode: String, formatIdKey: Int, fileExtension: String, sampleRate: Int, numberOfChannels: Int) -> (String?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate ?? 44100,
      AVNumberOfChannelsKey: numberOfChannels ?? 2,
    ]

    return prepareToRecord(errorCode: errorCode, formatIdKey: formatIdKey, fileExtension: fileExtension, settings: settings)
  }


  private static func prepareToRecord(errorCode: String, formatIdKey: Int, fileExtension: String, settings: [String : Int]) -> (String?, FlutterError?) {
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

    let directory = NSTemporaryDirectory()
    let filename = UUID().uuidString + fileExtension
    let urlString: String? = NSURL.fileURL(withPathComponents: [directory, filename])?.absoluteString
    audioRecorder = try? AVAudioRecorder(url: URL(string: urlString!)!, settings: settings)
    return (audioRecorder!.prepareToRecord() ? urlString : nil, nil)
  }
}

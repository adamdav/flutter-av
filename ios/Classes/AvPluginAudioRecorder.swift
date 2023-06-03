import Flutter
import AVFoundation

public class AvPluginAudioRecorder: NSObject {
  private static var audioRecorder: AVAudioRecorder?

  public static func prepareMpeg4Aac(sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (String?, FlutterError?) {
    return prepareLossy(errorCode: "prepareMpeg4Aac", formatIdKey: Int(kAudioFormatMPEG4AAC), fileExtension: ".m4a", sampleRate: sampleRate, numberOfChannels: numberOfChannels, bitRate: bitRate)
  }

  public static func prepareAlac(sampleRate: Int, numberOfChannels: Int) -> (String?, FlutterError?) {
    return prepareLossless(errorCode: "prepareAlac", formatIdKey: Int(kAudioFormatAppleLossless), fileExtension: ".alac", sampleRate: sampleRate, numberOfChannels: numberOfChannels)
  }

  public static func start() -> Bool {
    return audioRecorder?.record() != nil
  }
  
  public static func stop() -> Bool {
    audioRecorder?.stop()
    return true
  }

  private static func prepareLossy(errorCode: String, formatIdKey: Int, fileExtension: String, sampleRate: Int, numberOfChannels: Int, bitRate: Int) -> (String?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate,
      AVNumberOfChannelsKey: numberOfChannels,
      AVEncoderBitRateKey: bitRate,
    ]

    return prepare(errorCode: errorCode, formatIdKey: formatIdKey, fileExtension: fileExtension, settings: settings)
  }

  private static func prepareLossless(errorCode: String, formatIdKey: Int, fileExtension: String, sampleRate: Int, numberOfChannels: Int) -> (String?, FlutterError?) {
    let settings = [
      AVFormatIDKey: formatIdKey,
      AVSampleRateKey: sampleRate ?? 44100,
      AVNumberOfChannelsKey: numberOfChannels ?? 2,
    ]

    return prepare(errorCode: errorCode, formatIdKey: formatIdKey, fileExtension: fileExtension, settings: settings)
  }


  private static func prepare(errorCode: String, formatIdKey: Int, fileExtension: String, settings: [String : Int]) -> (String?, FlutterError?) {
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

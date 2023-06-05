import Flutter
import AVFoundation


public class AvPluginAudioPlayer: NSObject {
  // private static var audioPlayer: AVAudioPlayer?

  public static func prepareToPlay(url: String) -> (AVAudioPlayer?, FlutterError?) {
    let session = AVAudioSession.sharedInstance()

    do {
      try session.setCategory(.playback)
    } catch {
      return (nil, FlutterError(code: "prepareToPlay", message: "Failed to set category .playback on shared audio session instance", details: "\(error)"))
    }

    do {
      try session.setActive(true)
    } catch {
      return (nil, FlutterError(code: "prepareToPlay", message: "Failed to activate audio session instance", details: "\(error)"))
    }

    let audioPlayer = try? AVAudioPlayer(contentsOf: URL(string: url)!)
    let didPrepare = audioPlayer?.prepareToPlay() != nil
    return (didPrepare ? audioPlayer : nil, nil)
  }

  public static func startPlaying(_ audioPlayer: AVAudioPlayer?) -> Bool {
    return audioPlayer?.play() != nil
  }

  public static func pausePlaying(_ audioPlayer: AVAudioPlayer?) -> Bool {
    return audioPlayer?.pause() != nil
  }
}

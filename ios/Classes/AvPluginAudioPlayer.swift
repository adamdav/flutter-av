import Flutter
import AVFoundation


public class AvPluginAudioPlayer: NSObject {
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

    let audioPlayer: AVAudioPlayer? = try? AVAudioPlayer(contentsOf: URL(string: url)!)
    let didPrepare: Bool = audioPlayer?.prepareToPlay() != nil
    return (didPrepare ? audioPlayer : nil, nil)
  }

  public static func startPlaying(_ audioPlayer: AVAudioPlayer) -> Bool {
    return audioPlayer.play()
  }

  public static func pausePlaying(_ audioPlayer: AVAudioPlayer) -> Bool {
    audioPlayer.pause()
    return true
  }

  public static func skip(_ audioPlayer: AVAudioPlayer, interval: Double) -> Bool {
    audioPlayer.currentTime += interval
    return true
  }
}

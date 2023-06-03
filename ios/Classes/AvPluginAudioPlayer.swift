import Flutter
import AVFoundation

public class AvPluginAudioPlayer: NSObject {
  private static var audioPlayer: AVAudioPlayer?

  public static func prepareToPlay(url: String) -> (Bool, FlutterError?) {
    let session = AVAudioSession.sharedInstance()

    do {
      try session.setCategory(.playback)
    } catch {
      return (false, FlutterError(code: "prepareToPlay", message: "Failed to set category .playback on shared audio session instance", details: "\(error)"))
    }

    do {
      try session.setActive(true)
    } catch {
      return (false, FlutterError(code: "prepareToPlay", message: "Failed to activate audio session instance", details: "\(error)"))
    }

    audioPlayer = try? AVAudioPlayer(contentsOf: URL(string: url)!)
    return (audioPlayer!.prepareToPlay(), nil)
  }

  public static func startPlaying() -> Bool {
    return audioPlayer?.play() != nil
  }

  public static func stopPlaying() {
    audioPlayer?.stop()
  }
}

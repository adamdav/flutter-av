import 'package:av/av_platform_interface.dart';

class AudioPlayerUtils {
  static Future<bool?> prepareToPlay(String url) async {
    return await AvPlatformInterface.instance.prepareToPlay(url);
  }

  static Future<bool?> startPlaying() async {
    return await AvPlatformInterface.instance.startPlaying();
  }

  static Future<void> stopPlaying() async {
    return await AvPlatformInterface.instance.stopPlaying();
  }
}
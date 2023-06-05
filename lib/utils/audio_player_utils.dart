import 'package:av/av_platform_interface.dart';

class AudioPlayerUtils {
  static Future<bool?> prepareToPlay(String url) async {
    return await AvPlatformInterface.instance.prepareToPlay(url);
  }

  static Future<bool?> startPlaying() async {
    return await AvPlatformInterface.instance.startPlaying();
  }

  static Future<void> pausePlaying() async {
    return await AvPlatformInterface.instance.pausePlaying();
  }

  static Future<bool?> skip(num interval) async {
    return await AvPlatformInterface.instance.skip(interval);
  }

  static Stream<dynamic> getEventStream() {
    return AvPlatformInterface.instance.getEventStream();
  }
}

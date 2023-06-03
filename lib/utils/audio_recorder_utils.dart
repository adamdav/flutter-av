import 'package:av/av_platform_interface.dart';

class AudioRecorderUtils {
  static Future<String?> prepareToRecordMpeg4Aac() async {
    return await AvPlatformInterface.instance.prepareToRecordMpeg4Aac();
  }

  static Future<String?> prepareToRecordAlac() async {
    return await AvPlatformInterface.instance.prepareToRecordMpeg4Aac();
  }

  static Future<bool?> startRecording() async {
    return await AvPlatformInterface.instance.startRecording();
  }

  static Future<String?> stopRecording() async {
    return await AvPlatformInterface.instance.stopRecording();
  }

  static Future<bool?> deleteRecording() async {
    return await AvPlatformInterface.instance.deleteRecording();
  }
}

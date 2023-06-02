import 'package:av/av_platform_interface.dart';

class AudioRecorder {
  static Future<void> prepareMpeg4Aac() async {
    await AvPlatformInterface.instance.prepareToRecordMpeg4Aac();
    // await AvPlatformInterface.instance.startRecording();
  }

  static Future<void> prepareAlac() async {
    await AvPlatformInterface.instance.prepareToRecordMpeg4Aac();
    // await AvPlatformInterface.instance.startRecording();
  }

  static Future<void> start() async {
    // await AvMethodChannel.instance.prepareToRecordMpeg4Aac();
    await AvPlatformInterface.instance.startRecording();
  }

  static Future<void> stop() async {
    await AvPlatformInterface.instance.stopRecording();
  }
}

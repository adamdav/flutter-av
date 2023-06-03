import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'av_platform_interface.dart';

/// An implementation of [AvPlatform] that uses method channels.
class MethodChannelAv extends AvPlatformInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('av');

  @override
  Future<String?> prepareToRecordMpeg4Aac(
      {int numberOfChannels = 2,
      int sampleRate = 44100,
      int bitRate = 256000}) async {
    // final tempDir = await getTemporaryDirectory();
    final args = {
      // 'filename': 'file://${tempDir.absolute.path}/${const Uuid().v4()}.m4a',

      'numberOfChannels': numberOfChannels,
      'sampleRate': sampleRate,
      'bitRate': bitRate,
    };
    print(args);
    final result = await methodChannel.invokeMethod<String?>(
        'prepareToRecordMpeg4Aac', args);
    print("prepared to record MPEG4 AAC: $result");
    return result;
  }

  @override
  Future<String?> prepareToRecordAlac(
      {int numberOfChannels = 2, int sampleRate = 44100}) async {
    final result =
        await methodChannel.invokeMethod<String?>('prepareToRecordAlac', {
      'filename': '.alac',
      'numberOfChannels': numberOfChannels,
      'sampleRate': sampleRate,
    });
    return result;
  }

  @override
  Future<bool?> startRecording({
    int numberOfChannels = 2,
    int sampleRate = 44100,
    int bitRate = 256000,
  }) async {
    final result = await methodChannel.invokeMethod<bool?>('startRecording');
    print("started recording: $result");
    return result;
  }

  @override
  Future<bool?> stopRecording() async {
    await methodChannel.invokeMethod<bool?>('stopRecording');
  }

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version =
  //       await methodChannel.invokeMethod<String>('getPlatformVersion');
  //   return version;
  // }
}

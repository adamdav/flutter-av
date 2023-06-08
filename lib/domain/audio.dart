import 'dart:async';

import 'package:av/av_platform_interface.dart';

class Audio {
  static final Audio _singleton = Audio._internal();

  factory Audio() {
    return _singleton;
  }

  Audio._internal();

  StreamSubscription onOutputFinished(Function(Map<String, dynamic>) callback) {
    return AvPlatformInterface.instance
        .getEventBroadcastStream()
        .listen((event) {
      if (event['type'] == 'audioPlayer/finishedPlaying') {
        callback(event['payload']);
      }
    });
  }

  StreamSubscription onInputCaptured(Function(Map) callback) {
    return AvPlatformInterface.instance
        .getEventBroadcastStream()
        .listen((event) {
      if (event['type'] == 'audioRecorder/metered') {
        callback(event['payload']);
      }
    });
  }

  Future<bool> prepareToRecord() async {
    return (await AvPlatformInterface.instance.prepareToRecordMpeg4Aac()) ??
        false;
  }

  Future<bool> startRecording() async {
    return (await AvPlatformInterface.instance.startRecording()) ?? false;
  }

  Future<String?> stopRecording() async {
    return await AvPlatformInterface.instance.stopRecording();
  }

  Future<bool> deleteRecording() async {
    return await AvPlatformInterface.instance.deleteRecording() ?? false;
  }

  Future<bool> prepareToPlay(String url) async {
    return (await AvPlatformInterface.instance.prepareToPlay(url)) ?? false;
  }

  Future<bool> startPlaying() async {
    return (await AvPlatformInterface.instance.startPlaying()) ?? false;
  }

  Future<bool> pausePlaying() async {
    return (await AvPlatformInterface.instance.pausePlaying()) ?? false;
  }

  Future<bool> skip(int interval) async {
    return (await AvPlatformInterface.instance.skip(interval)) ?? false;
  }
}

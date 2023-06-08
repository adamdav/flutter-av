import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
// import 'package:av/av.dart';
import 'package:av/av_platform_interface.dart';
import 'package:av/av_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAvPlatform
    with MockPlatformInterfaceMixin
    implements AvPlatformInterface {
  @override
  Future<bool?> prepareToRecordMpeg4Aac(
      {int numberOfChannels = 2,
      int sampleRate = 44100,
      int bitRate = 256000}) async {
    return Future.value(true);
  }

  @override
  Future<bool?> prepareToRecordAlac(
      {int numberOfChannels = 2, int sampleRate = 44100}) async {
    return Future.value(true);
  }

  @override
  Future<bool?> startRecording() async {
    return Future.value(true);
  }

  @override
  Future<String?> stopRecording() async {
    return Future.value('42');
  }

  @override
  Future<bool?> deleteRecording() async {
    return Future.value(true);
  }

  @override
  Future<bool?> prepareToPlay(String url) async {
    return Future.value(true);
  }

  @override
  Future<bool?> startPlaying() async {
    return Future.value(true);
  }

  @override
  Future<bool?> pausePlaying() async {
    return Future.value(true);
  }

  @override
  Stream getEventBroadcastStream() {
    return const Stream.empty();
  }

  @override
  Future<bool?> skip(num interval) async {
    return Future.value(true);
  }
}

void main() {
  final AvPlatformInterface initialPlatform = AvPlatformInterface.instance;

  test('$MethodChannelAv is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAv>());
  });

  // test('getPlatformVersion', () async {
  //   Av avPlugin = Av();
  //   MockAvPlatform fakePlatform = MockAvPlatform();
  //   AvPlatformInterface.instance = fakePlatform;

  //   expect(await avPlugin.getPlatformVersion(), '42');
  // });
}

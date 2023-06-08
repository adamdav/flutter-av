import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'av_method_channel.dart';

abstract class AvPlatformInterface extends PlatformInterface {
  /// Constructs a AvPlatformInterface.
  AvPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static AvPlatformInterface _instance = MethodChannelAv();

  /// The default instance of [AvPlatformInterface] to use.
  ///
  /// Defaults to [MethodChannelAv].
  static AvPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AvPlatformInterface] when
  /// they register themselves.
  static set instance(AvPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> prepareToRecordMpeg4Aac(
      {int numberOfChannels = 2,
      int sampleRate = 44100,
      int bitRate = 256000}) {
    throw UnimplementedError(
        'prepareToRecordMpeg4Aac() has not been implemented.');
  }

  Future<bool?> prepareToRecordAlac({
    int numberOfChannels = 2,
    int sampleRate = 44100,
  }) {
    throw UnimplementedError('prepareToRecordAlac() has not been implemented.');
  }

  Future<bool?> startRecording() {
    throw UnimplementedError('startRecording() has not been implemented.');
  }

  Future<String?> stopRecording() {
    throw UnimplementedError('stopRecording() has not been implemented.');
  }

  Future<bool?> deleteRecording() {
    throw UnimplementedError('deleteRecording() has not been implemented.');
  }

  Future<bool?> prepareToPlay(String url) {
    throw UnimplementedError('prepareToPlay() has not been implemented.');
  }

  Future<bool?> startPlaying() {
    throw UnimplementedError('startPlaying() has not been implemented.');
  }

  Future<bool?> pausePlaying() {
    throw UnimplementedError('pausePlaying() has not been implemented.');
  }

  Future<bool?> skip(num interval) async {
    throw UnimplementedError('skip() has not been implemented.');
  }

  Stream<dynamic> getEventBroadcastStream() {
    throw UnimplementedError(
        'getEventBroadcastStream() has not been implemented.');
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }
}

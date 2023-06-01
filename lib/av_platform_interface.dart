import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'av_method_channel.dart';

abstract class AvPlatform extends PlatformInterface {
  /// Constructs a AvPlatform.
  AvPlatform() : super(token: _token);

  static final Object _token = Object();

  static AvPlatform _instance = MethodChannelAv();

  /// The default instance of [AvPlatform] to use.
  ///
  /// Defaults to [MethodChannelAv].
  static AvPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AvPlatform] when
  /// they register themselves.
  static set instance(AvPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

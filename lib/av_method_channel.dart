import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'av_platform_interface.dart';

/// An implementation of [AvPlatform] that uses method channels.
class MethodChannelAv extends AvPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('av');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

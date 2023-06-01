
import 'av_platform_interface.dart';

class Av {
  Future<String?> getPlatformVersion() {
    return AvPlatform.instance.getPlatformVersion();
  }
}

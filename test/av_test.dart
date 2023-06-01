import 'package:flutter_test/flutter_test.dart';
import 'package:av/av.dart';
import 'package:av/av_platform_interface.dart';
import 'package:av/av_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAvPlatform
    with MockPlatformInterfaceMixin
    implements AvPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AvPlatform initialPlatform = AvPlatform.instance;

  test('$MethodChannelAv is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAv>());
  });

  test('getPlatformVersion', () async {
    Av avPlugin = Av();
    MockAvPlatform fakePlatform = MockAvPlatform();
    AvPlatform.instance = fakePlatform;

    expect(await avPlugin.getPlatformVersion(), '42');
  });
}

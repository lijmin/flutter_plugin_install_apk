import 'package:flutter_test/flutter_test.dart';
import 'package:install_apk/install_apk.dart';
import 'package:install_apk/install_apk_platform_interface.dart';
import 'package:install_apk/install_apk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInstallApkPlatform 
    with MockPlatformInterfaceMixin
    implements InstallApkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InstallApkPlatform initialPlatform = InstallApkPlatform.instance;

  test('$MethodChannelInstallApk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInstallApk>());
  });

  test('getPlatformVersion', () async {
    InstallApk installApkPlugin = InstallApk();
    MockInstallApkPlatform fakePlatform = MockInstallApkPlatform();
    InstallApkPlatform.instance = fakePlatform;
  
    expect(await installApkPlugin.getPlatformVersion(), '42');
  });
}

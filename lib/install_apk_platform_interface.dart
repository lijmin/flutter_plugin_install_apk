import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'install_apk_method_channel.dart';

abstract class InstallApkPlatform extends PlatformInterface {
  /// Constructs a InstallApkPlatform.
  InstallApkPlatform() : super(token: _token);

  static final Object _token = Object();

  static InstallApkPlatform _instance = MethodChannelInstallApk();

  /// The default instance of [InstallApkPlatform] to use.
  ///
  /// Defaults to [MethodChannelInstallApk].
  static InstallApkPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InstallApkPlatform] when
  /// they register themselves.
  static set instance(InstallApkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map> installApk(String filePath) {
    throw UnimplementedError('installApk() has not been implemented.');
  }
}

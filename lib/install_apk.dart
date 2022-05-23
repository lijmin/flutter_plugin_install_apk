
import 'install_apk_platform_interface.dart';

class InstallApk {
  Future<String?> getPlatformVersion() {
    return InstallApkPlatform.instance.getPlatformVersion();
  }

  Future<Map> installApk(String filePath) {
    return InstallApkPlatform.instance.installApk(filePath);
  }
}

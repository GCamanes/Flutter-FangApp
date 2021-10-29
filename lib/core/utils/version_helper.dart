import 'package:package_info/package_info.dart';

abstract class VersionHelper {
  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

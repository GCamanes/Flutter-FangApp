import 'package:fangapp/core/extensions/version_extension.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

abstract class VersionHelper {
  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Version appVersion = Version.parse(packageInfo.version);
    return appVersion.formattedVersion;
  }
}

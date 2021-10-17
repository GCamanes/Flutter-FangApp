import 'package:version/version.dart';

extension VersionExtension on Version {
  String get formattedVersion => 'Version $major.$minor.$patch';
}

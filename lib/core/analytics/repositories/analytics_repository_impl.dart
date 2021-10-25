import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fangapp/core/analytics/analytics_constants.dart';
import 'package:fangapp/core/analytics/analytics_event_name.dart';
import 'package:fangapp/core/analytics/analytics_param_name.dart';
import 'package:fangapp/core/analytics/datasources/analytics_data_source.dart';
import 'package:fangapp/core/analytics/entities/device_info_entity.dart';
import 'package:fangapp/core/analytics/repositories/analytics_repository.dart';
import 'package:fangapp/core/extensions/version_extension.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class AnalyticsRepositoryImpl extends AnalyticsRepository {
  AnalyticsRepositoryImpl({required this.analyticsDataSource});

  final AnalyticsDataSource analyticsDataSource;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<DeviceInfoEntity> _getDeviceInfo() async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      return DeviceInfoEntity(
        os: AnalyticsConstants.osAndroid,
        osVersion: androidInfo.version.release ?? '',
        model: '${androidInfo.manufacturer ?? ' '} ${androidInfo.model ?? ''}',
      );
    }
    if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
      return DeviceInfoEntity(
        os: iosInfo.systemName ?? '',
        osVersion: iosInfo.systemVersion ?? '',
        model: iosInfo.name ?? '',
      );
    }
    return const DeviceInfoEntity();
  }

  Future<Map<String, dynamic>> _getCommonParameters() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoEntity deviceInfo = await _getDeviceInfo();

    return <String, dynamic>{
      AnalyticsParamName.appVersion:
          Version.parse(packageInfo.version).formattedVersion,
      AnalyticsParamName.deviceOs: deviceInfo.os,
      AnalyticsParamName.deviceOsVersion: deviceInfo.osVersion,
      AnalyticsParamName.deviceModel: deviceInfo.model,
    };
  }

  @override
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return analyticsDataSource.observer;
  }

  Future<void> _sendEvent({
    required String name,
    Map<String, dynamic> parameters = const <String, dynamic>{},
  }) {
    return analyticsDataSource.sendEvent(
      name: name,
      parameters: parameters,
    );
  }

  @override
  Future<void> sendAppOpenEvent() {
    return analyticsDataSource.sendAppOpen();
  }

  @override
  Future<void> sendLoginErrorEvent({required String error}) async {
    final Map<String, dynamic> parameters = await _getCommonParameters();
    parameters.addAll(<String, dynamic>{
      AnalyticsParamName.error: error,
    });

    return _sendEvent(
      name: AnalyticsEventName.loginError,
      parameters: parameters,
    );
  }

  @override
  Future<void> sendLoginEvent({required String userMail}) async {
    final Map<String, dynamic> parameters = await _getCommonParameters();
    parameters.addAll(<String, dynamic>{
      AnalyticsParamName.userMail: userMail,
    });

    return _sendEvent(
      name: AnalyticsEventName.loginSuccess,
      parameters: parameters,
    );
  }

  @override
  Future<void> sendLogoutEvent() async {
    final Map<String, dynamic> parameters = await _getCommonParameters();

    return _sendEvent(
      name: AnalyticsEventName.logoutSuccess,
      parameters: parameters,
    );
  }
}

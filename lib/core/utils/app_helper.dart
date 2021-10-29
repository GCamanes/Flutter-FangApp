import 'dart:ui';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../get_it_injection.dart';

abstract class AppHelperBase {
  @protected
  late Size size;
  late bool trackingOn;

  Size get deviceSize => size;

  set deviceSize(Size newSize) => size = newSize;

  bool get analyticsTrackingOn => trackingOn;

  set analyticsTrackingOn(bool tracking) => trackingOn = tracking;
}

class AppHelper extends AppHelperBase {
  factory AppHelper() {
    return _instance;
  }

  AppHelper._internal() {
    size = Size.zero;
    trackingOn = getIt<SharedPreferences>()
            .getBool(AppConstants.sharedKeyAcceptAnalyticsTracking) ??
        false;
  }

  Future<void> updateTracking({bool tracking = false}) async {
    await getIt<SharedPreferences>()
        .setBool(AppConstants.sharedKeyAcceptAnalyticsTracking, tracking);
  }

  static final AppHelper _instance = AppHelper._internal();
}

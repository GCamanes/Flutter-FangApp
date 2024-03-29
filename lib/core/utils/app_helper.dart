import 'dart:ui';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../get_it_injection.dart';

abstract class AppHelperBase {
  @protected
  late Size size;
  // Snake game
  late double snakeBoxSize;
  // Analytics tracking
  bool? trackingOn;

  Size get deviceSize => size;

  set deviceSize(Size newSize) {
    size = newSize;
    snakeBoxSize = newSize.width / AppConstants.snakeNumberOfColumns;
  }
}

class AppHelper extends AppHelperBase {
  factory AppHelper() {
    return _instance;
  }

  AppHelper._internal() {
    size = Size.zero;
    trackingOn = getIt<SharedPreferences>()
        .getBool(AppConstants.sharedKeyAcceptAnalyticsTracking);
  }

  Future<bool> updateTracking({bool tracking = false}) async {
    await getIt<SharedPreferences>()
        .setBool(AppConstants.sharedKeyAcceptAnalyticsTracking, tracking);
    return trackingOn = tracking;
  }

  static final AppHelper _instance = AppHelper._internal();
}

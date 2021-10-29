import 'dart:ui';

import 'package:flutter/material.dart';

abstract class AppHelperBase {
  @protected
  late Size size;
  late bool trackingOn;

  Size get deviceSize => size;
  set deviceSize(Size newSize) => size = newSize;

  bool get analyticsTrackingOn => trackingOn;
  set analyticsTrackingOn(bool tracking) => trackingOn = tracking;
}

class AppHelper extends AppHelperBase{
  factory AppHelper() {
    return _instance;
  }

  AppHelper._internal() {
    size = Size.zero;
    trackingOn = false;
  }

  static final AppHelper _instance = AppHelper._internal();
}

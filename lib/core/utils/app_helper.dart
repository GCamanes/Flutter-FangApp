import 'dart:ui';

import 'package:flutter/material.dart';

abstract class AppHelperBase {
  @protected
  late Size size;

  Size get deviceSize => size;
  set deviceSize(Size newSize) => size = newSize;
}

class AppHelper extends AppHelperBase{
  factory AppHelper() {
    return _instance;
  }

  AppHelper._internal() {
    size = Size.zero;
  }

  static final AppHelper _instance = AppHelper._internal();
}

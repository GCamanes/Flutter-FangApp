import 'dart:ui';

class AppHelper {
  static Size size = Size.zero;

  Size get deviceSize => size;
  set deviceSize(Size newSize) => size = newSize;
}

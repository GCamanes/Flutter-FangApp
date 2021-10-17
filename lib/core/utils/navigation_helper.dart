import 'package:fangapp/core/navigation/routes.dart';
import 'package:flutter/material.dart';

abstract class NavigationHelper {
  static Future<void> goToRoute(String routeName, {int delay = 0}) async {
    await Future<void>.delayed(
      Duration(seconds: delay),
      () => RoutesManager.globalNavKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) => false,
      ),
    );
  }
}

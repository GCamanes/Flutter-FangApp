import 'package:fangapp/core/data/app_constants.dart';
import 'package:flutter/material.dart';

class RightToLeftPageBuilder extends PageRouteBuilder<dynamic> {
  RightToLeftPageBuilder({required this.routeWidget})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              routeWidget,
          transitionDuration: AppConstants.animPageTransitionDuration,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

  final Widget routeWidget;
}

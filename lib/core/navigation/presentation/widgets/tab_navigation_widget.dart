import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:fangapp/feature/bonus/presentation/pages/bonus_page.dart';
import 'package:fangapp/feature/home/presentation/pages/home_page.dart';
import 'package:fangapp/feature/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

class TabNavigationWidget extends StatelessWidget {
  const TabNavigationWidget({
    required this.navigatorKey,
    required this.tabItem,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final TabNavigationItem tabItem;

  Map<String, WidgetBuilder> _navigationRouteBuilders(
    BuildContext context, {
    Map<String, dynamic> arguments = const <String, dynamic>{},
  }) {
    return <String, WidgetBuilder>{
      //Manage Tab Item Routes
      RouteConstants.routeInitial: (BuildContext context) {
        if (tabItem == TabNavigationItem.settings) {
          return const SettingsPage();
        } else if (tabItem == TabNavigationItem.bonus) {
          return const BonusPage();
        } else {
          return const HomePage();
        }
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: RouteConstants.routeInitial,
      onGenerateRoute: (RouteSettings routeSettings) {
        final Map<String, WidgetBuilder> routeBuilders =
            _navigationRouteBuilders(
          context,
          arguments: (routeSettings.arguments ?? <String, dynamic>{})
              as Map<String, dynamic>,
        );
        if (routeSettings.name == RouteConstants.routeInitial) {
          return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                routeBuilders[RouteConstants.routeInitial]!(context),
          );
        }
        final Route<dynamic>? staticRoute =
            generateRoutes(context: context, routeSettings: routeSettings);
        if (staticRoute != null) {
          return staticRoute;
        }
        return resolveRoutes(
          context: context,
          routeSettings: routeSettings,
        );
      },
    );
  }
}

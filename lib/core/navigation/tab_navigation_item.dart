import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:flutter/material.dart';

enum TabNavigationItem { home, settings, bonus }

Map<TabNavigationItem, String> tabName = <TabNavigationItem, String>{
  TabNavigationItem.home: 'home',
  TabNavigationItem.settings: 'settings',
  TabNavigationItem.bonus: 'bonus',
};

Map<TabNavigationItem, String> tabRoute = <TabNavigationItem, String>{
  TabNavigationItem.home: RouteConstants.routeHome,
  TabNavigationItem.settings: RouteConstants.routeSettings,
  TabNavigationItem.bonus: RouteConstants.routeBonus,
};

Map<TabNavigationItem, IconData> tabIcon = <TabNavigationItem, IconData>{
  TabNavigationItem.home: Icons.home,
  TabNavigationItem.settings: Icons.settings,
  TabNavigationItem.bonus: Icons.star,
};

Map<TabNavigationItem, IconData> tabIconDisabled =
    <TabNavigationItem, IconData>{
  TabNavigationItem.home: Icons.home_outlined,
  TabNavigationItem.settings: Icons.settings_outlined,
  TabNavigationItem.bonus: Icons.star_outline,
};

import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({
    required this.currentTab,
    required this.onSelectTab,
  });

  final TabNavigationItem currentTab;
  final ValueChanged<TabNavigationItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.blueLight,
      unselectedItemColor: AppColors.white,
      showUnselectedLabels: false,
      selectedLabelStyle: AppStyles.mediumTitle(size: 10),
      unselectedLabelStyle: AppStyles.mediumTitle(size: 10),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.black90,
      currentIndex: _currentIndex(),
      items: <BottomNavigationBarItem>[
        _buildItem(context, TabNavigationItem.home),
        _buildItem(context, TabNavigationItem.settings),
        _buildItem(context, TabNavigationItem.bonus),
      ],
      onTap: (int index) {
        AnalyticsHelper()
            .sendClickBottomTabBar(item: TabNavigationItem.values[index]);
        onSelectTab(
          TabNavigationItem.values[index],
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(
    BuildContext context,
    TabNavigationItem tabItem,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(
        _iconTabMatching(tabItem),
        size: MediaQuery.of(context).size.width *
            (30 / AppConstants.uiModelWidth),
      ),
      label: 'bottomBar.${tabName[tabItem]!}'.translate(),
    );
  }

  IconData _iconTabMatching(TabNavigationItem item) {
    return currentTab == item ? tabIcon[item]! : tabIconDisabled[item]!;
  }

  int _currentIndex() {
    switch (currentTab) {
      case TabNavigationItem.settings:
        return 1;
      case TabNavigationItem.bonus:
        return 2;
      default:
        return 0;
    }
  }
}

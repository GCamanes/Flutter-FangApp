import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/navigation/presentation/cubit/tab_navigation_cubit.dart';
import 'package:fangapp/core/navigation/presentation/widgets/bottom_navigation_bar_widget.dart';
import 'package:fangapp/core/navigation/presentation/widgets/tab_navigation_widget.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../get_it_injection.dart';

class TabNavigationPage extends StatefulWidget {
  const TabNavigationPage({Key? key}) : super(key: key);

  @override
  _TabNavigationPageState createState() => _TabNavigationPageState();
}

class _TabNavigationPageState extends State<TabNavigationPage> {
  TabNavigationItem _currentTab = TabNavigationItem.home;
  final GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _settingsKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _bonusKey = GlobalKey<NavigatorState>();

  late TabNavigationCubit _tabNavigationCubit;

  @override
  void initState() {
    super.initState();
    _tabNavigationCubit = BlocProvider.of<TabNavigationCubit>(context);
    getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
  }

  void _onLocaleChanged(String language) {
    setState(() {});
  }

  GlobalKey<NavigatorState> _getNavigatorKey(TabNavigationItem tabItem) {
    switch (tabItem) {
      case TabNavigationItem.settings:
        return _settingsKey;
      case TabNavigationItem.bonus:
        return _bonusKey;
      default:
        return _homeKey;
    }
  }

  void _selectTab(TabNavigationItem tabItem, {bool forcePopUntil = false}) {
    final GlobalKey<NavigatorState> navKey = _getNavigatorKey(tabItem);
    bool needToPopUntil = false;
    if (tabItem == _currentTab) {
      needToPopUntil = true;
    } else {
      setState(() => _currentTab = tabItem);
      needToPopUntil = forcePopUntil;
    }
    if (needToPopUntil) {
      navKey.currentState!.popUntil((Route<dynamic> route) {
        return route.isFirst;
      });
    }
  }

  Future<bool> _managePopEvent() async {
    // Don't quit app if no possible pop
    final bool canPop =
        await _getNavigatorKey(_currentTab).currentState!.maybePop();
    return canPop;
  }

  Widget _buildOffstageTabNavigationWidget(TabNavigationItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigationWidget(
        navigatorKey: _getNavigatorKey(tabItem),
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _managePopEvent,
      child: Scaffold(
        body: BlocListener<TabNavigationCubit, TabNavigationState>(
          bloc: _tabNavigationCubit,
          listener: (BuildContext context, TabNavigationState state) {
            if (state is NavigationNextTab) {
              _selectTab(
                state.nextTab,
                forcePopUntil: state.forcePopUntilFirst,
              );
              if (state.routeSettings != null) {
                _getNavigatorKey(state.nextTab).currentState!.pushNamed(
                      state.routeSettings!.name!,
                      arguments: state.routeSettings!.arguments,
                    );
              }
              _tabNavigationCubit.resetState();
            }
          },
          child: Stack(
            children: <Widget>[
              _buildOffstageTabNavigationWidget(TabNavigationItem.home),
              _buildOffstageTabNavigationWidget(TabNavigationItem.settings),
              _buildOffstageTabNavigationWidget(TabNavigationItem.bonus),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }
}

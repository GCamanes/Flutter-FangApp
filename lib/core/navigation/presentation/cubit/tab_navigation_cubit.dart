import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:flutter/material.dart';

part 'tab_navigation_state.dart';

class TabNavigationCubit extends Cubit<TabNavigationState> {
  TabNavigationCubit() : super(NavigationInitial());

  TabNavigationState get initialState => NavigationInitial();

  void resetState() => emit(NavigationInitial());

  void changeTab({
    required TabNavigationItem nextTab,
    bool forcePopUntilFirst = false,
    RouteSettings? routeSettings,
  }) {
    emit(
      NavigationNextTab(
        nextTab: nextTab,
        forcePopUntilFirst: forcePopUntilFirst,
        routeSettings: routeSettings,
      ),
    );
  }
}

part of 'tab_navigation_cubit.dart';

abstract class TabNavigationState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class NavigationInitial extends TabNavigationState {}

class NavigationInProgress extends TabNavigationState {}

class NavigationNextTab extends TabNavigationState {
  NavigationNextTab({
    required this.nextTab,
    this.routeSettings,
    this.forcePopUntilFirst = false,
  });

  final TabNavigationItem nextTab;
  final RouteSettings? routeSettings;
  final bool forcePopUntilFirst;

  @override
  List<Object?> get props => <Object?>[
    nextTab,
    routeSettings,
    forcePopUntilFirst,
  ];
}

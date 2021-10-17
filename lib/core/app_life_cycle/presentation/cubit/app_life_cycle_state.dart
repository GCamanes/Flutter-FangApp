part of 'app_life_cycle_cubit.dart';

abstract class AppLifeCycleState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class AppLifeCycleInitial extends AppLifeCycleState {}

class AppForeground extends AppLifeCycleState {
  AppForeground({this.showWelcomeBack = false});

  final bool showWelcomeBack;

  @override
  List<Object> get props => <Object>[showWelcomeBack];
}

class AppBackground extends AppLifeCycleState {}

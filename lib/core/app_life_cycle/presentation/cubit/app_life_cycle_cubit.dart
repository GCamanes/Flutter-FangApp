import 'package:equatable/equatable.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_life_cycle_state.dart';

class AppLifeCycleBloc extends Cubit<AppLifeCycleState> {
  AppLifeCycleBloc({
    required SharedPreferences sharedPreferences,
  })  : _sharedPreferences = sharedPreferences,
        _wasInBackgroundBefore = false,
        super(AppLifeCycleInitial());

  final SharedPreferences _sharedPreferences;
  bool _wasInBackgroundBefore;

  void resetState() => emit(AppLifeCycleInitial());

  DateTime getDateEnterBackground() {
    final String? dateEnterBackground =
        _sharedPreferences.getString(AppConstants.sharedKeyDateEnterBackground);
    return DateTime.parse(dateEnterBackground ?? DateTime.now().toString());
  }

  void appEntersForeground() {
    _wasInBackgroundBefore = false;
    final DateTime dateEnterBackground = getDateEnterBackground();
    final int difference =
        DateTime.now().difference(dateEnterBackground).inMinutes;
    emit(
      AppForeground(
        showWelcomeBack:
            difference > AppConstants.backgroundTimeToShowWelcomeBack.inMinutes,
      ),
    );
  }

  Future<void> appEntersBackground() async {
    if (!_wasInBackgroundBefore) _wasInBackgroundBefore = true;
    await _sharedPreferences.setString(
      AppConstants.sharedKeyDateEnterBackground,
      DateTime.now().toString(),
    );
    emit(AppBackground());
  }
}

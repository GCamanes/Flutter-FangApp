import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';
import 'package:fangapp/feature/login/domain/usecases/get_current_app_user_use_case.dart';
import 'package:fangapp/feature/login/domain/usecases/login_app_user_use_case.dart';
import 'package:fangapp/feature/login/domain/usecases/logout_app_user_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required SharedPreferences sharedPreferences,
    required GetCurrentAppUser getCurrentAppUser,
    required LoginAppUser loginAppUser,
    required LogoutAppUser logoutAppUser,
  })  : _sharedPreferences = sharedPreferences,
        _getCurrentAppUser = getCurrentAppUser,
        _loginAppUser = loginAppUser,
        _logoutAppUser = logoutAppUser,
        super(LoginRequired());

  final SharedPreferences _sharedPreferences;
  final GetCurrentAppUser _getCurrentAppUser;
  final LoginAppUser _loginAppUser;
  final LogoutAppUser _logoutAppUser;

  LoginState get initialState => LoginRequired();

  void resetLogin() => emit(LoginRequired());

  Future<void> getCurrentUser() async {
    emit(LoginLoading());
    final Either<Failure, AppUserEntity> failureOrAppUser =
        await _getCurrentAppUser.execute();
    emit(_eitherSuccessOrErrorState(failureOrAppUser));
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final Either<Failure, AppUserEntity> failureOrAppUser =
        await _loginAppUser.execute(
      email: email,
      password: password,
    );
    emit(_eitherSuccessOrErrorState(failureOrAppUser));
  }

  Future<void> logoutUser() async {
    final Either<Failure, bool> failureOrLogout =
        await _logoutAppUser.execute();
    await _sharedPreferences.clear();
    emit(
      failureOrLogout.fold(
        // if Left
        (Failure failure) => LoginRequired(),
        // if Right
        (bool logout) => LoginRequired(),
      ),
    );
  }

  LoginState _eitherSuccessOrErrorState(
    Either<Failure, AppUserEntity> failureOrAppUser,
  ) {
    return failureOrAppUser.fold(
      // if Left
      (Failure failure) => LoginError(code: failure.failureCode),
      // if Right
      (AppUserEntity user) => LoginSuccess(user: user),
    );
  }
}

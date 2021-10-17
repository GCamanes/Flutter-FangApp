part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class LoginRequired extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  LoginSuccess({required this.user});

  final AppUserEntity user;

  @override
  List<Object> get props => <Object>[user];
}

class LoginError extends LoginState {
  LoginError({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';
import 'package:fangapp/feature/login/domain/repositories/login_repository.dart';

class LoginAppUser {
  LoginAppUser(this.repository);

  final LoginRepository repository;

  Future<Either<Failure, AppUserEntity>> execute({
    required String email,
    required String password,
  }) async {
    return repository.loginAppUser(email: email, password: password);
  }
}

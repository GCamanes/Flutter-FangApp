import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/login/domain/repositories/login_repository.dart';

class LogoutAppUser {
  LogoutAppUser(this.repository);

  final LoginRepository repository;

  Future<Either<Failure, bool>> execute() async {
    return repository.logoutAppUser();
  }
}

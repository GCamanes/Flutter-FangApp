import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';
import 'package:fangapp/feature/login/domain/repositories/login_repository.dart';

class GetCurrentAppUser {
  GetCurrentAppUser(this.repository);

  final LoginRepository repository;

  Future<Either<Failure, AppUserEntity>> execute() async {
    return repository.getCurrentAppUser();
  }
}

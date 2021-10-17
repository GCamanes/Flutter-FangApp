import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';

abstract class LoginRepository {
  // Get current user from firebase auth
  Either<Failure, AppUserEntity> getCurrentAppUser();

  // Login user to firebase auth (email/pwd)
  Future<Either<Failure, AppUserEntity>> loginAppUser({
    required String email,
    required String password,
  });

  // Logout user from firebase auth
  Future<Either<Failure, bool>> logoutAppUser();
}

import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/utils/firebase_error_helper.dart';
import 'package:fangapp/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';
import 'package:fangapp/feature/login/domain/repositories/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({
    required this.remoteDataSource,
  });

  final LoginRemoteDataSource remoteDataSource;

  @override
  Either<Failure, AppUserEntity> getCurrentAppUser() {
    final AppUserEntity user = remoteDataSource.getCurrentAppUser();
    if (user.success) {
      return Right<Failure, AppUserEntity>(user);
    }
    return Left<Failure, AppUserEntity>(CacheFailure());
  }

  @override
  Future<Either<Failure, AppUserEntity>> loginAppUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return Left<Failure, AppUserEntity>(EmptyFieldFailure());
    }
    try {
      final AppUserEntity user =
          await remoteDataSource.loginAppUser(email: email, password: password);
      return Right<Failure, AppUserEntity>(user);
    } on FirebaseAuthException catch (error) {
      return Left<Failure, AppUserEntity>(
        FirebaseFailure(
          errorCode: FirebaseErrorHelper.getAppException(error.code),
        ),
      );
    } catch (e) {
      return Left<Failure, AppUserEntity>(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logoutAppUser() async {
    try {
      await remoteDataSource.logoutAppUser();
      return const Right<Failure, bool>(true);
    } catch (e) {
      return Left<Failure, bool>(FirebaseFailure());
    }
  }
}

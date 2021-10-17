import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/utils/firebase_error_helper.dart';
import 'package:fangapp/feature/mangas/data/datasources/mangas_remote_data_source.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/domain/repositories/mangas_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MangasRepositoryImpl implements MangasRepository {
  MangasRepositoryImpl({
    required this.remoteDataSource,
  });

  final MangasRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<MangaEntity>>> getMangas() async {
    try {
      final List<MangaEntity> mangas =
          await remoteDataSource.getMangas();
      return Right<Failure, List<MangaEntity>>(mangas);
    } on FirebaseException catch (error) {
      return Left<Failure, List<MangaEntity>>(
        FirebaseFailure(
          errorCode: FirebaseErrorHelper.getAppException(error.code),
        ),
      );
    } catch (e) {
      return Left<Failure, List<MangaEntity>>(OfflineFailure());
    }
  }
}

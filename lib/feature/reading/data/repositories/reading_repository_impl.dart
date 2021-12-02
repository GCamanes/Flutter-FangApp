import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/utils/firebase_error_helper.dart';
import 'package:fangapp/feature/reading/data/datasources/reading_remote_data_source.dart';
import 'package:fangapp/feature/reading/domain/repositories/reading_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  ReadingRepositoryImpl({
    required this.remoteDataSource,
  });

  final ReadingRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<String>>> getPages({
    required String chapterKey,
    required String mangaKey,
  }) async {
    try {
      final List<String> pageUrls = await remoteDataSource.getPages(
        chapterKey: chapterKey,
        mangaKey: mangaKey,
      );
      return Right<Failure, List<String>>(pageUrls);
    } on FirebaseException catch (error) {
      return Left<Failure, List<String>>(
        FirebaseFailure(
          errorCode: FirebaseErrorHelper.getAppException(error.code),
        ),
      );
    } catch (error) {
      if (error is ChapterNotFoundException) {
        return Left<Failure, List<String>>(
          ChapterNotFoundFailure(),
        );
      }
      return Left<Failure, List<String>>(OfflineFailure());
    }
  }
}

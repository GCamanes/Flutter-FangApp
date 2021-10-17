import 'package:dartz/dartz.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/utils/firebase_error_helper.dart';
import 'package:fangapp/core/utils/list_helper.dart';
import 'package:fangapp/feature/chapters/data/datasources/chapters_remote_data_source.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/domain/repositories/chapters_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChaptersRepositoryImpl implements ChaptersRepository {
  ChaptersRepositoryImpl({
    required this.remoteDataSource,
  });

  final ChaptersRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Map<String, List<LightChapterEntity>>>>
      getChapterTabs({
    required String mangaKey,
  }) async {
    try {
      final List<LightChapterEntity> chapters =
          await remoteDataSource.getLightChapters(mangaKey: mangaKey);

      final List<List<LightChapterEntity>> chapterChunks =
          ListHelper<LightChapterEntity>()
              .chunk(chapters, AppConstants.maxChaptersPerTab);

      final Map<String, List<LightChapterEntity>> chapterTabs =
          <String, List<LightChapterEntity>>{};

      for (final List<LightChapterEntity> chunk in chapterChunks) {
        final String tabLabel = '${chunk.first.number} > '
            '${chunk.last.number}';
        chapterTabs[tabLabel] = chunk;
      }

      return Right<Failure, Map<String, List<LightChapterEntity>>>(chapterTabs);
    } on FirebaseException catch (error) {
      return Left<Failure, Map<String, List<LightChapterEntity>>>(
        FirebaseFailure(
          errorCode: FirebaseErrorHelper.getAppException(error.code),
        ),
      );
    } catch (error) {
      if (error is NoChapterFoundException) {
        return Left<Failure, Map<String, List<LightChapterEntity>>>(
          NoChapterFoundFailure(),
        );
      }
      return Left<Failure, Map<String, List<LightChapterEntity>>>(
        OfflineFailure(),
      );
    }
  }
}

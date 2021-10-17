import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';

abstract class ChaptersRepository {
  Future<Either<Failure, Map<String, List<LightChapterEntity>>>>
      getChapterTabs({
    required String mangaKey,
  });
}

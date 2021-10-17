import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/domain/repositories/chapters_repository.dart';

class GetChapterTabs {
  GetChapterTabs(this.repository);

  final ChaptersRepository repository;

  Future<Either<Failure, Map<String, List<LightChapterEntity>>>> execute({
    required String mangaKey,
  }) async {
    return repository.getChapterTabs(mangaKey: mangaKey);
  }
}

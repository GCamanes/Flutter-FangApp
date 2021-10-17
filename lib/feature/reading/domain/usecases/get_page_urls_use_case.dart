import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/reading/domain/repositories/reading_repository.dart';

class GetPageUrls {
  GetPageUrls(this.repository);

  final ReadingRepository repository;

  Future<Either<Failure, List<String>>> execute({
    required String chapterKey,
    required String mangaKey,
  }) async {
    return repository.getPageUrls(
      chapterKey: chapterKey,
      mangaKey: mangaKey,
    );
  }
}

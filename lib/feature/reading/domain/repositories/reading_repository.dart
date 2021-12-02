import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';

abstract class ReadingRepository {
  Future<Either<Failure, List<String>>> getPages({
    required String chapterKey,
    required String mangaKey,
  });
}

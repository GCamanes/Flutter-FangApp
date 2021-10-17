import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';

abstract class MangasRepository {
  Future<Either<Failure, List<MangaEntity>>> getMangas();
}

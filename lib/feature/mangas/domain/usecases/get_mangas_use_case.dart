import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/domain/repositories/mangas_repository.dart';

class GetMangas {
  GetMangas(this.repository);

  final MangasRepository repository;

  Future<Either<Failure, List<MangaEntity>>> execute() async {
    return repository.getMangas();
  }
}

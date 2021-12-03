import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/storage/domain/repositories/storage_repository.dart';

class GetStorageImageUrl {
  GetStorageImageUrl(this.repository);

  final StorageRepository repository;

  Future<Either<Failure, String>> execute({
    required String url,
  }) async {
    return repository.getStorageImageUrl(
      url: url,
    );
  }
}

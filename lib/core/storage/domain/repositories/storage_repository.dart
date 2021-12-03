import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/failure.dart';

abstract class StorageRepository {
  Future<Either<Failure, String>> getStorageImageUrl({
    required String url,
  });
}

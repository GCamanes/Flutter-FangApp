import 'package:dartz/dartz.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/storage/data/datasources/storage_remote_data_source.dart';
import 'package:fangapp/core/storage/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl({
    required this.remoteDataSource,
  });

  final StorageRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> getStorageImageUrl({
    required String url,
  }) async {
    try {
      final String pageUrl = await remoteDataSource.getStorageImageUrl(
        url: url,
      );
      return Right<Failure, String>(pageUrl);
    } on ImageNotFoundException {
      return Left<Failure, String>(
        ImageNotFoundFailure(),
      );
    }
  }
}

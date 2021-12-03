import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/storage/domain/usecases/get_storage_image_url_use_case.dart';

part 'storage_image_state.dart';

class StorageImageCubit extends Cubit<StorageImageState> {
  StorageImageCubit({
    required GetStorageImageUrl getStorageImageUrl,
  })  : _getStorageImageUrl = getStorageImageUrl,
        super(StorageImageInitial());

  final GetStorageImageUrl _getStorageImageUrl;

  StorageImageState get initialState => StorageImageInitial();

  void resetState() => emit(StorageImageInitial());

  Future<void> getStorageImageUrl({
    required String url,
  }) async {
    emit(StorageImageLoading());
    final Either<Failure, String> failureOrImageUrl =
        await _getStorageImageUrl.execute(url: url);
    emit(_eitherImageUrlOrErrorState(failureOrImageUrl));
  }

  StorageImageState _eitherImageUrlOrErrorState(
    Either<Failure, String> failureOrMangas,
  ) {
    return failureOrMangas.fold(
      // if Left
      (Failure failure) => StorageImageError(code: failure.failureCode),
      // if Right
      (String imageUrl) {
        return StorageImageLoaded(imageUrl: imageUrl);
      },
    );
  }
}

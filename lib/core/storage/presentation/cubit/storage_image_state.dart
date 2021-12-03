part of 'storage_image_cubit.dart';

abstract class StorageImageState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class StorageImageInitial extends StorageImageState {}

class StorageImageLoading extends StorageImageState {}

class StorageImageLoaded extends StorageImageState {
  StorageImageLoaded({required this.imageUrl});

  final String imageUrl;

  @override
  List<Object> get props => <Object>[imageUrl];
}

class StorageImageError extends StorageImageState {
  StorageImageError({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

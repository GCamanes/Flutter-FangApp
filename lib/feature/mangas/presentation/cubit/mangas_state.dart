part of 'mangas_cubit.dart';

abstract class MangasState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class MangasInitial extends MangasState {}

class MangasLoading extends MangasState {}

class MangasLoaded extends MangasState {
  MangasLoaded({required this.mangas});

  final List<MangaEntity> mangas;

  @override
  List<Object> get props => <Object>[mangas];
}

class MangasError extends MangasState {
  MangasError({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

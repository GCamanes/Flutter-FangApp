import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/domain/usecases/get_mangas_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mangas_state.dart';

class MangasCubit extends Cubit<MangasState> {
  MangasCubit({
    required SharedPreferences sharedPreferences,
    required GetMangas getMangas,
  })  : _sharedPreferences = sharedPreferences,
        _getMangas = getMangas,
        super(MangasInitial());

  final SharedPreferences _sharedPreferences;
  final GetMangas _getMangas;

  List<MangaEntity> _mangas = <MangaEntity>[];

  MangasState get initialState => MangasInitial();

  void resetState() => emit(MangasInitial());

  Future<void> getMangas() async {
    emit(MangasLoading());
    final Either<Failure, List<MangaEntity>> failureOrMangas =
        await _getMangas.execute();
    emit(_eitherMangasOrErrorState(failureOrMangas));
  }

  Future<void> updateMangaFavorite({
    required MangaEntity? manga,
  }) async {
    await _sharedPreferences.setBool(
      manga?.key ?? '',
      !(manga?.isFavorite ?? false),
    );
    _mangas = _mangas.map((MangaEntity prevManga) {
      if (manga?.key == prevManga.key) {
        return MangaEntity(
          authors: prevManga.authors,
          chapterKeys: prevManga.chapterKeys,
          coverLink: prevManga.coverLink,
          isFavorite: !(manga?.isFavorite ?? false),
          key: prevManga.key,
          lastRelease: prevManga.lastRelease,
          status: prevManga.status,
          title: prevManga.title,
        );
      }
      return prevManga;
    }).toList();
    emit(MangasLoaded(mangas: _mangas));
  }

  MangasState _eitherMangasOrErrorState(
    Either<Failure, List<MangaEntity>> failureOrMangas,
  ) {
    return failureOrMangas.fold(
      // if Left
      (Failure failure) => MangasError(code: failure.failureCode),
      // if Right
      (List<MangaEntity> mangas) {
        _mangas = mangas;
        return MangasLoaded(mangas: mangas);
      },
    );
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/utils/shared_preferences_helper.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/domain/usecases/get_chapters_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit({
    required SharedPreferences sharedPreferences,
    required GetChapterTabs getChapters,
  })  : _sharedPreferences = sharedPreferences,
        _getChapters = getChapters,
        super(ChaptersInitial());

  final SharedPreferences _sharedPreferences;
  final GetChapterTabs _getChapters;

  // Saving manga key used for loading chapters
  String _mangaKey = '';

  Map<String, List<LightChapterEntity>> _chapterTabs =
      <String, List<LightChapterEntity>>{};

  ChaptersState get initialState => ChaptersInitial();

  void resetState() => emit(ChaptersInitial());

  Future<void> getChapters({required String mangaKey}) async {
    _mangaKey = mangaKey;
    emit(ChaptersLoading());
    await Future<void>.delayed(500.milliseconds);
    final Either<Failure, Map<String, List<LightChapterEntity>>>
        failureOrChapters = await _getChapters.execute(mangaKey: mangaKey);
    emit(_eitherChaptersOrErrorState(failureOrChapters));
  }

  Future<void> updateLastReadChapter({required String number}) async {
    final String? previousLastRead = _sharedPreferences.getString(
      SharedPreferencesHelper.getLastReadChapterKey(_mangaKey),
    );

    final bool isSameLastReadAsBefore = previousLastRead == number;

    if (isSameLastReadAsBefore) {
      await _sharedPreferences.remove(
        SharedPreferencesHelper.getLastReadChapterKey(_mangaKey),
      );
    } else {
      await _sharedPreferences.setString(
        SharedPreferencesHelper.getLastReadChapterKey(_mangaKey),
        number,
      );
    }

    final Map<String, List<LightChapterEntity>> newChapterTabs =
        <String, List<LightChapterEntity>>{};

    for (final String key in _chapterTabs.keys) {
      newChapterTabs[key] = _chapterTabs[key]!
          .map(
            (LightChapterEntity chapter) => LightChapterEntity(
              key: chapter.key,
              isRead: isSameLastReadAsBefore
                  ? !isSameLastReadAsBefore
                  : chapter.number.compareTo(number) <= 0,
              number: chapter.number,
            ),
          )
          .toList();
    }
    emit(ChaptersLoaded(chapterTabs: newChapterTabs));
  }

  ChaptersState _eitherChaptersOrErrorState(
    Either<Failure, Map<String, List<LightChapterEntity>>> failureOrMangas,
  ) {
    return failureOrMangas.fold(
      // if Left
      (Failure failure) => ChaptersError(code: failure.failureCode),
      // if Right
      (Map<String, List<LightChapterEntity>> chapterTabs) {
        _chapterTabs = chapterTabs;
        return ChaptersLoaded(chapterTabs: chapterTabs);
      },
    );
  }
}

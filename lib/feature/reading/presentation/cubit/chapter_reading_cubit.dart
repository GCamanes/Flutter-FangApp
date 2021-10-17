import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fangapp/core/error/failure.dart';
import 'package:fangapp/feature/reading/domain/usecases/get_page_urls_use_case.dart';

part 'chapter_reading_state.dart';

class ChapterReadingCubit extends Cubit<ChapterReadingState> {
  ChapterReadingCubit({
    required GetPageUrls getPageUrls,
  })  : _getPageUrls = getPageUrls,
        super(ChapterReadingInitial());

  final GetPageUrls _getPageUrls;

  ChapterReadingState get initialState => ChapterReadingInitial();

  void resetState() => emit(ChapterReadingInitial());

  Future<void> getPageUrls({
    required String chapterKey,
    required String mangaKey,
  }) async {
    emit(ChapterReadingLoading());
    final Either<Failure, List<String>> failureOrPageUrls =
        await _getPageUrls.execute(chapterKey: chapterKey, mangaKey: mangaKey);
    emit(_eitherPageUrlsOrErrorState(failureOrPageUrls));
  }

  ChapterReadingState _eitherPageUrlsOrErrorState(
    Either<Failure, List<String>> failureOrMangas,
  ) {
    return failureOrMangas.fold(
      // if Left
      (Failure failure) => ChapterReadingError(code: failure.failureCode),
      // if Right
      (List<String> pageUrls) {
        return ChapterReadingLoaded(pageUrls: pageUrls);
      },
    );
  }
}

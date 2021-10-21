part of 'chapters_cubit.dart';

abstract class ChaptersState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class ChaptersInitial extends ChaptersState {}

class ChaptersLoading extends ChaptersState {}

class ChaptersLoaded extends ChaptersState {
  ChaptersLoaded({required this.chapterTabs});

  final Map<String, List<LightChapterEntity>> chapterTabs;

  int getLastReadIndex() {
    int indexFound = 0;
    for (final int index
        in List<int>.generate(chapterTabs.length, (int index) => index)) {
      indexFound = index;
      final String currentKey = chapterTabs.keys.toList()[index];
      for (final LightChapterEntity chapter in chapterTabs[currentKey]!) {
        if (!chapter.isRead) return indexFound;
      }
    }

    return indexFound;
  }

  LightChapterEntity? getLastReadChapter() {
    LightChapterEntity? lastReadChapter;
    for (final String key in chapterTabs.keys) {
      for (final LightChapterEntity chapter in chapterTabs[key]!) {
        if (!chapter.isRead) {
          return lastReadChapter;
        }
        lastReadChapter = chapter;
      }
    }
    return lastReadChapter;
  }

  LightChapterEntity findChapter(LightChapterEntity chapterToFind) {
    for (final String key in chapterTabs.keys) {
      for (final LightChapterEntity chapter in chapterTabs[key]!) {
        if (chapter.key == chapterToFind.key) return chapter;
      }
    }
    return chapterToFind;
  }

  @override
  List<Object> get props => <Object>[chapterTabs];
}

class ChaptersError extends ChaptersState {
  ChaptersError({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

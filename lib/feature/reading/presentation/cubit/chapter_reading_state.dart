part of 'chapter_reading_cubit.dart';

abstract class ChapterReadingState extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class ChapterReadingInitial extends ChapterReadingState {}

class ChapterReadingLoading extends ChapterReadingState {}

class ChapterReadingLoaded extends ChapterReadingState {
  ChapterReadingLoaded({required this.pageUrls});

  final List<String> pageUrls;

  @override
  List<Object> get props => <Object>[pageUrls];
}

class ChapterReadingError extends ChapterReadingState {
  ChapterReadingError({
    required this.code,
  });

  final String code;

  @override
  List<Object> get props => <Object>[code];
}

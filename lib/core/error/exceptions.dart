import 'package:fangapp/core/data/app_constants.dart';

class CacheException implements Exception {}

class NoChapterFoundException implements Exception {
  NoChapterFoundException({
    this.errorType = AppConstants.noChapterFoundException,
  });

  final String errorType;
}

class ChapterNotFoundException implements Exception {
  ChapterNotFoundException({
    this.errorType = AppConstants.chapterNotFoundException,
  });

  final String errorType;
}

class ImageNotFoundException implements Exception {
  ImageNotFoundException({
    this.errorType = AppConstants.imageNotFoundException,
  });

  final String errorType;
}

class OfflineException implements Exception {
  OfflineException({this.errorType = AppConstants.offlineException});

  final String errorType;
}

class TimeoutException implements Exception {}

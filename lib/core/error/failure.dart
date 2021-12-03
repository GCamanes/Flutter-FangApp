import 'package:equatable/equatable.dart';
import 'package:fangapp/core/data/app_constants.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => <Object>[];

  String get failureCode => AppConstants.unexpectedException;

  String get errorMessage => failureCode;
}

class CacheFailure extends Failure {
  @override
  String get failureCode => AppConstants.cacheException;
}

class FirebaseFailure extends Failure {
  FirebaseFailure({this.errorCode = AppConstants.unexpectedException});

  final String errorCode;

  @override
  String get failureCode => errorCode;
}

class EmptyFieldFailure extends Failure {
  @override
  String get failureCode => AppConstants.emptyFieldException;
}

class NoChapterFoundFailure extends Failure {
  @override
  String get failureCode => AppConstants.noChapterFoundException;
}

class ChapterNotFoundFailure extends Failure {
  @override
  String get failureCode => AppConstants.chapterNotFoundException;
}

class ImageNotFoundFailure extends Failure {
  @override
  String get failureCode => AppConstants.imageNotFoundException;
}

class OfflineFailure extends Failure {
  @override
  String get failureCode => AppConstants.offlineException;
}

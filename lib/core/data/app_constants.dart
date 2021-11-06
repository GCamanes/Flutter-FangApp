import 'package:flutter/material.dart';

abstract class AppConstants {
  // Localization
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];
  static List<String> supportedLanguages =
      supportedLocales.map((Locale locale) => locale.languageCode).toList();

  // UI values
  static const int uiModelWidth = 320;
  static const int uiModelHeight = 568;
  static const double uiModelWhRatio = uiModelWidth / uiModelHeight;

  // Failure code for exception
  static const String cacheException = 'CacheException';
  static const String offlineException = 'OfflineException';
  static const String emptyFieldException = 'EmptyFieldException';
  static const String unexpectedException = 'UnexpectedException';
  static const String userNotFoundException = 'UserNotFoundException';
  static const String wrongPasswordException = 'WrongPasswordException';
  static const String invalidEmailException = 'InvalidEmailException';
  static const String userDisabledException = 'UserDisabledException';
  static const String tooManyRequestException = 'TooManyRequestException';
  static const String objectNotFoundException = 'ObjectNotFoundException';
  static const String noChapterFoundException = 'NoChapterFoundException';
  static const String chapterNotFoundException = 'ChapterNotFoundException';

  // Firebase exception
  static const String userNotFoundFirebaseException = 'user-not-found';
  static const String userPasswordFirebaseException = 'wrong-password';
  static const String invalidEmailFirebaseException = 'invalid-email';
  static const String userDisabledFirebaseException = 'user-disabled';
  static const String tooManyRequestFirebaseException = 'too-many-requests';
  static const String offlineFirebaseException = 'network-request-failed';
  static const String objectNotFoundFirebaseException = 'object-not-found';

  // Images
  static const String coverPlaceHolderWaiting =
      'assets/images/manga_cover_placeholder_waiting.png';
  static const String coverPlaceHolderError =
      'assets/images/manga_cover_placeholder_error.png';
  static const double coverHeight = 95;
  static const double coverWidth = 64;

  // Animation
  static const Duration animDefaultDuration = Duration(milliseconds: 500);
  static const Duration animPageTransitionDuration =
      Duration(milliseconds: 300);
  static const Duration animLoginFormDuration = Duration(milliseconds: 600);
  static const Duration animLoginCloudDuration = animDefaultDuration;
  static const Duration animLoginFadeDuration = Duration(milliseconds: 200);

  // Firebase
  static const String firebaseMangasCollection = 'mangas';
  static const String firebaseChaptersCollection = 'chapters';

  // Shared preferences keys
  static const String sharedKeyDateEnterBackground =
      'SharedKeyDateEnterBackground';
  static const String sharedKeyLastChapterRead = 'lastChapterRead';
  static const String sharedKeyAcceptAnalyticsTracking =
      'acceptAnalyticsTracking';
  static const String sharedKeySnakeBestScore = 'snakeBestScore';

  // Times
  static const Duration backgroundTimeToShowWelcomeBack = Duration(minutes: 5);

  // Scroll keys
  static const String mangasPageStorageKey = 'mangasPageStorageKey';
  static const String mangasFavoritesPageStorageKey =
      'mangasFavoritesPageStorageKey';

  // Chapters
  static const int maxChaptersPerTab = 100;
  static const String splitCharsInChapterKey = '_chap_';
  static const int numberOfTilePerLine = 4;
  static const double spacingBetweenTile = 1;
  static const double tileAspectRatio = 2;

  // Snake game
  static const int snakeBaseSpeed = 200;
  static const int snakeMinSpeed = 50;
  static const double snakeSpeedIncreasePerLevel = 0.05;
  static const int snakeNumberOfColumns = 25;
  static const int snakePointPerSnack = 100;
  static const int snakePointPerLevel = 500;
  static const int snakeTimeBeforePoisonDisappear = 30;
  static const int snakeTimeBeforePoisonSpawn = 10;
}

import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:firebase_analytics/observer.dart';

abstract class AnalyticsRepository {
  FirebaseAnalyticsObserver getAnalyticsObserver();

  Future<void> sendAppOpenEvent();

  Future<void> sendLoginErrorEvent({
    required String error,
  });

  Future<void> sendLoginEvent({
    required String userMail,
  });

  Future<void> sendLogoutEvent();

  Future<void> sendClickBottomTabBarEvent({
    required TabNavigationItem item,
    required String path,
  });

  Future<void> sendAddFavoriteMangaEvent({
    required bool addFavorite,
    required String mangaKey,
  });

  Future<void> sendReloadEvent({
    required String path,
  });

  Future<void> sendViewPageEvent({
    required String path,
  });

  Future<void> sendChangeLanguageEvent({
    required String language,
  });

  Future<void> sendChapterRead({
    required bool readLastPage,
    required String mangaKey,
    required String chapterKey,
  });
}

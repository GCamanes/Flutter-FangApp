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

  Future<void> sendClickBottomTabBar({
    required TabNavigationItem item,
  });

  Future<void> sendAddFavoriteManga({
    required bool addFavorite,
    required String mangaKey,
  });
}

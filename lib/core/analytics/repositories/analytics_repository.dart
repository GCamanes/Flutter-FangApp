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
}

import 'package:firebase_analytics/observer.dart';

abstract class AnalyticsDataSource {
  FirebaseAnalyticsObserver get observer;

  Future<void> sendAppOpen();

  Future<void> sendEvent({
    required String name,
    Map<String, dynamic> parameters,
  });

  Future<void> setCurrentScreen({
    required String screenName,
  });
}

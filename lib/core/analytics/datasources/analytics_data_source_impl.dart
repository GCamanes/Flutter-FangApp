import 'package:fangapp/core/analytics/datasources/analytics_data_source.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsDataSourceImpl extends AnalyticsDataSource {
  AnalyticsDataSourceImpl(this.analytics)
      : _analyticsObserver = FirebaseAnalyticsObserver(analytics: analytics);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver _analyticsObserver;

  @override
  FirebaseAnalyticsObserver get observer => _analyticsObserver;

  @override
  Future<void> sendAppOpen() async {
    if (AppHelper().trackingOn ?? false) {
      debugPrint('ANALYTICS event: App Open');
      analytics.logAppOpen();
    }
  }

  @override
  Future<void> sendEvent({
    required String name,
    Map<String, dynamic> parameters = const <String, dynamic>{},
  }) async {
    if (AppHelper().trackingOn ?? false) {
      debugPrint('ANALYTICS event: $name $parameters');
      analytics.logEvent(name: name, parameters: parameters);
    }
  }

  @override
  Future<void> setCurrentScreen({required String screenName}) {
    debugPrint('ANALYTICS current screen: $screenName');
    return _analyticsObserver.analytics.setCurrentScreen(
      screenName: screenName,
    );
  }
}

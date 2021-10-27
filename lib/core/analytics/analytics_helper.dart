import 'package:fangapp/core/analytics/repositories/analytics_repository.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';

abstract class AnalyticsHelperBase {
  @protected
  late AnalyticsRepository repository;
}

class AnalyticsHelper extends AnalyticsHelperBase{
  factory AnalyticsHelper() {
    return _instance;
  }

  AnalyticsHelper._internal(AnalyticsRepository repo) {
    repository = repo;
  }

  static final AnalyticsHelper _instance = AnalyticsHelper._internal(getIt());

  Future<void> sendAppOpenEvent() async {
    return repository.sendAppOpenEvent();
  }

  Future<void> sendLoginErrorEvent({required String error}) async {
    return repository.sendLoginErrorEvent(error: error);
  }

  Future<void> sendLoginEvent({required String userMail}) async {
    return repository.sendLoginEvent(userMail: userMail);
  }

  Future<void> sendLogoutEvent() async {
    return repository.sendLogoutEvent();
  }

  Future<void> sendClickBottomTabBar({
    required TabNavigationItem item,
  }) {
    return repository.sendClickBottomTabBar(item: item);
  }
}

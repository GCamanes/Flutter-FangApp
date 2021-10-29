import 'package:fangapp/core/analytics/repositories/analytics_repository.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/navigation/tab_navigation_item.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';

abstract class AnalyticsHelperBase {
  @protected
  late AnalyticsRepository repository;
}

class AnalyticsHelper extends AnalyticsHelperBase {
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

  Future<void> sendClickBottomTabBarEvent({
    required TabNavigationItem item,
    required String path,
  }) {
    return repository.sendClickBottomTabBarEvent(item: item, path: path);
  }

  Future<void> sendAddFavoriteMangaEvent({
    required bool addFavorite,
    required String mangaKey,
  }) {
    return repository.sendAddFavoriteMangaEvent(
      addFavorite: addFavorite,
      mangaKey: mangaKey,
    );
  }

  Future<void> sendReloadEvent({
    required String path,
  }) {
    return repository.sendReloadEvent(
      path: path,
    );
  }

  Future<void> sendViewPageEvent({
    required String path,
  }) {
    RoutesManager.updateTabItemCurrentPaths(path);
    return repository.sendViewPageEvent(
      path: path,
    );
  }

  Future<void> sendChangeLanguageEvent({
    required String language,
  }) {
    return repository.sendChangeLanguageEvent(
      language: language,
    );
  }

  Future<void> sendChapterRead({
    bool readLastPage = false,
    required String mangaKey,
    required String chapterKey,
  }) {
    return repository.sendChapterRead(
      readLastPage: readLastPage,
      mangaKey: mangaKey,
      chapterKey: chapterKey,
    );
  }
}

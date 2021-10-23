import 'package:fangapp/core/navigation/presentation/pages/not_found_page.dart';
import 'package:fangapp/core/navigation/presentation/pages/tab_navigation_page.dart';
import 'package:fangapp/core/navigation/presentation/widgets/right_to_left_page_builder.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/feature/bonus/presentation/pages/bonus_sunny_page.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/pages/chapters_page.dart';
import 'package:fangapp/feature/login/presentation/pages/login_page.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/reading/presentation/pages/chapter_reading_page.dart';
import 'package:fangapp/feature/splashscreen/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoutes({
  required BuildContext context,
  required RouteSettings routeSettings,
}) {
  final Function? pageBuilderFunction =
      Routes.mainPageRoutesBuilder[routeSettings.name];
  if (pageBuilderFunction != null) {
    return pageBuilderFunction(context, routeSettings.arguments)
        as Route<dynamic>;
  }

  return null;
}

Route<dynamic> resolveRoutes({
  required BuildContext context,
  required RouteSettings routeSettings,
}) {
  return RightToLeftPageBuilder(routeWidget: NotFoundPage());
}

// ignore: avoid_classes_with_only_static_members
class Routes {
  static final Map<String, Function> mainPageRoutesBuilder = <String, Function>{
    RouteConstants.routeInitial: (_, __) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (_, __, ___) => const SplashScreen(),
      );
    },
    RouteConstants.routeLogin: (_, __) =>
        RightToLeftPageBuilder(routeWidget: const LoginPage()),
    RouteConstants.routeBottomNav: (_, __) =>
        RightToLeftPageBuilder(routeWidget: const TabNavigationPage()),
    RouteConstants.routeChapters: (_, Map<dynamic, dynamic>? arguments) {
      final MangaEntity? manga =
          (arguments?.containsKey(RouteArguments.argumentManga) ?? false)
              ? arguments![RouteArguments.argumentManga] as MangaEntity
              : null;
      return RightToLeftPageBuilder(routeWidget: ChaptersPage(manga: manga));
    },
    RouteConstants.routeChapterReading: (_, Map<dynamic, dynamic>? arguments) {
      final MangaEntity? manga =
          (arguments?.containsKey(RouteArguments.argumentManga) ?? false)
              ? arguments![RouteArguments.argumentManga] as MangaEntity
              : null;
      final LightChapterEntity? chapter =
          (arguments?.containsKey(RouteArguments.argumentChapter) ?? false)
              ? arguments![RouteArguments.argumentChapter] as LightChapterEntity
              : null;
      return RightToLeftPageBuilder(
        routeWidget: ChapterReadingPage(chapter: chapter, manga: manga),
      );
    },
    RouteConstants.routeBonusSunny: (_, __) =>
        RightToLeftPageBuilder(routeWidget: const BonusSunnyPage()),
  };
}

class RoutesManager {
  static final GlobalKey<NavigatorState> globalNavKey =
      GlobalKey<NavigatorState>();

  static Future<T?> pushNamed<T>({
    required BuildContext context,
    required String pageRouteName,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    bool fullScreen = false,
  }) async {
    return (fullScreen ? globalNavKey.currentState : Navigator.of(context))!
        .pushNamed(
      pageRouteName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T>({
    required BuildContext context,
    required String pageRouteName,
    Map<String, dynamic> arguments = const <String, dynamic>{},
    bool fullScreen = false,
  }) {
    return (fullScreen ? globalNavKey.currentState : Navigator.of(context))!
        .pushReplacementNamed(
      pageRouteName,
      arguments: arguments,
    );
  }

  static Future<T?> push<T>(
    BuildContext context,
    Route<T> route, {
    bool fullScreen = false,
  }) {
    return (fullScreen ? globalNavKey.currentState : Navigator.of(context))!
        .push(
      route,
    );
  }
}

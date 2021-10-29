import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapterTileWidget extends StatelessWidget {
  const ChapterTileWidget({
    Key? key,
    required this.chapter,
    required this.manga,
  }) : super(key: key);

  final LightChapterEntity chapter;
  final MangaEntity manga;

  @override
  Widget build(BuildContext context) {
    return AppButtonWidget(
      onPressed: () async {
        final dynamic backPressed = await RoutesManager.pushNamed(
          context: context,
          pageRouteName: RouteConstants.routeChapterReading,
          arguments: <String, dynamic>{
            RouteArguments.argumentChapter: chapter,
            RouteArguments.argumentManga: manga,
          },
          fullScreen: true,
        );
        if (backPressed != null) {
          AnalyticsHelper().sendViewPageEvent(
            path: '${RouteConstants.routeChapters}/${manga.key}',
          );
        }
      },
      onLongPressed: () {
        if (!chapter.isRead) {
          AnalyticsHelper().sendChapterRead(
            mangaKey: manga.key,
            chapterKey: chapter.key,
          );
        }
        BlocProvider.of<ChaptersCubit>(context).updateLastReadChapter(
          number: chapter.number,
        );
      },
      borderRadius: 0,
      color: chapter.isRead ? AppColors.blackSmoke : AppColors.greyLight,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      textSize: 12,
      textColor: chapter.isRead ? AppColors.white : AppColors.black90,
      text: chapter.number,
    );
  }
}

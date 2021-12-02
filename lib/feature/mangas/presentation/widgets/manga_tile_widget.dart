import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/app_icon_button_widget.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/presentation/cubit/mangas_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MangaTileWidget extends StatelessWidget {
  const MangaTileWidget({
    Key? key,
    required this.manga,
  }) : super(key: key);

  final MangaEntity manga;

  Future<void> goToChapters(BuildContext context) async {
    final dynamic backPressed = await RoutesManager.pushNamed(
      context: context,
      pageRouteName: RouteConstants.routeChapters,
      arguments: <String, dynamic>{
        RouteArguments.argumentManga: manga,
      },
    );
    if (backPressed != null) {
      AnalyticsHelper().sendViewPageEvent(path: RouteConstants.routeHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        bottom: 10,
      ),
      decoration: const BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: InkWell(
        onTap: () => goToChapters(context),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: (manga.coverLink == AppConstants.objectNotFoundException)
                  ? Image.asset(
                      AppConstants.coverPlaceHolderError,
                      width: AppConstants.coverWidth,
                      height: AppConstants.coverHeight,
                      fit: BoxFit.fill,
                    )
                  : FadeInImage.assetNetwork(
                      placeholder: AppConstants.coverPlaceHolderWaiting,
                      placeholderErrorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stacktrace,
                      ) =>
                          const SizedBox(
                        width: AppConstants.coverWidth,
                        height: AppConstants.coverHeight,
                      ),
                      width: AppConstants.coverWidth,
                      height: AppConstants.coverHeight,
                      fit: BoxFit.fill,
                      image: manga.coverLink,
                      imageErrorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stacktrace,
                      ) {
                        return Image.asset(
                          AppConstants.coverPlaceHolderError,
                          width: AppConstants.coverWidth,
                          height: AppConstants.coverHeight,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    manga.title,
                    style: AppStyles.highTitle(size: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    manga.authors.join(', '),
                    style: AppStyles.regularText(size: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (manga.chapterKeys.isNotEmpty)
                    Text(
                      'mangas.lastRelease'.translateWithArgs(
                        args: <String>[
                          manga.chapterKeys.last
                              .split(AppConstants.splitCharsInChapterKey)
                              .last
                        ],
                      ),
                      style: AppStyles.regularText(
                        size: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    'mangas.${manga.status}'.translate(),
                    style: AppStyles.mediumTitle(
                      size: 12,
                      color: manga.status == 'Ongoing'
                          ? AppColors.green
                          : AppColors.orange,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppIconButtonWidget(
              icon: manga.isFavorite ? Icons.favorite : Icons.favorite_outline,
              color: manga.isFavorite
                  ? AppColors.orange
                  : AppColors.blackSmokeLight,
              size: 25,
              onPress: () {
                AnalyticsHelper().sendAddFavoriteMangaEvent(
                  addFavorite: !manga.isFavorite,
                  mangaKey: manga.key,
                );
                BlocProvider.of<MangasCubit>(context)
                    .updateMangaFavorite(manga: manga);
              },
            )
          ],
        ),
      ),
    );
  }
}

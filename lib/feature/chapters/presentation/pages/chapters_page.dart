import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/icon_button_widget.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:fangapp/core/widget/reload_icon_widget.dart';
import 'package:fangapp/core/widget/tab_bar_widget.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/chapters/presentation/widgets/chapters_list_widget.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/presentation/cubit/mangas_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../get_it_injection.dart';

class ChaptersPage extends StatefulWidget {
  const ChaptersPage({Key? key, required this.manga}) : super(key: key);

  final MangaEntity? manga;

  @override
  _ChaptersPageState createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  late MangaEntity? _manga;
  late Map<String, List<LightChapterEntity>> _chapterTabs;
  bool _hasLoadAtLeastOnce = false;

  @override
  void initState() {
    super.initState();
    getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
    _manga = widget.manga;
    _chapterTabs = <String, List<LightChapterEntity>>{};
    _tabController = TabController(
      vsync: this,
      length: _chapterTabs.length,
    );
    BlocProvider.of<ChaptersCubit>(context)
        .getChapters(mangaKey: _manga?.key ?? '');
  }

  Future<void> _onLocaleChanged(String language) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<MangasCubit, MangasState>(
          listener: (BuildContext context, MangasState state) {
            if (state is MangasLoaded) {
              setState(() {
                _manga = state.mangas.firstWhere(
                  (MangaEntity manga) => manga.key == (_manga?.key ?? ''),
                );
              });
            }
          },
        ),
        BlocListener<ChaptersCubit, ChaptersState>(
          listener: (BuildContext context, ChaptersState state) {
            if (state is ChaptersLoaded) {
              // Compute initial index of tab controller
              int initialIndex = _tabController.index > _chapterTabs.length
                  ? _chapterTabs.length
                  : _tabController.index;
              // If first load, init index where the last read chapter is
              if (!_hasLoadAtLeastOnce) {
                initialIndex = state.getLastReadIndex();
              }
              setState(() {
                _chapterTabs = state.chapterTabs;
                _tabController = TabController(
                  vsync: this,
                  length: _chapterTabs.length,
                  initialIndex: initialIndex,
                );
                _hasLoadAtLeastOnce = true;
              });
            } else if (state is ChaptersError) {
              setState(() {
                _chapterTabs = <String, List<LightChapterEntity>>{};
                _tabController = TabController(
                  vsync: this,
                  length: _chapterTabs.length,
                );
                _hasLoadAtLeastOnce = true;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<ChaptersCubit, ChaptersState>(
        builder: (BuildContext context, ChaptersState state) {
          return Scaffold(
            appBar: AppBarWidget(
              title: widget.manga?.title ?? '',
              actionsList: <Widget>[
                AnimatedOpacity(
                  opacity: _hasLoadAtLeastOnce ? 1.0 : 0.0,
                  duration: AppConstants.animDefaultDuration,
                  child: ReloadIconWidget(
                    onPress: state is! ChaptersLoading
                        ? () => BlocProvider.of<ChaptersCubit>(context)
                            .getChapters(mangaKey: _manga?.key ?? '')
                        : null,
                  ),
                ),
                AppIconButtonWidget(
                  icon: _manga?.isFavorite ?? false
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: _manga?.isFavorite ?? false
                      ? AppColors.orange
                      : AppColors.white,
                  size: 25,
                  onPress: () {
                    BlocProvider.of<MangasCubit>(context)
                        .updateMangaFavorite(manga: _manga);
                  },
                ),
              ],
              bottom: TabBarWidget(
                showNavigateButtons: true,
                labels: _chapterTabs.keys.toList(),
                labelSize: 12,
                tabController: _tabController,
              ),
            ),
            body: BlocBuilder<ChaptersCubit, ChaptersState>(
              builder: (BuildContext context, ChaptersState state) {
                if (state is ChaptersLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: _chapterTabs.keys
                        .map(
                          (String key) => ChaptersListWidget(
                            chapters: _chapterTabs[key]!,
                            manga: widget.manga!,
                            pageKey: key,
                          ),
                        )
                        .toList(),
                  );
                }
                if (state is ChaptersLoading) {
                  return const LoadingWidget();
                }
                if (state is ChaptersError) {
                  return Center(
                    child: MessageWidget(
                      message: 'error.${state.code}'.translate(),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}

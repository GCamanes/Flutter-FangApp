import 'dart:async';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/widgets/chapter_tile_widget.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:flutter/material.dart';

class ChaptersListWidget extends StatefulWidget {
  const ChaptersListWidget({
    Key? key,
    required this.chapters,
    this.lastChapterRead,
    required this.pageKey,
    required this.manga,
  }) : super(key: key);

  final List<LightChapterEntity> chapters;
  final LightChapterEntity? lastChapterRead;
  final String pageKey;
  final MangaEntity manga;

  @override
  _ChaptersListWidgetState createState() => _ChaptersListWidgetState();
}

class _ChaptersListWidgetState extends State<ChaptersListWidget> {
  final ScrollController _scrollController = ScrollController();

  int findLastReadChapterIndex() {
    for (final int index
        in List<int>.generate(widget.chapters.length, (int index) => index)) {
      if (widget.chapters[index].key == (widget.lastChapterRead?.key ?? '')) {
        return index;
      }
    }
    return 0;
  }

  double findLastReadChapterPosition() {
    final int indexFound = findLastReadChapterIndex();
    final int indexLine = indexFound ~/ AppConstants.numberOfTilePerLine;

    final double tileHeight = getTileHeight();
    return indexLine * tileHeight + indexLine * AppConstants.spacingBetweenTile;
  }

  double getTileHeight() {
    final Size size =
        MediaQuery.of(RoutesManager.globalNavKey.currentContext!).size;
    const double totalPacing = (AppConstants.numberOfTilePerLine - 1) *
        AppConstants.spacingBetweenTile;
    final double tileWidth =
        (size.width - 20 - totalPacing) / AppConstants.numberOfTilePerLine;
    return tileWidth / AppConstants.tileAspectRatio;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(
      1000.milliseconds,
      () => _scrollController.position.moveTo(
        findLastReadChapterPosition(),
        duration: 1.seconds,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      controller: _scrollController,
      key: PageStorageKey<String>('${widget.manga.key}_${widget.pageKey}'),
      crossAxisCount: AppConstants.numberOfTilePerLine,
      crossAxisSpacing: AppConstants.spacingBetweenTile,
      mainAxisSpacing: AppConstants.spacingBetweenTile,
      padding: const EdgeInsets.all(10),
      childAspectRatio: AppConstants.tileAspectRatio,
      children: widget.chapters
          .map(
            (LightChapterEntity chapter) => ChapterTileWidget(
              chapter: chapter,
              manga: widget.manga,
            ),
          )
          .toList(),
    );
  }
}

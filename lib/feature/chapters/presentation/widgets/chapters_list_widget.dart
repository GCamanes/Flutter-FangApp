import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/widgets/chapter_tile_widget.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:flutter/material.dart';

class ChaptersListWidget extends StatelessWidget {
  const ChaptersListWidget({
    Key? key,
    required this.chapters,
    required this.pageKey,
    required this.manga,
  }) : super(key: key);

  final List<LightChapterEntity> chapters;
  final String pageKey;
  final MangaEntity manga;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      key: PageStorageKey<String>('${manga.key}_$pageKey'),
      crossAxisCount: 4,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      padding: const EdgeInsets.all(10),
      childAspectRatio: 2,
      children: chapters
          .map(
            (LightChapterEntity chapter) => ChapterTileWidget(
              chapter: chapter,
              manga: manga,
            ),
          )
          .toList(),
    );
  }
}

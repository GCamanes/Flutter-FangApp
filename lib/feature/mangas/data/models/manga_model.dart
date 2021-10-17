import 'dart:convert';

import 'package:fangapp/core/data/json_constants.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';

class MangaModel extends MangaEntity {
  const MangaModel({
    required List<String> authors,
    required List<String> chapterKeys,
    required String coverLink,
    bool isFavorite = false,
    required String key,
    required String lastRelease,
    required String status,
    required String title,
  }) : super(
          authors: authors,
          chapterKeys: chapterKeys,
          coverLink: coverLink,
          isFavorite: isFavorite,
          key: key,
          lastRelease: lastRelease,
          status: status,
          title: title,
        );

  factory MangaModel.fromJson({
    required Map<String, dynamic> data,
    bool withChapters = false,
  }) {
    return MangaModel(
      authors: data.containsKey(JsonConstants.jsonAuthorsKey)
          ? List<String>.from(
              data[JsonConstants.jsonAuthorsKey] as List<dynamic>,
            )
          : <String>[],
      chapterKeys: data.containsKey(JsonConstants.jsonChapterKeysKey)
          ? (withChapters
              ? List<String>.from(
                  data[JsonConstants.jsonChapterKeysKey] as List<dynamic>,
                )
              : <String>[])
          : <String>[],
      coverLink: data[JsonConstants.jsonCoverLinkKey]?.toString() ?? '',
      key: data[JsonConstants.jsonKeyKey]?.toString() ?? '',
      lastRelease: data[JsonConstants.jsonLastReleaseKey]?.toString() ?? '',
      status: data[JsonConstants.jsonStatusKey]?.toString() ?? '',
      title: data[JsonConstants.jsonTitleKey]?.toString() ?? '',
    );
  }

  factory MangaModel.fromManga({
    required MangaModel manga,
    String? coverDownloadedLink,
    bool isFavorite = false,
  }) {
    return MangaModel(
      authors: manga.authors,
      chapterKeys: manga.chapterKeys,
      coverLink: coverDownloadedLink ?? manga.coverLink,
      isFavorite: isFavorite,
      key: manga.key,
      lastRelease: manga.lastRelease,
      status: manga.status,
      title: manga.title,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      JsonConstants.jsonAuthorsKey: json.encode(List<String>.from(authors)),
      JsonConstants.jsonChapterKeysKey:
          json.encode(List<String>.from(chapterKeys)),
      JsonConstants.jsonCoverLinkKey: coverLink,
      JsonConstants.jsonKeyKey: key,
      JsonConstants.jsonLastReleaseKey: lastRelease,
      JsonConstants.jsonStatusKey: status,
      JsonConstants.jsonTitleKey: title,
    };
  }
}

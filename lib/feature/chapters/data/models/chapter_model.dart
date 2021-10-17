import 'dart:convert';

import 'package:fangapp/core/data/json_constants.dart';
import 'package:fangapp/feature/chapters/domain/entities/chapter_entity.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    bool isRead = false,
    required String key,
    required String number,
    required List<String> pages,
  }) : super(
          isRead: isRead,
          key: key,
          number: number,
          pages: pages,
        );

  factory ChapterModel.fromJson({
    required Map<String, dynamic> data,
    String lastReadChapterNumber = '',
  }) {
    final String number = data[JsonConstants.jsonNumberKey]?.toString() ?? '';
    final bool isRead = lastReadChapterNumber.isNotEmpty &&
        number.compareTo(lastReadChapterNumber) <= 0;
    return ChapterModel(
      key: data[JsonConstants.jsonKeyKey]?.toString() ?? '',
      isRead: isRead,
      number: number,
      pages: data.containsKey(JsonConstants.jsonPagesKey)
          ? List<String>.from(
              data[JsonConstants.jsonPagesKey] as List<dynamic>,
            )
          : <String>[],
    );
  }

  factory ChapterModel.fromManga({
    required ChapterModel chapter,
    List<String> pagesDownloadedLink = const <String>[],
    bool isRead = false,
  }) {
    return ChapterModel(
      isRead: isRead,
      key: chapter.key,
      number: chapter.number,
      pages: pagesDownloadedLink,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      JsonConstants.jsonKeyKey: key,
      JsonConstants.jsonNumberKey: number,
      JsonConstants.jsonPagesKey: json.encode(List<String>.from(pages)),
    };
  }
}

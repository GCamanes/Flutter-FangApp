import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/data/json_constants.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';

class LightChapterModel extends LightChapterEntity {
  const LightChapterModel({
    bool isRead = false,
    required String key,
    required String number,
  }) : super(
          isRead: isRead,
          key: key,
          number: number,
        );

  factory LightChapterModel.fromString({
    required String str,
    String lastReadChapterNumber = '',
  }) {
    final String number = str.split(AppConstants.splitCharsInChapterKey).last;
    final bool isRead = lastReadChapterNumber.isNotEmpty &&
        number.compareTo(lastReadChapterNumber) <= 0;
    return LightChapterModel(
      key: str,
      isRead: isRead,
      number: number,
    );
  }

  factory LightChapterModel.fromLightChapter({
    required LightChapterModel chapter,
    bool isRead = false,
  }) {
    return LightChapterModel(
      isRead: isRead,
      key: chapter.key,
      number: chapter.number,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      JsonConstants.jsonKeyKey: key,
      JsonConstants.jsonNumberKey: number,
    };
  }
}

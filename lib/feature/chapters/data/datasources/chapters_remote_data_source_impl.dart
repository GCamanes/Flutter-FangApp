import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/core/utils/shared_preferences_helper.dart';
import 'package:fangapp/feature/chapters/data/datasources/chapters_remote_data_source.dart';
import 'package:fangapp/feature/chapters/data/models/light_chapter_model.dart';
import 'package:fangapp/feature/mangas/data/models/manga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChaptersRemoteDataSourceImpl implements ChaptersRemoteDataSource {
  ChaptersRemoteDataSourceImpl(
    this.sharedPreferences,
  );

  final SharedPreferences sharedPreferences;

  @override
  Future<List<LightChapterModel>> getLightChapters({
    required String mangaKey,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection(AppConstants.firebaseMangasCollection)
            .doc(mangaKey)
            .get();

    if (querySnapshot.metadata.isFromCache) {
      throw OfflineException();
    }

    final String lastReadChapterNumber = sharedPreferences.getString(
          SharedPreferencesHelper.getLastReadChapterKey(mangaKey),
        ) ??
        '';

    final MangaModel manga = MangaModel.fromJson(
      data: querySnapshot.data() ?? <String, dynamic>{},
      withChapters: true,
    );

    if (manga.chapterKeys.isEmpty) throw NoChapterFoundException();

    return manga.chapterKeys
        .map(
          (String chapterKey) => LightChapterModel.fromString(
            str: chapterKey,
            lastReadChapterNumber: lastReadChapterNumber,
          ),
        )
        .toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/feature/chapters/data/models/chapter_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

import 'reading_remote_data_source.dart';

class ReadingRemoteDataSourceImpl implements ReadingRemoteDataSource {
  ReadingRemoteDataSourceImpl(
    this.sharedPreferences,
  );

  final SharedPreferences sharedPreferences;

  Future<String> getPageUrl(String partialLink) async {
    try {
      return await firebase_storage.FirebaseStorage.instance
          .ref(partialLink)
          .getDownloadURL();
    } catch (e) {
      return AppConstants.objectNotFoundException;
    }
  }

  @override
  Future<List<String>> getPages({
    required String chapterKey,
    required String mangaKey,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection(AppConstants.firebaseMangasCollection)
            .doc(mangaKey)
            .collection(AppConstants.firebaseChaptersCollection)
            .doc(chapterKey)
            .get();

    if (querySnapshot.metadata.isFromCache) {
      throw OfflineException();
    }

    final ChapterModel chapter = ChapterModel.fromJson(
      data: querySnapshot.data() ?? <String, dynamic>{},
    );

    if (chapter.pages.isEmpty) {
      throw ChapterNotFoundException();
    }

    return chapter.pages;
    /*final List<String> pageUrls = <String>[];
    await Future.forEach(chapter.pages, (String page) async {
      final String downloadURL = await getPageUrl(page);
      pageUrls.add(downloadURL);
    });

    return pageUrls;*/
  }
}

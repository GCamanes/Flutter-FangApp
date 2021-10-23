import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/error/exceptions.dart';
import 'package:fangapp/feature/mangas/data/models/manga_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

import 'mangas_remote_data_source.dart';

class MangasRemoteDataSourceImpl implements MangasRemoteDataSource {
  MangasRemoteDataSourceImpl(
    this.sharedPreferences,
  );

  final SharedPreferences sharedPreferences;

  Future<String> getCoverUrl(String partialLink) async {
    try {
      return await firebase_storage.FirebaseStorage.instance
          .ref(partialLink)
          .getDownloadURL();
    } catch (e) {
      return AppConstants.objectNotFoundException;
    }
  }

  @override
  Future<List<MangaModel>> getMangas() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection(AppConstants.firebaseMangasCollection)
            .get();
    if (querySnapshot.metadata.isFromCache) {
      throw OfflineException();
    }
    final List<MangaModel> mangas = querySnapshot.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              MangaModel.fromJson(data: doc.data(), withChapters: true),
        )
        .toList();

    final List<MangaModel> mangasWithCover = <MangaModel>[];
    await Future.forEach(mangas, (MangaModel manga) async {
      final String downloadURL = await getCoverUrl(manga.coverLink);
      final bool isFavorite = sharedPreferences.getBool(manga.key) ?? false;
      mangasWithCover.add(
        MangaModel.fromManga(
          manga: manga,
          coverDownloadedLink: downloadURL,
          isFavorite: isFavorite,
        ),
      );
    });

    return mangasWithCover;
  }
}

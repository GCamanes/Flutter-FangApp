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

  Future<MangaModel> getMangaWithCoverUrl(MangaModel manga) async {
    late String coverUrl;
    try {
      coverUrl = await firebase_storage.FirebaseStorage.instance
          .ref(manga.coverLink)
          .getDownloadURL();
    } catch (e) {
      coverUrl = AppConstants.objectNotFoundException;
    }
    final bool isFavorite = sharedPreferences.getBool(manga.key) ?? false;
    return MangaModel.fromManga(
      manga: manga,
      coverDownloadedLink: coverUrl,
      isFavorite: isFavorite,
    );
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

    return Future.wait(
      mangas.map((MangaModel manga) => getMangaWithCoverUrl(manga)).toList(),
    );
  }
}

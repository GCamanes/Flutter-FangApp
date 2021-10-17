import 'package:fangapp/feature/mangas/data/models/manga_model.dart';

abstract class MangasRemoteDataSource {
  // Get mangas collection from firestore
  Future<List<MangaModel>> getMangas();
}

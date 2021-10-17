import 'package:fangapp/feature/chapters/data/models/light_chapter_model.dart';

abstract class ChaptersRemoteDataSource {
  // Get mangas collection from firestore
  Future<List<LightChapterModel>> getLightChapters({
    required String mangaKey,
  });
}

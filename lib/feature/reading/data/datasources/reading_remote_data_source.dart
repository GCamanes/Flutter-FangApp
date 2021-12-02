abstract class ReadingRemoteDataSource {
  // Get mangas collection from firestore
  Future<List<String>> getPages({
    required String chapterKey,
    required String mangaKey,
  });
}

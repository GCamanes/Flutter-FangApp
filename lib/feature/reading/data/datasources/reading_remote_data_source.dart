abstract class ReadingRemoteDataSource {
  // Get pages of chapter document from firestore
  Future<List<String>> getPages({
    required String chapterKey,
    required String mangaKey,
  });
}

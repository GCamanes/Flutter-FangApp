abstract class ReadingRemoteDataSource {
  // Get mangas collection from firestore
  Future<List<String>> getPageUrls({
    required String chapterKey,
    required String mangaKey,
  });
}

abstract class StorageRemoteDataSource {
  // Get image url from firebase storage
  Future<String> getStorageImageUrl({
    required String url,
  });
}

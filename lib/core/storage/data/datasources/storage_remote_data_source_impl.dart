import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'storage_remote_data_source.dart';

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  @override
  Future<String> getStorageImageUrl({required String url}) {
    return firebase_storage.FirebaseStorage.instance
        .ref(url)
        .getDownloadURL();
  }
}

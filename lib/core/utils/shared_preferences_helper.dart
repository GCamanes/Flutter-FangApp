import 'package:fangapp/core/data/app_constants.dart';

abstract class SharedPreferencesHelper {
  static String getLastReadChapterKey(String? mangaKey) {
    return '${mangaKey ?? ''}_${AppConstants.sharedKeyLastChapterRead}';
  }
}

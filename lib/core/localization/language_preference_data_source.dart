import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

abstract class LanguagePreferenceDataSource {
  /// Gets the cached [String] language preference of the user
  ///
  /// Throws [CacheException] if no cached data is present.
  String getPreferredLanguage();

  Future<bool> cachePreferredLanguage(String language);
}

const String languagePrefCacheKey = 'LANGUAGE_PREF_CACHE_KEY';

class LanguagePreferenceDataSourceImpl implements LanguagePreferenceDataSource {
  LanguagePreferenceDataSourceImpl(
    this.sharedPreferences,
  );

  final SharedPreferences sharedPreferences;

  @override
  String getPreferredLanguage() {
    final String? language = sharedPreferences.getString(languagePrefCacheKey);
    if (language != null) {
      return language;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cachePreferredLanguage(String language) {
    return sharedPreferences.setString(languagePrefCacheKey, language);
  }
}

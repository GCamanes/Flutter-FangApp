import 'dart:async';
import 'dart:convert';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../get_it_injection.dart';
import '../error/exceptions.dart';
import 'language_preference_data_source.dart';

class AppLocalizations {
  AppLocalizations(this.languagePreferenceDataSource);

  late final LanguagePreferenceDataSource languagePreferenceDataSource;

  Locale? _locale;
  late Map<String, String> _localizedStrings;
  final StreamController<String> _localChangedController =
      StreamController<String>.broadcast();

  String get currentLanguage =>
      _locale?.languageCode ?? AppConstants.supportedLanguages.first;

  Stream<String> get localChanged => _localChangedController.stream;

  final LocalizationsDelegate<AppLocalizations> delegate =
      const _AppLocalizationsDelegate();

  Future<bool> load() async {
    final String jsonString = await rootBundle
        .loadString('assets/locales/${_locale!.languageCode}.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    _localizedStrings = jsonMap.map((String key, dynamic value) {
      return MapEntry<String, String>(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  ///
  /// One-time initialization
  ///
  Future<void> init(Locale locale) async {
    //Check if there is a preferred language
    try {
      final String preferredLanguage =
          languagePreferenceDataSource.getPreferredLanguage();
      await setNewLanguage(newLanguage: preferredLanguage);
    } on CacheException {
      //If there is no preferred language, set the one provided
      await setNewLanguage(newLanguage: locale.languageCode);
    }
  }

  ///
  /// Routine to change the language
  ///
  Future<void> setNewLanguage({
    String? newLanguage,
    bool saveInPrefs = true,
  }) async {
    String? language = newLanguage;
    if (language == null) {
      try {
        language = languagePreferenceDataSource.getPreferredLanguage();
      } on CacheException {
        language = AppConstants.supportedLanguages.first;
      }
    }

    // Set the locale
    _locale = Locale(language, '');

    await load();

    // If we are asked to save the new language in the application preferences
    if (saveInPrefs) {
      await languagePreferenceDataSource.cachePreferredLanguage(language);
    }

    // If there is a callback to invoke to notify that a language has changed
    _localChangedController.add(language);
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten
// in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return AppConstants.supportedLanguages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    final AppLocalizations localizations = getIt<AppLocalizations>();
    await localizations.init(locale);
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

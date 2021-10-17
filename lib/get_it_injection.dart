import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/localization/language_preference_data_source.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/feature/chapters/data/datasources/chapters_remote_data_source.dart';
import 'package:fangapp/feature/chapters/data/datasources/chapters_remote_data_source_impl.dart';
import 'package:fangapp/feature/chapters/data/repositories/chapters_repository_impl.dart';
import 'package:fangapp/feature/chapters/domain/repositories/chapters_repository.dart';
import 'package:fangapp/feature/chapters/domain/usecases/get_chapters_use_case.dart';
import 'package:fangapp/feature/login/data/datasources/login_remote_data_source.dart';
import 'package:fangapp/feature/login/data/datasources/login_remote_data_source_impl.dart';
import 'package:fangapp/feature/login/data/repositories/login_repository_impl.dart';
import 'package:fangapp/feature/login/domain/repositories/login_repository.dart';
import 'package:fangapp/feature/login/domain/usecases/get_current_app_user_use_case.dart';
import 'package:fangapp/feature/login/domain/usecases/login_app_user_use_case.dart';
import 'package:fangapp/feature/login/domain/usecases/logout_app_user_use_case.dart';
import 'package:fangapp/feature/mangas/data/datasources/mangas_remote_data_source.dart';
import 'package:fangapp/feature/mangas/data/datasources/mangas_remote_data_source_impl.dart';
import 'package:fangapp/feature/mangas/data/repositories/mangas_repository_impl.dart';
import 'package:fangapp/feature/mangas/domain/repositories/mangas_repository.dart';
import 'package:fangapp/feature/mangas/domain/usecases/get_mangas_use_case.dart';
import 'package:fangapp/feature/reading/data/datasources/reading_remote_data_source.dart';
import 'package:fangapp/feature/reading/data/datasources/reading_remote_data_source_impl.dart';
import 'package:fangapp/feature/reading/data/repositories/reading_repository_impl.dart';
import 'package:fangapp/feature/reading/domain/repositories/reading_repository.dart';
import 'package:fangapp/feature/reading/domain/usecases/get_page_urls_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  // Navigation
  getIt.registerLazySingleton(() => RoutesManager());

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // App localization
  getIt.registerLazySingleton(() => AppLocalizations(getIt()));
  getIt.registerLazySingleton<LanguagePreferenceDataSource>(
    () => LanguagePreferenceDataSourceImpl(getIt()),
  );

  // Features
  _featureLogin();
  _featureMangas();
  _featureChapters();
  _featureChapterReading();
}

void _featureLogin() {
  // Use cases
  getIt.registerLazySingleton(() => GetCurrentAppUser(getIt()));
  getIt.registerLazySingleton(() => LoginAppUser(getIt()));
  getIt.registerLazySingleton(() => LogoutAppUser(getIt()));

  // Repository
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(),
  );
}

void _featureMangas() {
  // Use cases
  getIt.registerLazySingleton(() => GetMangas(getIt()));

  // Repository
  getIt.registerLazySingleton<MangasRepository>(
    () => MangasRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<MangasRemoteDataSource>(
    () => MangasRemoteDataSourceImpl(getIt()),
  );
}

void _featureChapters() {
  // Use cases
  getIt.registerLazySingleton(() => GetChapterTabs(getIt()));

  // Repository
  getIt.registerLazySingleton<ChaptersRepository>(
    () => ChaptersRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<ChaptersRemoteDataSource>(
    () => ChaptersRemoteDataSourceImpl(getIt()),
  );
}

void _featureChapterReading() {
  // Use cases
  getIt.registerLazySingleton(() => GetPageUrls(getIt()));

  // Repository
  getIt.registerLazySingleton<ReadingRepository>(
    () => ReadingRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<ReadingRemoteDataSource>(
    () => ReadingRemoteDataSourceImpl(getIt()),
  );
}

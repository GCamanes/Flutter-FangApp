import 'package:fangapp/core/app_life_cycle/presentation/cubit/app_life_cycle_cubit.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/presentation/cubit/tab_navigation_cubit.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/mangas/presentation/cubit/mangas_cubit.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_localizations.dart';
import 'core/navigation/route_constants.dart';
import 'core/navigation/routes.dart';
import 'core/utils/snack_bar_helper.dart';
import 'feature/login/presentation/cubit/login_cubit.dart';
import 'get_it_injection.dart' as injection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[
      SystemUiOverlay.bottom,
      SystemUiOverlay.top,
    ],
  );

  // Portrait mode
  SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // black for Android
      statusBarBrightness: Brightness.dark, // black for iOS
    ),
  );

  // Initialize firebase
  await Firebase.initializeApp();

  // Initialize GetIt Injection
  await injection.init();

  final MultiBlocProvider _multiBlocProviders = MultiBlocProvider(
    providers: <BlocProvider<dynamic>>[
      BlocProvider<LoginCubit>(
        create: (BuildContext context) => LoginCubit(
          sharedPreferences: getIt(),
          loginAppUser: getIt(),
          getCurrentAppUser: getIt(),
          logoutAppUser: getIt(),
        ),
      ),
      BlocProvider<TabNavigationCubit>(
        create: (BuildContext context) => TabNavigationCubit(),
      ),
      BlocProvider<AppLifeCycleBloc>(
        create: (BuildContext context) => AppLifeCycleBloc(
          sharedPreferences: getIt(),
        ),
      ),
      BlocProvider<MangasCubit>(
        create: (BuildContext context) => MangasCubit(
          sharedPreferences: getIt(),
          getMangas: getIt(),
        ),
      ),
      BlocProvider<ChaptersCubit>(
        create: (BuildContext context) => ChaptersCubit(
          sharedPreferences: getIt(),
          getChapters: getIt(),
        ),
      ),
    ],
    child: MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<LoginCubit, LoginState>(
          listener: (BuildContext context, LoginState state) async {
            if (state is LoginRequired) {
              await RoutesManager.globalNavKey.currentState!
                  .pushNamedAndRemoveUntil(
                RouteConstants.routeLogin,
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        BlocListener<AppLifeCycleBloc, AppLifeCycleState>(
          listener: (BuildContext context, AppLifeCycleState state) async {
            if (state is AppForeground &&
                state.showWelcomeBack &&
                BlocProvider.of<LoginCubit>(context).state is LoginSuccess) {
              Future<void>.delayed(
                1.seconds,
                () => SnackBarHelper.showSnackBar(
                  text: 'common.welcomeBack'.translate(),
                ),
              );
            }
          },
        )
      ],
      child: const FangApp(),
    ),
  );

  runApp(_multiBlocProviders);
}

class FangApp extends StatefulWidget {
  const FangApp({Key? key}) : super(key: key);

  @override
  _FangAppState createState() => _FangAppState();
}

class _FangAppState extends State<FangApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    // Initializes a callback should something need
    // to be done when the language is changed
    injection.getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    BlocProvider.of<LoginCubit>(context).close();
    BlocProvider.of<TabNavigationCubit>(context).close();
    BlocProvider.of<AppLifeCycleBloc>(context).close();
    BlocProvider.of<MangasCubit>(context).close();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      BlocProvider.of<AppLifeCycleBloc>(context).appEntersBackground();
    }

    //app goes foreground
    else if (state == AppLifecycleState.resumed) {
      BlocProvider.of<AppLifeCycleBloc>(context).appEntersForeground();
    }
  }

  Future<void> _onLocaleChanged(_) async {
    // do anything you need to do if the language changes
    // empty setState to rebuild (to show new language)
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FangApp',
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        // A class which loads the translations from JSON files
        injection.getIt<AppLocalizations>().delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        // Cupertino
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLocales,
      // Returns a locale which will be used by the app
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        //For some unknown reason, sometimes on iOS local is null,
        // but it updates a few milliseconds later
        if (locale == null) {
          return supportedLocales.first;
        }

        // Check if the current device locale is supported
        for (final Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (French, in this case).
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.orange,
      ),
      navigatorKey: RoutesManager.globalNavKey,
      initialRoute: RouteConstants.routeInitial,
      onGenerateRoute: (RouteSettings routeSettings) =>
          generateRoutes(context: context, routeSettings: routeSettings),
      onUnknownRoute: (RouteSettings routeSettings) =>
          resolveRoutes(context: context, routeSettings: routeSettings),
    );
  }
}

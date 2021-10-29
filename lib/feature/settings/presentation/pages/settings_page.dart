import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/version_widget.dart';
import 'package:fangapp/feature/settings/presentation/widgets/language_selector_widget.dart';
import 'package:fangapp/feature/settings/presentation/widgets/logout_widget.dart';
import 'package:fangapp/feature/settings/presentation/widgets/tracking_widget.dart';
import 'package:flutter/material.dart';

import '../../../../get_it_injection.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _currentLanguage;

  @override
  void initState() {
    _currentLanguage = getIt<AppLocalizations>().currentLanguage;

    getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
    super.initState();
  }

  Future<void> _onLocaleChanged(String language) async {
    setState(() {
      _currentLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'bottomBar.settings'.translate(),
        isInitialPage: true,
      ),
      body: SizedBox(
        width: AppHelper().deviceSize.width,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/one_piece_skull_fangapp_themed.png',
              height: AppHelper().deviceSize.height / 7,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  LanguageSelectorWidget(
                    selectedLanguage: _currentLanguage,
                  ),
                  TrackingWidget(key: UniqueKey()),
                  const LogoutWidget(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: VersionWidget(textColor: AppColors.blackSmokeDark),
            ),
          ],
        ),
      ),
    );
  }
}

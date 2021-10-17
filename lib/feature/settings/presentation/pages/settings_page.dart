import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/interaction_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/icon_button_widget.dart';
import 'package:fangapp/core/widget/version_widget.dart';
import 'package:fangapp/feature/login/presentation/cubit/login_cubit.dart';
import 'package:fangapp/feature/settings/presentation/widgets/language_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../get_it_injection.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late LoginCubit _loginCubit;
  late String _currentLanguage;

  @override
  void initState() {
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _currentLanguage = getIt<AppLocalizations>().currentLanguage;

    getIt<AppLocalizations>().localChanged.listen(_onLocaleChanged);
    super.initState();
  }

  Future<void> _onLocaleChanged(String language) async {
    setState(() {
      _currentLanguage = language;
    });
  }

  Future<void> _logout() async {
    final bool needToLogout = await InteractionHelper.showModal(
          text: 'settings.logoutConfirm'.translate(),
          isDismissible: true,
        ) ?? false;
    if (needToLogout) {
      _loginCubit.logoutUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'bottomBar.settings'.translate(),
        isInitialPage: true,
      ),
      body: SizedBox(
        width: size.width,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image.asset(
              'assets/images/one_piece_skull_fangapp_themed.png',
              height: size.height / 7,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  LanguageSelectorWidget(
                    selectedLanguage: _currentLanguage,
                  ),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (BuildContext context, LoginState state) {
                      if (state is LoginSuccess) {
                        return Column(
                          children: <Widget>[
                            Text(
                              state.user.email,
                              style: AppStyles.mediumTitle(
                                context,
                                color: AppColors.blackSmokeDark,
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppIconButtonWidget(
                              icon: Icons.logout,
                              size: 40,
                              onPress: () => _logout(),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
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

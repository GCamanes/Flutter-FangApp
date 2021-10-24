import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({
    Key? key,
    required this.selectedLanguage,
  }) : super(key: key);

  final String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            child: Text(
              'language.selected'.translate(),
              style: AppStyles.mediumTitle(color: AppColors.blackSmokeDark),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: AppConstants.supportedLanguages
                .map(
                  (String language) => LanguageButton(
                    language: language,
                    selectedLanguage: selectedLanguage,
                    width: AppHelper().deviceSize.width * 0.35,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    Key? key,
    required this.language,
    required this.selectedLanguage,
    required this.width,
  }) : super(key: key);

  final String language;
  final String selectedLanguage;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AppButtonWidget(
      onPressed: () {
        getIt<AppLocalizations>().setNewLanguage(newLanguage: language);
      },
      text: 'language.$language'.translate(),
      color: selectedLanguage == language
          ? AppColors.orange
          : AppColors.greyMiddle,
      minimumWidth: width,
    );
  }
}

import 'package:fangapp/core/localization/app_localizations.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:sprintf/sprintf.dart';

extension TranslateExtension on String {
  String translate() {
    return getIt<AppLocalizations>().translate(this);
  }

  String translateWithArgs({List<String>? args}) {
    return sprintf(
      getIt<AppLocalizations>().translate(this),
      args,
    );
  }
}

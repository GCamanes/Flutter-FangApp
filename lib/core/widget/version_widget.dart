import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/version_helper.dart';
import 'package:flutter/material.dart';

class VersionWidget extends StatelessWidget {
  const VersionWidget({
    Key? key,
    this.textColor = AppColors.white,
  }) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: VersionHelper.getAppVersion(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data ?? '',
            style: AppStyles.mediumTitle(color: textColor, size: 12),
            textAlign: TextAlign.center,
          );
        }
        return const SizedBox();
      },
    );
  }
}

import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarWidget(),
      body: Center(
        child: Text(
          'page.notFound'.translate(),
          style: AppStyles.highTitle(context),
        ),
      ),
    );
  }
}

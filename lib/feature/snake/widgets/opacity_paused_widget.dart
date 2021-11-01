import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class OpacityPausedWidget extends StatelessWidget {
  const OpacityPausedWidget({
    Key? key,
    this.opacity = 0.5,
    this.topPadding = 0,
  }) : super(key: key);

  final double opacity;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: Opacity(
              opacity: opacity,
              child: Container(
                color: AppColors.black90,
              ),
            ),
          ),
          Center(
            child: Text(
              'common.paused'.translate(),
              style: AppStyles.highTitle(color: AppColors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

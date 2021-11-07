import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

import 'bordered_container_widget.dart';

const double borderLength = 30;
const double borderWidth = 3;

class TapTutorialWidget extends StatelessWidget {
  const TapTutorialWidget({
    Key? key,
    this.text = 'test tutorial',
    this.innerPadding = 0,
  }) : super(key: key);

  final String text;
  final double innerPadding;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(innerPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                BorderedContainerWidget(
                  height: borderLength,
                  width: borderLength,
                  borderColor: AppColors.white,
                  borderWidth: borderWidth,
                  leftBorder: true,
                  topBorder: true,
                ),
                BorderedContainerWidget(
                  height: borderLength,
                  width: borderLength,
                  borderColor: AppColors.white,
                  borderWidth: borderWidth,
                  rightBorder: true,
                  topBorder: true,
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            child: Center(
              child: Text(
                text,
                style: AppStyles.mediumTitle(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(innerPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                BorderedContainerWidget(
                  height: borderLength,
                  width: borderLength,
                  borderColor: AppColors.white,
                  borderWidth: borderWidth,
                  bottomBorder: true,
                  leftBorder: true,
                ),
                BorderedContainerWidget(
                  height: borderLength,
                  width: borderLength,
                  borderColor: AppColors.white,
                  borderWidth: borderWidth,
                  bottomBorder: true,
                  rightBorder: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

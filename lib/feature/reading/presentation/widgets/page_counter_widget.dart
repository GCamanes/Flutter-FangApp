import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class PageCounterWidget extends StatelessWidget {
  const PageCounterWidget({
    Key? key,
    required this.currentPage,
    required this.numberOfPage,
  }) : super(key: key);

  final int currentPage;
  final int numberOfPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            currentPage.toString(),
            style: AppStyles.mediumTitle(color: AppColors.white, size: 12),
            textAlign: TextAlign.end,
          ),
          Text(
            ' / ',
            style: AppStyles.mediumTitle(color: AppColors.blueLight, size: 11),
          ),
          Text(
            numberOfPage.toString(),
            style: AppStyles.mediumTitle(color: AppColors.white, size: 12),
          ),
        ],
      ),
    );
  }
}

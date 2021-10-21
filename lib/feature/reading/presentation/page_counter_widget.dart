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
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: size.width / (numberOfPage > 100 ? 5.5 : 7.5),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  currentPage.toString(),
                  style: AppStyles.mediumTitle(
                    context,
                    color: AppColors.white,
                    size: 12,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Text(
                ' / ',
                style: AppStyles.mediumTitle(
                  context,
                  color: AppColors.blueLight,
                  size: 11,
                ),
              ),
              Text(
                numberOfPage.toString(),
                style: AppStyles.mediumTitle(
                  context,
                  color: AppColors.white,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

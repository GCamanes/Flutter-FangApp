import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';

class SnakeScoreWidget extends StatefulWidget {
  const SnakeScoreWidget({Key? key}) : super(key: key);

  @override
  _SnakeScoreWidgetState createState() => _SnakeScoreWidgetState();
}

class _SnakeScoreWidgetState extends State<SnakeScoreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: AppColors.black90,
      child: Align(
        child: Text(
          'Score',
          style: AppStyles.mediumTitle(color: AppColors.white),
        ),
      ),
    );
  }
}

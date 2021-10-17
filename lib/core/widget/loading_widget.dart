import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.size = 25,
    this.strokeWidth = 3,
    this.color = AppColors.orange,
  }) : super(key: key);

  final double size;
  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

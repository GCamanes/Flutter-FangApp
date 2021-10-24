import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    Key? key,
    this.onPressed,
    this.onLongPressed,
    this.color = AppColors.orange,
    this.borderColor,
    this.borderRadius = 20,
    this.minimumWidth = 0,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 5,
    ),
    required this.text,
    this.textColor = AppColors.white,
    this.textSize = 14,
  }) : super(key: key);

  final Function()? onPressed;
  final Function()? onLongPressed;
  final Color color;
  final Color? borderColor;
  final double borderRadius;
  final double minimumWidth;
  final EdgeInsets padding;
  final String text;
  final Color textColor;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        primary: color,
        onPrimary: textColor,
        elevation: 1,
        shadowColor: Colors.transparent,
        onSurface: color,
        minimumSize: Size(minimumWidth, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
      ),
      onPressed: onPressed,
      onLongPress: onLongPressed,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.mediumTitle(
          size: textSize,
          color: textColor,
        ),
      ),
    );
  }
}

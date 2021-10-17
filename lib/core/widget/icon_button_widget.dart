import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppIconButtonWidget extends StatelessWidget {
  const AppIconButtonWidget({
    Key? key,
    this.icon = Icons.close,
    this.onPress,
    this.color = AppColors.blackSmoke,
    this.size = 30,
  }) : super(key: key);

  final IconData icon;
  final Function()? onPress;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width *
        (size / AppConstants.uiModelWidth);
    return IconButton(
      onPressed: onPress,
      iconSize: iconSize,
      splashRadius: iconSize * 0.65,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: color.withOpacity(0.2),
      icon: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}

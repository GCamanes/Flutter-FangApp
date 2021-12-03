import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:flutter/material.dart';

class AppIconButtonWidget extends StatelessWidget {
  const AppIconButtonWidget({
    Key? key,
    this.icon = Icons.close,
    this.onPress,
    this.color = AppColors.blackSmoke,
    this.size = 30,
    this.buttonMinSize = 38,
  }) : super(key: key);

  final IconData icon;
  final Function()? onPress;
  final Color color;
  final double size;
  final double buttonMinSize;

  @override
  Widget build(BuildContext context) {
    final double iconSize =
        AppHelper().deviceSize.width * (size / AppConstants.uiModelWidth);
    final double minSize = AppHelper().deviceSize.width *
        (buttonMinSize / AppConstants.uiModelWidth);
    return IconButton(
      onPressed: onPress,
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
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

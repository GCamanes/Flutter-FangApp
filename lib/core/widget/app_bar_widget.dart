import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// application bar
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    Key? key,
    this.title = '',
    this.subTitle = '',
    this.titleWidget,
    this.centerTitle = false,
    this.onBackPressed,
    this.isInitialPage = false,
    this.actionsList = const <Widget>[],
    this.iconButton = Icons.arrow_back_ios_new_outlined,
    this.bottom,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Widget? titleWidget;
  final bool centerTitle;
  final Function()? onBackPressed;
  final bool isInitialPage;
  final List<Widget> actionsList;
  final IconData? iconButton;
  final PreferredSizeWidget? bottom;

  static const double appBarHeight = 56.0;
  static const double appBarRightMargin = 14.5;

  @override
  Size get preferredSize {
    return Size.fromHeight(
      appBarHeight + (bottom?.preferredSize.height ?? 0) * 1.6,
    );
  }

  Function()? _onBackPressed(BuildContext context) {
    if (isInitialPage) {
      return null;
    } else if (onBackPressed != null) {
      return onBackPressed;
    }
    return () => Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),

      // status bar brightness
      automaticallyImplyLeading: false,
      leading: iconButton != null && !isInitialPage
          ? IconButton(
              icon: Icon(iconButton, color: AppColors.blueLight),
              iconSize: 30,
              onPressed: _onBackPressed(context),
            )
          : null,
      centerTitle: centerTitle,
      elevation: 5,
      titleSpacing: isInitialPage ? 25 : 0,
      title: titleWidget ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: subTitle.isNotEmpty ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.mediumTitle(
                  context,
                  color: AppColors.white,
                ),
              ),
              if (subTitle.isNotEmpty) Text(
                subTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.regularText(
                  context,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
      backgroundColor: AppColors.black90,
      actions: <Widget>[
        ...actionsList,
        const SizedBox(width: 10),
      ],
      bottom: bottom,
    );
  }
}

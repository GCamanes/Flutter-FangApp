import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'app_icon_button_widget.dart';

class TabBarButtonWidget extends StatelessWidget {
  const TabBarButtonWidget({
    Key? key,
    this.isLeft = true,
    this.enabled = true,
    required this.tabController,
  }) : super(key: key);

  final bool isLeft;
  final bool enabled;
  final TabController tabController;

  void _onPress() {
    tabController.animateTo(
      isLeft ? 0 : tabController.length - 1,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppIconButtonWidget(
      color: enabled ? AppColors.white : AppColors.grey,
      icon: isLeft ? Icons.first_page_outlined : Icons.last_page_outlined,
      onPress: enabled ? _onPress : null,
      size: 25,
    );
  }
}

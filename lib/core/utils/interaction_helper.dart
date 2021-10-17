import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/interaction_modal_widget.dart';
import 'package:flutter/material.dart';

abstract class InteractionHelper {
  static Future<bool?> showModal({
    required String text,
    bool needChoice = true,
    bool isDismissible = false,
  }) {
    return showModalBottomSheet(
      isDismissible: isDismissible,
      enableDrag: false,
      backgroundColor: AppColors.blackSmoke,
      context: RoutesManager.globalNavKey.currentContext!,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return InteractionModalWidget(
          text: text,
          needChoice: needChoice,
        );
      },
    );
  }
}

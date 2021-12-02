import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/app_icon_button_widget.dart';
import 'package:flutter/material.dart';

class ReadingButtonWidget extends StatelessWidget {
  const ReadingButtonWidget({
    Key? key,
    this.onPressed,
    this.isForward = true,
    this.show = true,
  }) : super(key: key);

  final Function()? onPressed;
  final bool isForward;
  final bool show;

  @override
  Widget build(BuildContext context) {
    final double offset =
        AppHelper().deviceSize.width * (25 / AppConstants.uiModelWidth);
    return AnimatedContainer(
      duration: AppConstants.animLoginCloudDuration,
      transform: Transform.translate(
        offset: Offset(
          show
              ? 0
              : isForward
                  ? offset
                  : -offset,
          show ? 0 : -offset,
        ),
      ).transform,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.black90,
          borderRadius: isForward
              ? const BorderRadius.only(bottomLeft: Radius.circular(20))
              : const BorderRadius.only(bottomRight: Radius.circular(20)),
        ),
        child: AppIconButtonWidget(
          icon: isForward
              ? Icons.fast_forward_outlined
              : Icons.fast_rewind_outlined,
          size: 15,
          buttonMinSize: 0,
          color: AppColors.white,
          onPress: onPressed,
        ),
      ),
    );
  }
}

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class TileButtonWidget extends StatelessWidget {
  const TileButtonWidget({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        primary: AppColors.greyLight,
        elevation: 1,
        shadowColor: Colors.transparent,
        onSurface: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          //side: const BorderSide(color: AppColors.blueLight),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.arrow_forward_ios_outlined,
            color: AppColors.blueLight,
            size: 20,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.mediumTitle(),
            ),
          )
        ],
      ),
    );
  }
}

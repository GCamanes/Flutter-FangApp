import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/app_luffy_error.png',
          width: size.width * 0.6,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            message,
            style: AppStyles.mediumTitle(color: AppColors.blackSmoke),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

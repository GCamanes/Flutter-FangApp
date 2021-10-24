import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:flutter/material.dart';

class InteractionModalWidget extends StatelessWidget {
  const InteractionModalWidget({
    Key? key,
    required this.text,
    this.needChoice = true,
  }) : super(key: key);

  final String text;
  final bool needChoice;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Align(
                    child: Text(
                      text,
                      style: AppStyles.mediumTitle(color: AppColors.blueLight),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _InteractionChoiceWidget(
                  needChoice: needChoice,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionChoiceWidget extends StatelessWidget {
  const _InteractionChoiceWidget({
    Key? key,
    required this.needChoice,
  }) : super(key: key);

  final bool needChoice;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (needChoice) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          AppButtonWidget(
            text: 'common.no'.translate(),
            minimumWidth: size.width / 4,
            color: AppColors.greyLight,
            borderColor: AppColors.orange,
            textColor: AppColors.blackSmoke,
            onPressed: () {
              //close current page and Return False
              Navigator.pop(context, false);
            },
          ),
          AppButtonWidget(
            text: 'common.yes'.translate(),
            minimumWidth: size.width / 4,
            color: AppColors.greyLight,
            borderColor: AppColors.blueLight,
            textColor: AppColors.blackSmoke,
            onPressed: () {
              //close current page and return True
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    }
    return Align(
      child: AppButtonWidget(
        text: 'common.ok'.translate(),
        minimumWidth: size.width / 4,
        color: AppColors.greyLight,
        borderColor: AppColors.orange,
        textColor: AppColors.blackSmoke,
        onPressed: () {
          //close current page and return True
          Navigator.pop(context, true);
        },
      ),
    );
  }
}

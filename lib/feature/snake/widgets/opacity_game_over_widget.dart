import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:flutter/material.dart';

class OpacityGameOverWidget extends StatelessWidget {
  const OpacityGameOverWidget({
    Key? key,
    this.opacity = 0.5,
    required this.onRestart,
    this.topPadding = 0,
    this.boardHeight = double.infinity,
    this.playerScore = 0,
    this.playerBestScore = 0,
  }) : super(key: key);

  final double opacity;
  final Function() onRestart;
  final double topPadding;
  final double boardHeight;
  final int playerScore;
  final int playerBestScore;

  bool get isNewBestScore => playerScore > 0 && playerScore > playerBestScore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: boardHeight,
            child: Opacity(
              opacity: opacity,
              child: Container(
                color: AppColors.black90,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'common.gameOver'.translate(),
                    style: AppStyles.highTitle(color: AppColors.orange),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'common.playerScore'.translateWithArgs(
                      args: <String>[playerScore.toString()],
                    ),
                    style: AppStyles.highTitle(size: 15),
                  ),
                  Text(
                    isNewBestScore
                        ? 'common.newBestScore'.translate()
                        : 'common.bestScore'.translateWithArgs(
                            args: <String>[playerBestScore.toString()],
                          ),
                    style: AppStyles.highTitle(
                      size: 15,
                      color: isNewBestScore ? AppColors.red : AppColors.black90,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppButtonWidget(
                    text: 'common.restart'.translate(),
                    onPressed: onRestart,
                  ),
                  AppButtonWidget(
                    text: 'common.closeGame'.translate(),
                    color: AppColors.grey,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

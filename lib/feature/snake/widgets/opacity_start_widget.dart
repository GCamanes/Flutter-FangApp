import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:fangapp/feature/snake/entities/game_board_entity.dart';
import 'package:fangapp/feature/snake/widgets/tap_tutorial_widget.dart';
import 'package:flutter/material.dart';

class OpacityStartWidget extends StatelessWidget {
  const OpacityStartWidget({
    Key? key,
    this.opacity = 0.5,
    required this.onStart,
    this.topPadding = 0,
    this.boardHeight = double.infinity,
    this.gameBoardEntity,
  }) : super(key: key);

  final double opacity;
  final Function() onStart;
  final double topPadding;
  final double boardHeight;
  final GameBoardEntity? gameBoardEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: Opacity(
              opacity: opacity,
              child: Container(
                color: AppColors.black90,
              ),
            ),
          ),
          SizedBox(
            height: boardHeight,
            child: Row(
              children: <Widget>[
                TapTutorialWidget(
                  text: 'snake.tutorialLeft'.translate(),
                  innerPadding: AppHelper().snakeBoxSize,
                ),
                TapTutorialWidget(
                  text: 'snake.tutorialRight'.translate(),
                  innerPadding: AppHelper().snakeBoxSize,
                ),
              ],
            ),
          ),
          Center(
            child: AppButtonWidget(
              text: 'common.start'.translate(),
              onPressed: () {
                gameBoardEntity?.initSnakeGame();
                onStart();
              },
            ),
          ),
        ],
      ),
    );
  }
}

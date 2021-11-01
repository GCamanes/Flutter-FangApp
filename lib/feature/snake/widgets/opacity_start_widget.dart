import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
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
    this.gameBoardEntity,
  }) : super(key: key);

  final double opacity;
  final Function() onStart;
  final double topPadding;
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
            height: gameBoardEntity?.boardSize ?? double.infinity,
            child: Row(
              children: <Widget>[
                TapTutorialWidget(
                  text: 'snake.tutorialLeft'.translate(),
                  innerPadding: gameBoardEntity?.boxSize ?? 0,
                ),
                TapTutorialWidget(
                  text: 'snake.tutorialRight'.translate(),
                  innerPadding: gameBoardEntity?.boxSize ?? 0,
                ),
              ],
            ),
          ),
          Center(
            child: AppButtonWidget(
              text: 'common.start'.translate(),
              onPressed: onStart,
            ),
          ),
        ],
      ),
    );
  }
}

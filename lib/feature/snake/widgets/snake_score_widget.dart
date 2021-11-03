import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnakeScoreWidget extends StatefulWidget {
  const SnakeScoreWidget({
    Key? key,
    required this.playerScore,
    required this.updateSpeed,
  }) : super(key: key);

  final int playerScore;
  final Function(int) updateSpeed;

  @override
  _SnakeScoreWidgetState createState() => _SnakeScoreWidgetState();
}

class _SnakeScoreWidgetState extends State<SnakeScoreWidget> {
  Color _backgroundColor = AppColors.greyLight;
  Color _progressBarColor = AppColors.blueLight;

  @override
  void didUpdateWidget(covariant SnakeScoreWidget oldWidget) {
    if (oldWidget.playerScore != widget.playerScore) {
      if (widget.playerScore > 0 &&
          widget.playerScore % AppConstants.snakePointPerLevel == 0) {
        setState(() {
          _backgroundColor = _progressBarColor;
          _progressBarColor = _progressBarColor == AppColors.blueLight
              ? AppColors.orange
              : AppColors.blueLight;
        });
        widget.updateSpeed(
          widget.playerScore ~/ AppConstants.snakePointPerLevel,
        );
      } else if (widget.playerScore == 0){
        setState(() {
          _backgroundColor = AppColors.greyLight;
          _progressBarColor = AppColors.blueLight;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  double _getScoreInPercentage() {
    final int level = widget.playerScore ~/ AppConstants.snakePointPerLevel;
    return (widget.playerScore - level * AppConstants.snakePointPerLevel) /
        AppConstants.snakePointPerLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      color: AppColors.black90,
      child: Column(
        children: <Widget>[
          Align(
            child: Text(
              'common.playerScore'.translateWithArgs(
                args: <String>[widget.playerScore.toString()],
              ),
              style: AppStyles.highTitle(size: 15, color: AppColors.white),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: _backgroundColor,
            width: AppHelper().deviceSize.width,
            height: 4,
            child: LinearProgressIndicator(
              backgroundColor: _backgroundColor,
              color: _progressBarColor,
              value: _getScoreInPercentage(),
            ),
          ),
        ],
      ),
    );
  }
}

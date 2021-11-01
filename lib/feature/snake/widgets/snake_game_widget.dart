import 'dart:async';

import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/size_aware_widget.dart';
import 'package:fangapp/feature/snake/entities/game_board_entity.dart';
import 'package:fangapp/feature/snake/snake_painter.dart';
import 'package:fangapp/feature/snake/widgets/opacity_start_widget.dart';
import 'package:fangapp/feature/snake/widgets/snake_score_widget.dart';
import 'package:flutter/cupertino.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({Key? key}) : super(key: key);

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  Size _scoreSize = Size.zero;
  Size _boardSize = Size.zero;
  GameBoardEntity? _gameBoardEntity;

  bool gameStarted = false;

  Timer? _snakeTimer;

  DirectionEnum _direction = DirectionEnum.up;
  bool _enableTap = true;

  @override
  void dispose() {
    _snakeTimer?.cancel();
    super.dispose();
  }

  void _initSnakeBoardSize({
    required Size scoreSize,
    required Size boardSize,
  }) {
    setState(() {
      _scoreSize = scoreSize;
      _boardSize = boardSize;
      _gameBoardEntity = GameBoardEntity(
        gameBoardSize: boardSize,
        initWithWall: true,
      );
    });
  }

  void _starGameTimer() {
    setState(() {
      gameStarted = true;
    });
    _snakeTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer timer) {
        _gameBoardEntity!.computeNextMatrix(_direction);
        _enableTap = true;
        setState(() {});
      },
    );
  }

  void _handleTapEvent(double dx) {
    _enableTap = false;
    final bool isTapLeft = dx < _boardSize.width / 2;
    DirectionEnum newDirection = _direction;
    switch (_direction) {
      case DirectionEnum.up:
        newDirection = isTapLeft ? DirectionEnum.left : DirectionEnum.right;
        break;
      case DirectionEnum.left:
        newDirection = isTapLeft ? DirectionEnum.down : DirectionEnum.up;
        break;
      case DirectionEnum.right:
        newDirection = isTapLeft ? DirectionEnum.up : DirectionEnum.down;
        break;
      default:
        newDirection = isTapLeft ? DirectionEnum.right : DirectionEnum.left;
        break;
    }
    _direction = newDirection;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: <Widget>[
                  SizeAwareWidget(
                    onChange: (Size size) => _initSnakeBoardSize(
                      scoreSize: size,
                      boardSize: Size(
                        constraints.maxWidth,
                        constraints.maxHeight - size.height,
                      ),
                    ),
                    child: const SnakeScoreWidget(),
                  ),
                  GestureDetector(
                    onTapUp: (TapUpDetails? onTapUp) {
                      if (onTapUp != null && _enableTap) {
                        _handleTapEvent(onTapUp.localPosition.dx);
                      }
                    },
                    child: Container(
                      height: _boardSize.height,
                      width: _boardSize.width,
                      color: AppColors.greyLight,
                      child: CustomPaint(
                        painter: (_gameBoardEntity != null)
                            ? SnakePainter(
                          gameBoardEntity: _gameBoardEntity!,
                        )
                            : null,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (!gameStarted) OpacityStartWidget(
            topPadding: _scoreSize.height,
            gameBoardEntity: _gameBoardEntity,
            onStart: _starGameTimer,
          ),
        ],
      ),
    );
  }
}

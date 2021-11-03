import 'dart:async';

import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/enum/game_status_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/size_aware_widget.dart';
import 'package:fangapp/feature/bonus/presentation/pages/bonus_snake_page.dart';
import 'package:fangapp/feature/snake/entities/game_board_entity.dart';
import 'package:fangapp/feature/snake/snake_painter.dart';
import 'package:fangapp/feature/snake/widgets/opacity_paused_widget.dart';
import 'package:fangapp/feature/snake/widgets/opacity_start_widget.dart';
import 'package:fangapp/feature/snake/widgets/opacity_starting_widget.dart';
import 'package:fangapp/feature/snake/widgets/snake_score_widget.dart';
import 'package:flutter/cupertino.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({
    Key? key,
    required this.gameNotifier,
    required this.gameBoardNotifier,
  }) : super(key: key);

  final GameNotifier gameNotifier;
  final GameBoardNotifier gameBoardNotifier;

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  Size _scoreSize = Size.zero;
  Size _boardSize = Size.zero;
  GameBoardEntity? _gameBoardEntity;

  GameStatusEnum _gameStatus = GameStatusEnum.notStarted;

  Timer? _snakeTimer;

  DirectionEnum _direction = DirectionEnum.up;
  bool _enableTap = false;

  @override
  void initState() {
    super.initState();
    widget.gameBoardNotifier.addListener(() {
      if (widget.gameBoardNotifier.nextStatus == GameStatusEnum.starting) {
        _resumeGame();
      } else if (widget.gameBoardNotifier.nextStatus == GameStatusEnum.paused) {
        _pauseGame();
      }
    });
  }

  @override
  void dispose() {
    _snakeTimer?.cancel();
    super.dispose();
  }

  void _handleEnteringGameOver() {
    _enableTap = false;
    setState(() {
      _gameStatus = GameStatusEnum.enteringGameOver;
    });
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _handleGameOver() {
    _snakeTimer?.cancel();
    setState(() {
      _gameStatus = GameStatusEnum.gameOver;
    });
    widget.gameNotifier.updateGameStatus(_gameStatus);
    print('Game Over');
  }

  void _handleScoreUpdate() {
    print('Score up !');
  }

  void _initBoardSize({
    required Size scoreSize,
    required Size boardSize,
  }) {
    setState(() {
      _scoreSize = scoreSize;
      _gameBoardEntity = GameBoardEntity(
        gameBoardSize: boardSize,
        handleSnakeDead: _handleGameOver,
        handleSnakeEatFruit: _handleScoreUpdate,
        handleSnakeDying: _handleEnteringGameOver,
      );
      _boardSize = Size(
        AppHelper().deviceSize.width,
        _gameBoardEntity!.boardSize,
      );
    });
  }

  void _resumeGame({bool initSnake = false}) {
    setState(() {
      _gameStatus = GameStatusEnum.starting;
    });
    if (initSnake) _gameBoardEntity?.initSnakeGame();
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _startGame() {
    setState(() {
      _gameStatus = GameStatusEnum.started;
    });
    _snakeTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (Timer timer) {
        _gameBoardEntity!.computeNextMatrix(_direction);
        _enableTap = true;
        setState(() {});
      },
    );
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _pauseGame() {
    setState(() {
      _enableTap = false;
      _gameStatus = GameStatusEnum.paused;
    });
    _snakeTimer?.cancel();
    widget.gameNotifier.updateGameStatus(_gameStatus);
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
                    onChange: (Size size) => _initBoardSize(
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
          if (_gameStatus == GameStatusEnum.notStarted)
            OpacityStartWidget(
              topPadding: _scoreSize.height,
              boardHeight: _boardSize.height,
              onStart: () => _resumeGame(initSnake: true),
            ),
          if (_gameStatus == GameStatusEnum.starting)
            OpacityStartingWidget(
              topPadding: _scoreSize.height,
              onCountDownEnd: _startGame,
            ),
          if (_gameStatus == GameStatusEnum.paused)
            OpacityPausedWidget(
              topPadding: _scoreSize.height,
            ),
        ],
      ),
    );
  }
}

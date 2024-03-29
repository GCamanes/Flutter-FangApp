import 'dart:async';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/enum/game_status_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/widget/size_aware_widget.dart';
import 'package:fangapp/feature/bonus/presentation/pages/bonus_snake_page.dart';
import 'package:fangapp/feature/snake/entities/game_board_entity.dart';
import 'package:fangapp/feature/snake/snake_painter.dart';
import 'package:fangapp/feature/snake/widgets/opacity_game_over_widget.dart';
import 'package:fangapp/feature/snake/widgets/opacity_paused_widget.dart';
import 'package:fangapp/feature/snake/widgets/opacity_start_widget.dart';
import 'package:fangapp/feature/snake/widgets/opacity_starting_widget.dart';
import 'package:fangapp/feature/snake/widgets/snake_score_widget.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({
    Key? key,
    required this.gameNotifier,
    required this.gameBoardNotifier,
    required this.snackImageInfo,
    required this.poisonImageInfo,
    required this.wallImageInfo,
    required this.deadImageInfo,
    required this.snakeHeadImageInfo,
    required this.snakeHeadEatingImageInfo,
    required this.snakeBodyStraightImageInfo,
    required this.snakeBodyAngleLeftImageInfo,
    required this.snakeBodyAngleRightImageInfo,
    required this.snakeTailImageInfo,
  }) : super(key: key);

  final GameNotifier gameNotifier;
  final GameBoardNotifier gameBoardNotifier;
  final ImageInfo snackImageInfo;
  final ImageInfo poisonImageInfo;
  final ImageInfo wallImageInfo;
  final ImageInfo deadImageInfo;
  final ImageInfo snakeHeadImageInfo;
  final ImageInfo snakeHeadEatingImageInfo;
  final ImageInfo snakeBodyStraightImageInfo;
  final ImageInfo snakeBodyAngleLeftImageInfo;
  final ImageInfo snakeBodyAngleRightImageInfo;
  final ImageInfo snakeTailImageInfo;

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  Size _scoreSize = Size.zero;
  Size _boardSize = Size.zero;
  GameBoardEntity? _gameBoardEntity;

  // Used to handle game status
  GameStatusEnum _gameStatus = GameStatusEnum.notStarted;

  // Used to move and draw snake game
  Timer? _snakeTimer;
  int _snakeSpeed = AppConstants.snakeBaseSpeed;
  DirectionEnum _direction = DirectionEnum.up;
  bool _enableTap = false;

  // Score values
  int _playerScore = 0;
  int _playerBestScore = 0;

  @override
  void initState() {
    super.initState();
    // Retrieve updated best player score
    _playerBestScore = getIt<SharedPreferences>()
            .getInt(AppConstants.sharedKeySnakeBestScore) ??
        0;
    // Listener to handle play and pause button pressed
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
    setState(() {
      _enableTap = false;
      _gameStatus = GameStatusEnum.enteringGameOver;
    });
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  Future<void> _handleGameOver() async {
    if (_playerScore > _playerBestScore) {
      await getIt<SharedPreferences>()
          .setInt(AppConstants.sharedKeySnakeBestScore, _playerScore);
    }
    _snakeTimer?.cancel();
    setState(() {
      _gameStatus = GameStatusEnum.gameOver;
    });
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _handleScoreUpdate() {
    setState(() {
      _playerScore += AppConstants.snakePointPerSnack;
    });
  }

  void _updateSpeedWithScoreLevel(int level) {
    // Update speed according to level
    _snakeSpeed = AppConstants.snakeBaseSpeed -
        (level *
                AppConstants.snakeSpeedIncreasePerLevel *
                AppConstants.snakeBaseSpeed)
            .toInt();
    // Limit maximum speed
    if (_snakeSpeed < AppConstants.snakeMinSpeed) {
      _snakeSpeed = AppConstants.snakeMinSpeed;
    }
    // Update timer
    _snakeTimer?.cancel();
    _snakeTimer = Timer.periodic(
      Duration(milliseconds: _snakeSpeed),
      (Timer timer) {
        _gameBoardEntity!.computeNextMatrix(_direction);
        setState(() {
          _enableTap = _gameStatus == GameStatusEnum.started;
        });
      },
    );
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
        handleSnakeEatSnack: _handleScoreUpdate,
        handleSnakeDying: _handleEnteringGameOver,
      );
      _boardSize = Size(
        AppHelper().deviceSize.width,
        _gameBoardEntity!.boardSize,
      );
    });
  }

  void _initGame({bool restart = false}) {
    setState(() {
      _direction = DirectionEnum.up;
      _gameStatus = GameStatusEnum.starting;
      _playerScore = 0;
      _playerBestScore = getIt<SharedPreferences>()
              .getInt(AppConstants.sharedKeySnakeBestScore) ??
          0;
      _snakeSpeed = AppConstants.snakeBaseSpeed;
    });
    _gameBoardEntity?.initSnakeGame(restart: restart);
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _resumeGame() {
    setState(() {
      _gameStatus = GameStatusEnum.starting;
    });
    widget.gameNotifier.updateGameStatus(_gameStatus);
  }

  void _startGame() {
    setState(() {
      _gameStatus = GameStatusEnum.started;
      _enableTap = true;
    });
    _snakeTimer = Timer.periodic(
      Duration(milliseconds: _snakeSpeed),
      (Timer timer) {
        _gameBoardEntity!.computeNextMatrix(_direction);
        setState(() {
          _enableTap = _gameStatus == GameStatusEnum.started;
        });
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
                    child: SnakeScoreWidget(
                      playerScore: _playerScore,
                      updateSpeed: _updateSpeedWithScoreLevel,
                    ),
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
                                snackImageInfo: widget.snackImageInfo,
                                poisonImageInfo: widget.poisonImageInfo,
                                wallImageInfo: widget.wallImageInfo,
                                deadImageInfo: widget.deadImageInfo,
                                snakeHeadImageInfo: widget.snakeHeadImageInfo,
                                snakeHeadEatingImageInfo:
                                    widget.snakeHeadEatingImageInfo,
                                snakeBodyStraightImageInfo:
                                    widget.snakeBodyStraightImageInfo,
                                snakeBodyAngleLeftImageInfo:
                                    widget.snakeBodyAngleLeftImageInfo,
                                snakeBodyAngleRightImageInfo:
                                    widget.snakeBodyAngleRightImageInfo,
                                snakeTailImageInfo: widget.snakeTailImageInfo,
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
              onStart: () => _initGame(),
              playerBestScore: _playerBestScore,
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
          if (_gameStatus == GameStatusEnum.gameOver)
            OpacityGameOverWidget(
              topPadding: _scoreSize.height,
              boardHeight: _boardSize.height,
              onRestart: () => _initGame(restart: true),
              playerScore: _playerScore,
              playerBestScore: _playerBestScore,
            ),
        ],
      ),
    );
  }
}

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/size_aware_widget.dart';
import 'package:fangapp/feature/snake/entities/game_board_entity.dart';
import 'package:fangapp/feature/snake/snake_painter.dart';
import 'package:fangapp/feature/snake/snake_score_widget.dart';
import 'package:flutter/cupertino.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({Key? key}) : super(key: key);

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  Size _boardSize = Size.zero;
  GameBoardEntity? _gameBoardEntity;

  void _initSnakeBoardSize({
    required Size boardSize,
  }) {
    setState(() {
      _boardSize = boardSize;
      _gameBoardEntity = GameBoardEntity(
        gameBoardSize: boardSize,
        initWithWall: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              SizeAwareWidget(
                onChange: (Size size) => _initSnakeBoardSize(
                  boardSize: Size(
                    constraints.maxWidth,
                    constraints.maxHeight - size.height,
                  ),
                ),
                child: const SnakeScoreWidget(),
              ),
              Container(
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
            ],
          );
        },
      ),
    );
  }
}

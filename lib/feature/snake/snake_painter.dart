import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:fangapp/feature/snake/entities/snack_box_entity.dart';
import 'package:fangapp/feature/snake/entities/wall_box_entity.dart';
import 'package:flutter/material.dart';

import 'entities/game_board_entity.dart';
import 'entities/snake_box_entity.dart';

class SnakePainter extends CustomPainter {
  SnakePainter({
    required this.gameBoardEntity,
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
  });

  final GameBoardEntity gameBoardEntity;
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

  void _drawBackground(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = AppColors.black90
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint1);
  }

  ImageInfo _selectImageInfo(SnakeBoxEntity box) {
    if (box.isDead) return deadImageInfo;
    if (box.isHead) {
      if (box.isEating) return snakeHeadEatingImageInfo;
      return snakeHeadImageInfo;
    }
    if (box.isTail) return snakeTailImageInfo;
    if (box.direction != box.previousDirection) {
      return box.needLeftAngleImage()
          ? snakeBodyAngleLeftImageInfo
          : snakeBodyAngleRightImageInfo;
    }
    return snakeBodyStraightImageInfo;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas, size);
    // Draw all box entities
    gameBoardEntity.applyToMatrix((BoxEntity? box) {
      switch (box.runtimeType) {
        case WallBoxEntity:
          (box! as WallBoxEntity).draw(canvas, imageInfo: wallImageInfo);
          break;
        case SnackBoxEntity:
          (box! as SnackBoxEntity).draw(
            canvas,
            imageInfo: (box as SnackBoxEntity).isPoison
                ? poisonImageInfo
                : snackImageInfo,
          );
          break;
        case SnakeBoxEntity:
          (box! as SnakeBoxEntity).draw(
            canvas,
            imageInfo: _selectImageInfo(box as SnakeBoxEntity),
          );
          break;
        default:
          box?.draw(canvas);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

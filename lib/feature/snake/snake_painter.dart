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
    required this.wallImageInfo,
    required this.deadImageInfo,
  });

  final GameBoardEntity gameBoardEntity;
  final ImageInfo snackImageInfo;
  final ImageInfo wallImageInfo;
  final ImageInfo deadImageInfo;

  void _drawBackground(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = AppColors.greyLight
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas, size);
    // Draw all box entities
    gameBoardEntity.applyToMatrix((BoxEntity? box) {
      switch(box.runtimeType) {
        case WallBoxEntity:
          (box! as WallBoxEntity).draw(canvas, imageInfo: wallImageInfo);
          break;
        case SnackBoxEntity:
          (box! as SnackBoxEntity).draw(canvas, imageInfo: snackImageInfo);
          break;
        case SnakeBoxEntity:
          (box! as SnakeBoxEntity).draw(canvas, imageInfo: deadImageInfo);
          break;
        default:
          box?.draw(canvas);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

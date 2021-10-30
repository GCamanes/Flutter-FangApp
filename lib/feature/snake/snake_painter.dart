import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

import 'entities/game_board_entity.dart';

class SnakePainter extends CustomPainter {
  SnakePainter({
    required this.gameBoardEntity,
  });

  final GameBoardEntity gameBoardEntity;

  void _drawBackground(Canvas canvas, Size size) {
    // Principal background
    final Paint paint1 = Paint()
      ..color = const Color(0xff638965)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint1);

    // Bottom background to fill unused height
    final Paint paint2 = Paint()
      ..color = AppColors.black90
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        gameBoardEntity.numberOfBoxesPerColumn * gameBoardEntity.boxSize,
        size.width,
        size.height -
            gameBoardEntity.numberOfBoxesPerColumn * gameBoardEntity.boxSize,
      ),
      paint2,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas, size);
    // Draw all box entities
    for (final List<BoxEntity?> row in gameBoardEntity.boxesMatrix) {
      for (final BoxEntity? boxEntity in row) {
        boxEntity?.draw(canvas);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

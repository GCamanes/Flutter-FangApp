import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

import 'entities/game_board_entity.dart';

class SnakePainter extends CustomPainter {
  SnakePainter({
    required this.gameBoardEntity,
  });

  final GameBoardEntity gameBoardEntity;

  void _drawBackground(Canvas canvas, Size size) {
    final Paint paint1 = Paint()
      ..color = const Color(0xff638965)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    _drawBackground(canvas, size);
    // Draw all box entities
    gameBoardEntity.applyToMatrix((BoxEntity? box) => box?.draw(canvas));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';

class SnakeBoxEntity extends BoxEntity {
  SnakeBoxEntity({
    required int columnIndex,
    required int rowIndex,
    required double boxSize,
    this.isHead = false,
    this.isTail = false,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
          boxSize: boxSize,
        );

  late bool isHead;
  late bool isTail;

  @override
  void draw(Canvas canvas) {
    final Paint paint = Paint()
      ..color = isHead
          ? AppColors.orange
          : isTail
              ? AppColors.blueLight
              : AppColors.blackSmoke
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      getOffset,
      boxSize / 2,
      paint,
    );
  }
}

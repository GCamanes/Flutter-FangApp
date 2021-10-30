import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';

class WallBoxEntity extends BoxEntity {
  WallBoxEntity({
    required int columnIndex,
    required int rowIndex,
    required double boxSize,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
          boxSize: boxSize,
        );

  @override
  void draw(Canvas canvas) {
    final Paint paint = Paint()
      ..color = AppColors.grey
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Offset(rowIndex * boxSize, columnIndex * boxSize) &
          Size(boxSize, boxSize),
      paint,
    );
  }
}

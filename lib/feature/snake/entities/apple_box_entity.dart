import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';

class AppleBoxEntity extends BoxEntity {
  AppleBoxEntity({
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
      ..color = AppColors.yellow
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      getOffset + Offset(boxSize / 2, boxSize / 2),
      boxSize / 2,
      paint,
    );
  }
}

import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';

class SnakeBoxEntity extends BoxEntity {
  SnakeBoxEntity({
    required int columnIndex,
    required int rowIndex,
    this.isHead = false,
    this.isTail = false,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
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
      getOffset +
          Offset(
            AppHelper().snakeBoxSize / 2,
            AppHelper().snakeBoxSize / 2,
          ),
      AppHelper().snakeBoxSize / 2,
      paint,
    );
  }
}

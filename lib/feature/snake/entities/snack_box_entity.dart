import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

class SnackBoxEntity extends BoxEntity {
  SnackBoxEntity({
    required int columnIndex,
    required int rowIndex,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        );

  @override
  void draw(Canvas canvas, {ImageInfo? imageInfo}) {
    final Paint paint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.fill;
    /*canvas.drawCircle(
      getOffset +
          Offset(
            AppHelper().snakeBoxSize / 2,
            AppHelper().snakeBoxSize / 2,
          ),
      AppHelper().snakeBoxSize / 2,
      paint,
    );*/
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        getOffset.dx,
        getOffset.dy,
        getSize.width,
        getSize.width,
      ),
      image: imageInfo!.image,
    );
  }
}

import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

class WallBoxEntity extends BoxEntity {
  WallBoxEntity({
    required int columnIndex,
    required int rowIndex,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        );

  @override
  void draw(Canvas canvas, {ImageInfo? imageInfo}) {
    final Paint paint = Paint()
      ..color = AppColors.grey
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      getOffset & getSize,
      paint,
    );
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

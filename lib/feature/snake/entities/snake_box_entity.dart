import 'dart:ui';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

class SnakeBoxEntity extends BoxEntity {
  SnakeBoxEntity({
    required int columnIndex,
    required int rowIndex,
    this.isDead = false,
    this.isHead = false,
    this.isTail = false,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        );

  late bool isDead;
  late bool isHead;
  late bool isTail;

  @override
  void draw(Canvas canvas, {ImageInfo? imageInfo}) {
    final Paint paint = Paint()
      ..color = isDead
          ? AppColors.red
          : isHead
              ? AppColors.orange
              : isTail
                  ? AppColors.blueLight
                  : AppColors.blackSmoke
      ..style = PaintingStyle.fill;

    if (isDead && imageInfo != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(
          getOffset.dx,
          getOffset.dy,
          getSize.width,
          getSize.width,
        ),
        image: imageInfo.image,
      );
    } else {
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
}

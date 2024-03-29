import 'dart:ui';

import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

// Class dedicated to snake body
class SnakeBoxEntity extends BoxEntity {
  SnakeBoxEntity({
    required int columnIndex,
    required int rowIndex,
    this.isDead = false,
    this.isHead = false,
    this.isTail = false,
    this.isEating = false,
    this.direction = DirectionEnum.up,
    this.previousDirection = DirectionEnum.up,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        );

  late bool isDead;
  late bool isHead;
  late bool isTail;
  late bool isEating;
  late DirectionEnum direction;
  late DirectionEnum previousDirection;

  void rotate({
    required Canvas canvas,
    required double cx,
    required double cy,
    required double angle,
  }) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  double _getAngle(DirectionEnum direction) {
    switch (direction) {
      case DirectionEnum.left:
        return 90;
      case DirectionEnum.down:
        return 180;
      case DirectionEnum.right:
        return 270;
      default:
        return 0;
    }
  }

  bool needLeftAngleImage() {
    final double angleDiff =
        _getAngle(direction) - _getAngle(previousDirection);
    return angleDiff == 90 || angleDiff == -270;
  }

  @override
  void draw(Canvas canvas, {ImageInfo? imageInfo}) {
    if (imageInfo != null) {
      // Compute angle
      final double angle = _getAngle(direction) * 3.14 / 180;
      // Rotate canvas to angle
      canvas.save();
      rotate(
        canvas: canvas,
        cx: getOffset.dx + AppHelper().snakeBoxSize / 2,
        cy: getOffset.dy + AppHelper().snakeBoxSize / 2,
        angle: -angle,
      );
      // Draw image
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
      // Rotate canvas back
      rotate(
        canvas: canvas,
        cx: getOffset.dx + AppHelper().snakeBoxSize / 2,
        cy: getOffset.dy + AppHelper().snakeBoxSize / 2,
        angle: angle,
      );
      canvas.restore();
    }
  }
}

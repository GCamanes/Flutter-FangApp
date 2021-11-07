import 'dart:ui';

import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/feature/snake/entities/position_entity.dart';
import 'package:flutter/cupertino.dart';

// Generic class entity : all box entity extend it
// position and draw method
abstract class BoxEntity {
  BoxEntity({
    required this.columnIndex,
    required this.rowIndex,
  });

  late final int columnIndex;
  late final int rowIndex;

  Offset get getOffset => Offset(
        columnIndex * AppHelper().snakeBoxSize,
        rowIndex * AppHelper().snakeBoxSize,
      );

  Size get getSize => Size(AppHelper().snakeBoxSize, AppHelper().snakeBoxSize);

  bool isSamePosition(PositionEntity position) =>
      position.columnIndex == columnIndex && position.rowIndex == rowIndex;

  void draw(Canvas canvas, {ImageInfo? imageInfo});
}

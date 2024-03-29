import 'dart:ui';

import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

// Class dedicated to wall
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

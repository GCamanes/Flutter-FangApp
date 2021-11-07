import 'dart:ui';

import 'package:fangapp/feature/snake/entities/box_entity.dart';
import 'package:flutter/material.dart';

// Class dedicated to snack
class SnackBoxEntity extends BoxEntity {
  SnackBoxEntity({
    required int columnIndex,
    required int rowIndex,
    this.isPoison = false,
  }) : super(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        );

  final bool isPoison;

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

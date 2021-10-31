import 'dart:ui';

import 'package:fangapp/feature/snake/entities/position_entity.dart';

abstract class BoxEntity {
  BoxEntity({
    required this.columnIndex,
    required this.rowIndex,
    required this.boxSize,
  });

  late final int columnIndex;
  late final int rowIndex;
  late final double boxSize;

  Offset get getOffset => Offset(columnIndex * boxSize, rowIndex * boxSize);

  Size get getSize => Size(boxSize, boxSize);

  bool isSamePosition(PositionEntity position) =>
      position.columnIndex == columnIndex && position.rowIndex == rowIndex;

  void draw(Canvas canvas);
}

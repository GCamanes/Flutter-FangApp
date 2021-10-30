import 'dart:ui';

abstract class BoxEntity {
  BoxEntity({
    required this.columnIndex,
    required this.rowIndex,
    required this.boxSize,
  });

  late final int columnIndex;
  late final int rowIndex;
  late final double boxSize;

  void draw(Canvas canvas);
}

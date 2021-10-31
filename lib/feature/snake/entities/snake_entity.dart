import 'package:fangapp/feature/snake/entities/snake_box_entity.dart';

class SnakeEntity {
  SnakeEntity({
    this.length = 5,
    required int startColumnIndex,
    required int startRowIndex,
    required double boxSize,
  }) {
    body = List<SnakeBoxEntity>.generate(length, (int index) {
      return SnakeBoxEntity(
        columnIndex: startColumnIndex,
        rowIndex: startRowIndex + index,
        boxSize: boxSize,
        isHead: index == 0,
        isTail: index == length - 1,
      );
    });
  }

  late int length;

  late List<SnakeBoxEntity> body;
}

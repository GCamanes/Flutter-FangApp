import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/enum/snake_status_enum.dart';
import 'package:fangapp/feature/snake/entities/position_entity.dart';
import 'package:fangapp/feature/snake/entities/snake_box_entity.dart';

class SnakeEntity {
  SnakeEntity({
    this.length = 5,
    required int startColumnIndex,
    required int startRowIndex,
  }) {
    body = List<SnakeBoxEntity>.generate(length, (int index) {
      return SnakeBoxEntity(
        columnIndex: startColumnIndex,
        rowIndex: startRowIndex + index,
        isHead: index == 0,
        isTail: index == length - 1,
      );
    });
  }

  late int length;

  late List<SnakeBoxEntity> body;

  PositionEntity getNextHeadPosition(DirectionEnum direction) {
    return PositionEntity(
      columnIndex: direction == DirectionEnum.left
          ? body.first.columnIndex - 1
          : direction == DirectionEnum.right
              ? body.first.columnIndex + 1
              : body.first.columnIndex,
      rowIndex: direction == DirectionEnum.up
          ? body.first.rowIndex - 1
          : direction == DirectionEnum.down
              ? body.first.rowIndex + 1
              : body.first.rowIndex,
    );
  }

  SnakeStatusEnum move({
    required PositionEntity nextPosition,
    bool isAppleNext = false,
    bool isWallNext = false,
  }) {
    // Wall case : no movement // TODO: stop game
    if (isWallNext) return SnakeStatusEnum.dead;
    // Body case : no movement // TODO: stop game
    for (final SnakeBoxEntity box in body) {
      if (box.isSamePosition(nextPosition) && box != body.last) {
        return SnakeStatusEnum.dead;
      }
    }
    // Update head to new position
    body.first.isHead = false;
    body.insert(
      0,
      SnakeBoxEntity(
        isHead: true,
        columnIndex: nextPosition.columnIndex,
        rowIndex: nextPosition.rowIndex,
      ),
    );
    // TODO: increase score in case of apple
    if (isAppleNext) {
      return SnakeStatusEnum.eatFruit;
    } else {
      // Update new snake tail
      body.remove(body.last);
      body.last.isTail = true;
      return SnakeStatusEnum.ok;
    }
  }
}

import 'package:collection/collection.dart';
import 'package:fangapp/core/data/app_constants.dart';
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

  PositionEntity getNextHeadPosition(
    DirectionEnum direction,
    int numberOfRows,
  ) {
    int nextColumnIndex = direction == DirectionEnum.left
        ? body.first.columnIndex - 1
        : direction == DirectionEnum.right
            ? body.first.columnIndex + 1
            : body.first.columnIndex;
    int nextRow = direction == DirectionEnum.up
        ? body.first.rowIndex - 1
        : direction == DirectionEnum.down
            ? body.first.rowIndex + 1
            : body.first.rowIndex;

    if (nextColumnIndex >= AppConstants.snakeNumberOfColumns) {
      nextColumnIndex = 0;
    } else if (nextColumnIndex < 0) {
      nextColumnIndex = AppConstants.snakeNumberOfColumns - 1;
    }

    if (nextRow >= numberOfRows) {
      nextRow = 0;
    } else if (nextRow < 0) {
      nextRow = numberOfRows - 1;
    }

    return PositionEntity(
      columnIndex: nextColumnIndex,
      rowIndex: nextRow,
    );
  }

  SnakeStatusEnum die() {
    final SnakeBoxEntity? nextToDie = body.firstWhereOrNull(
      (SnakeBoxEntity box) => !box.isDead,
    );
    if (nextToDie != null) {
      nextToDie.isDead = true;
      return SnakeStatusEnum.dying;
    }
    return SnakeStatusEnum.dead;
  }

  SnakeStatusEnum move({
    required DirectionEnum direction,
    required PositionEntity nextPosition,
    bool isSnackNext = false,
    bool isWallNext = false,
  }) {
    // Wall case : no movement and snake dying
    if (isWallNext) return die();
    // Body case : no movement and snake dying
    for (final SnakeBoxEntity box in body) {
      if (box.isSamePosition(nextPosition) && box != body.last) {
        return die();
      }
    }
    // Update head to new position
    body.first.isHead = false;
    body.first.previousDirection = body.first.direction;
    body.first.direction = direction;
    body.insert(
      0,
      SnakeBoxEntity(
        direction: direction,
        isHead: true,
        columnIndex: nextPosition.columnIndex,
        rowIndex: nextPosition.rowIndex,
      ),
    );
    // Snack Case : no need to update snake tail
    if (isSnackNext) {
      body.first.isEating = true;
      return SnakeStatusEnum.eatSnack;
    } else {
      body.first.isEating = false;
      // Update new snake tail
      body.remove(body.last);
      body.last.isTail = true;
      return SnakeStatusEnum.ok;
    }
  }
}

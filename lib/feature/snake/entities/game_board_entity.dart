import 'dart:math';
import 'dart:ui';

import 'package:fangapp/feature/snake/entities/apple_box_entity.dart';
import 'package:fangapp/feature/snake/entities/snake_box_entity.dart';
import 'package:fangapp/feature/snake/entities/snake_entity.dart';
import 'package:fangapp/feature/snake/entities/wall_box_entity.dart';

import 'box_entity.dart';

class GameBoardEntity {
  GameBoardEntity({
    required Size gameBoardSize,
    bool initWithWall = false,
  }) {
    _random = Random();

    boxSize = gameBoardSize.width / numberOfColumns;
    numberOfRows = gameBoardSize.height ~/ boxSize;

    boxesMatrix = initWithWall ? _initWithWAll() : _initEmpty();
    snakeEntity = SnakeEntity(
      startColumnIndex: numberOfColumns ~/ 2 + 1,
      startRowIndex: numberOfRows ~/ 2 + 1,
      boxSize: boxSize,
    );
    _addSnakeToMatrix();
    _addRandomAppleToMatrix();
  }

  late final Random _random;

  final int numberOfColumns = 25;
  late final int numberOfRows;
  late final double boxSize;
  late SnakeEntity snakeEntity;

  late List<List<BoxEntity?>> boxesMatrix;

  void applyToMatrix(Function(BoxEntity? box) function) {
    for (final List<BoxEntity?> row in boxesMatrix) {
      for (final BoxEntity? boxEntity in row) {
        function(boxEntity);
      }
    }
  }

  List<List<BoxEntity?>> _initEmpty() =>
      List<List<BoxEntity?>>.generate(numberOfColumns, (int columnIndex) {
        return List<BoxEntity?>.generate(numberOfRows, (int rowIndex) {
          return null;
        });
      });

  List<List<BoxEntity?>> _initWithWAll() =>
      List<List<BoxEntity?>>.generate(numberOfColumns, (int columnIndex) {
        return List<BoxEntity?>.generate(numberOfRows, (int rowIndex) {
          if (rowIndex == 0 ||
              rowIndex == numberOfRows - 1 ||
              columnIndex == 0 ||
              columnIndex == numberOfColumns - 1) {
            return WallBoxEntity(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
              boxSize: boxSize,
            );
          }
          return null;
        });
      });

  void _addSnakeToMatrix() {
    for (final SnakeBoxEntity box in snakeEntity.body) {
      boxesMatrix[box.columnIndex][box.rowIndex] = box;
    }
  }

  void _addRandomAppleToMatrix() {
    final List<Offset> boxCandidates = <Offset>[];
    for (final int columnIndex in List<int>.generate(
      numberOfColumns,
      (int columnIndex) => columnIndex,
    )) {
      for (final int rowIndex in List<int>.generate(
        numberOfRows,
        (int rowIndex) => rowIndex,
      )) {
        if (boxesMatrix[columnIndex][rowIndex] == null) {
          boxCandidates
              .add(Offset(columnIndex.toDouble(), rowIndex.toDouble()));
        }
      }
    }

    final Offset position =
        boxCandidates[_random.nextInt(boxCandidates.length-1)];

    boxesMatrix[position.dx.toInt()][position.dy.toInt()] = AppleBoxEntity(
      columnIndex: position.dx.toInt(),
      rowIndex: position.dy.toInt(),
      boxSize: boxSize,
    );
  }
}

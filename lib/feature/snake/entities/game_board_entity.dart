import 'dart:math';
import 'dart:ui';

import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/feature/snake/entities/apple_box_entity.dart';
import 'package:fangapp/feature/snake/entities/position_entity.dart';
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
    _addAppleToMatrix(_getRandomEmptyPosition());
  }

  late final Random _random;

  final int numberOfColumns = 25;
  late final int numberOfRows;
  late final double boxSize;

  late SnakeEntity snakeEntity;

  late List<List<BoxEntity?>> boxesMatrix;

  double get boardSize => numberOfRows * boxSize;

  // Function to apply a function on every matrix boxes
  void applyToMatrix(Function(BoxEntity? box) function) {
    for (final List<BoxEntity?> row in boxesMatrix) {
      for (final BoxEntity? boxEntity in row) {
        function(boxEntity);
      }
    }
  }

  // Init empty matrix
  List<List<BoxEntity?>> _initEmpty() =>
      List<List<BoxEntity?>>.generate(numberOfColumns, (int columnIndex) {
        return List<BoxEntity?>.generate(numberOfRows, (int rowIndex) {
          return null;
        });
      });

  // Init matrix with border walls
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
    // Add snake to matrix
    for (final SnakeBoxEntity box in snakeEntity.body) {
      boxesMatrix[box.columnIndex][box.rowIndex] = box;
    }
  }

  void _removeSnakeFromMatrix() {
    // Remove snake from matrix
    for (final SnakeBoxEntity box in snakeEntity.body) {
      boxesMatrix[box.columnIndex][box.rowIndex] = null;
    }
  }

  PositionEntity _getRandomEmptyPosition() {
    final List<PositionEntity> boxCandidates = <PositionEntity>[];
    // Loop on matrix rows and columns to save empty position
    for (final int columnIndex in List<int>.generate(
      numberOfColumns,
      (int columnIndex) => columnIndex,
    )) {
      for (final int rowIndex in List<int>.generate(
        numberOfRows,
        (int rowIndex) => rowIndex,
      )) {
        if (boxesMatrix[columnIndex][rowIndex] == null) {
          boxCandidates.add(
            PositionEntity(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
            ),
          );
        }
      }
    }
    // Return random PositionEntity
    return boxCandidates[_random.nextInt(boxCandidates.length - 1)];
  }

  void _addAppleToMatrix(PositionEntity position) {
    // Set apple box entity to selected position
    boxesMatrix[position.columnIndex][position.rowIndex] = AppleBoxEntity(
      columnIndex: position.columnIndex,
      rowIndex: position.rowIndex,
      boxSize: boxSize,
    );
  }

  void computeNextMatrix(DirectionEnum direction) {
    // Remove snake from matrix
    _removeSnakeFromMatrix();

    // Get next position of snake head
    final PositionEntity nextPosition =
        snakeEntity.getNextHeadPosition(direction);

    // Save if next position is apple or wall box
    final bool isAppleNext = boxesMatrix[nextPosition.columnIndex]
        [nextPosition.rowIndex] is AppleBoxEntity;
    final bool isWallNext = boxesMatrix[nextPosition.columnIndex]
        [nextPosition.rowIndex] is WallBoxEntity;

    // Update snake entity
    snakeEntity.move(
      nextPosition: nextPosition,
      isAppleNext: isAppleNext,
      isWallNext: isWallNext,
    );

    // Update snake in matrix
    _addSnakeToMatrix();
  }
}

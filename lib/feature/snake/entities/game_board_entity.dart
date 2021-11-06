import 'dart:math';
import 'dart:ui';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/enum/direction_enum.dart';
import 'package:fangapp/core/enum/snake_status_enum.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/feature/snake/entities/position_entity.dart';
import 'package:fangapp/feature/snake/entities/snack_box_entity.dart';
import 'package:fangapp/feature/snake/entities/snake_box_entity.dart';
import 'package:fangapp/feature/snake/entities/snake_entity.dart';
import 'package:fangapp/feature/snake/entities/wall_box_entity.dart';

import 'box_entity.dart';

class GameBoardEntity {
  GameBoardEntity({
    required Size gameBoardSize,
    this.initWithWall = true,
    required this.handleSnakeDead,
    required this.handleSnakeEatSnack,
    required this.handleSnakeDying,
  }) {
    _random = Random();
    numberOfRows = gameBoardSize.height ~/ AppHelper().snakeBoxSize;
    initBoard();
  }

  // Game board values
  late final Random _random;

  late final int numberOfRows;

  late bool initWithWall;
  late SnakeEntity snakeEntity;
  late List<List<BoxEntity?>> boxesMatrix;

  SnackBoxEntity? _poisonBoxEntity;

  late int _poisonTimer;

  // Getters
  double get boardSize => numberOfRows * AppHelper().snakeBoxSize;

  // Functions to handle snake status
  Function() handleSnakeDead;
  Function() handleSnakeEatSnack;
  Function() handleSnakeDying;

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
      List<List<BoxEntity?>>.generate(AppConstants.snakeNumberOfColumns,
          (int columnIndex) {
        return List<BoxEntity?>.generate(numberOfRows, (int rowIndex) {
          return null;
        });
      });

  // Init matrix with border walls
  List<List<BoxEntity?>> _initWithWAll() =>
      List<List<BoxEntity?>>.generate(AppConstants.snakeNumberOfColumns,
          (int columnIndex) {
        return List<BoxEntity?>.generate(numberOfRows, (int rowIndex) {
          bool addWall = false;
          // Top left wall corner
          if (columnIndex == 4 && rowIndex >= 4 && rowIndex <= 8) {
            addWall = true;
          }
          if (rowIndex == 4 && columnIndex >= 4 && columnIndex <= 8) {
            addWall = true;
          }

          // Top right wall corner
          if (columnIndex == AppConstants.snakeNumberOfColumns - 5 &&
              rowIndex >= 4 &&
              rowIndex <= 8) {
            addWall = true;
          }
          if (rowIndex == 4 &&
              columnIndex <= AppConstants.snakeNumberOfColumns - 5 &&
              columnIndex >= AppConstants.snakeNumberOfColumns - 9) {
            addWall = true;
          }

          // Bottom left wall corner
          if (columnIndex == 4 &&
              rowIndex <= numberOfRows - 5 &&
              rowIndex >= numberOfRows - 9) {
            addWall = true;
          }
          if (rowIndex == numberOfRows - 5 &&
              columnIndex >= 4 &&
              columnIndex <= 8) {
            addWall = true;
          }

          // Bottom right wall corner
          if (columnIndex == AppConstants.snakeNumberOfColumns - 5 &&
              rowIndex <= numberOfRows - 5 &&
              rowIndex >= numberOfRows - 9) {
            addWall = true;
          }
          if (rowIndex == numberOfRows - 5 &&
              columnIndex <= AppConstants.snakeNumberOfColumns - 5 &&
              columnIndex >= AppConstants.snakeNumberOfColumns - 9) {
            addWall = true;
          }

          if (addWall) {
            return WallBoxEntity(
              columnIndex: columnIndex,
              rowIndex: rowIndex,
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
      AppConstants.snakeNumberOfColumns,
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

  SnackBoxEntity _addSnackToMatrix(PositionEntity position,
      {bool isPoison = false}) {
    // Create snack box entity
    final SnackBoxEntity snackBoxEntity = SnackBoxEntity(
      columnIndex: position.columnIndex,
      rowIndex: position.rowIndex,
      isPoison: isPoison,
    );
    // Set apple box entity to selected position
    boxesMatrix[position.columnIndex][position.rowIndex] = snackBoxEntity;

    return snackBoxEntity;
  }

  void _removeSnackFromMatrix(SnackBoxEntity snackBoxEntity) {
    boxesMatrix[snackBoxEntity.columnIndex][snackBoxEntity.rowIndex] = null;
  }

  void initBoard() {
    boxesMatrix = initWithWall ? _initWithWAll() : _initEmpty();
    _poisonTimer = 0;
  }

  void initSnakeGame({bool restart = false}) {
    if (restart) initBoard();
    snakeEntity = SnakeEntity(
      startColumnIndex: AppConstants.snakeNumberOfColumns ~/ 2,
      startRowIndex: numberOfRows ~/ 2 - 3,
    );
    _addSnakeToMatrix();
    _addSnackToMatrix(_getRandomEmptyPosition());
    _poisonBoxEntity = _addSnackToMatrix(
      _getRandomEmptyPosition(),
      isPoison: true,
    );
  }

  void handleSnakeStatus(SnakeStatusEnum snakeStatus) {
    switch (snakeStatus) {
      case SnakeStatusEnum.dead:
        handleSnakeDead();
        break;
      case SnakeStatusEnum.eatSnack:
        _addSnackToMatrix(_getRandomEmptyPosition());
        handleSnakeEatSnack();
        break;
      case SnakeStatusEnum.dying:
        handleSnakeDying();
        break;
      default:
        // Handle poison box presence
        if (_poisonTimer >= AppConstants.snakeTimeBeforePoisonDisappear &&
            _poisonBoxEntity != null) {
          _removeSnackFromMatrix(_poisonBoxEntity!);
          _poisonBoxEntity = null;
          _poisonTimer = 0;
        }
        if (_poisonTimer == AppConstants.snakeTimeBeforePoisonSpawn &&
            _poisonBoxEntity == null) {
          _poisonBoxEntity = _addSnackToMatrix(
            _getRandomEmptyPosition(),
            isPoison: true,
          );
          _poisonTimer = 0;
        }
    }
  }

  void computeNextMatrix(DirectionEnum direction) {
    // Handle poison timer
    _poisonTimer += 1;

    // Remove snake from matrix
    _removeSnakeFromMatrix();

    // Get next position of snake head
    final PositionEntity nextPosition =
        snakeEntity.getNextHeadPosition(direction, numberOfRows);

    // Save if next position is snack or wall box
    final bool isSnackNext = boxesMatrix[nextPosition.columnIndex]
            [nextPosition.rowIndex] is SnackBoxEntity &&
        !(boxesMatrix[nextPosition.columnIndex][nextPosition.rowIndex]!
                as SnackBoxEntity)
            .isPoison;
    final bool isPoisonNext = boxesMatrix[nextPosition.columnIndex]
            [nextPosition.rowIndex] is SnackBoxEntity &&
        (boxesMatrix[nextPosition.columnIndex][nextPosition.rowIndex]!
                as SnackBoxEntity)
            .isPoison;
    final bool isWallNext = boxesMatrix[nextPosition.columnIndex]
        [nextPosition.rowIndex] is WallBoxEntity;

    // Update snake entity
    final SnakeStatusEnum snakeStatus = snakeEntity.move(
      direction: direction,
      nextPosition: nextPosition,
      isSnackNext: isSnackNext,
      isPoisonNext: isPoisonNext,
      isWallNext: isWallNext,
    );

    // Update snake in matrix
    _addSnakeToMatrix();

    // Update game according to snake status
    handleSnakeStatus(snakeStatus);
  }
}

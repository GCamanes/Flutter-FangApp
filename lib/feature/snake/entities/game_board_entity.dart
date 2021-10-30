import 'dart:ui';

import 'package:fangapp/feature/snake/entities/wall_box_entity.dart';

import 'box_entity.dart';

class GameBoardEntity {
  GameBoardEntity({
    required Size gameBoardSize,
    bool initWithWall = false,
  }) {
    boxSize = gameBoardSize.width / numberOfBoxesPerRow;
    numberOfBoxesPerColumn = gameBoardSize.height ~/ boxSize;

    boxesMatrix = initWithWall ? _initWithWAll() : _initEmpty();
  }

  final int numberOfBoxesPerRow = 25;
  late final int numberOfBoxesPerColumn;
  late final double boxSize;

  late List<List<BoxEntity?>> boxesMatrix;


  List<List<BoxEntity?>> _initEmpty() =>
      List<List<BoxEntity?>>.generate(numberOfBoxesPerRow, (int rowIndex) {
        return List<BoxEntity?>.generate(numberOfBoxesPerColumn,
                (int columnIndex) {
              return null;
            });
      });

  List<List<BoxEntity?>> _initWithWAll() =>
      List<List<BoxEntity?>>.generate(numberOfBoxesPerRow, (int rowIndex) {
        return List<BoxEntity?>.generate(numberOfBoxesPerColumn,
                (int columnIndex) {
              if (rowIndex == 0 ||
                  rowIndex == numberOfBoxesPerRow - 1 ||
                  columnIndex == 0 ||
                  columnIndex == numberOfBoxesPerColumn - 1) {
                return WallBoxEntity(
                  columnIndex: columnIndex,
                  rowIndex: rowIndex,
                  boxSize: boxSize,
                );
              }
              return null;
            });
      });
}

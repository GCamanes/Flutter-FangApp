// Class to manage position (column, row index) easily
class PositionEntity {
  PositionEntity({
    required this.columnIndex,
    required this.rowIndex,
  });

  late final int columnIndex;
  late final int rowIndex;

  @override
  String toString() => 'Position $columnIndex $rowIndex';
}

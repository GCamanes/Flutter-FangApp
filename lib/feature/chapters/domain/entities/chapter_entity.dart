import 'package:equatable/equatable.dart';

class ChapterEntity extends Equatable {
  const ChapterEntity({
    this.isRead = false,
    required this.key,
    required this.number,
    required this.pages,
  });

  final bool isRead;
  final String key;
  final String number;
  final List<String> pages;

  @override
  List<Object?> get props => <dynamic>[
    isRead,
    key,
    number,
    pages,
  ];
}

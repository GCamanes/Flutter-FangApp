import 'package:equatable/equatable.dart';

class LightChapterEntity extends Equatable {
  const LightChapterEntity({
    this.isRead = false,
    required this.key,
    required this.number,
  });

  final bool isRead;
  final String key;
  final String number;

  @override
  List<Object?> get props => <dynamic>[
    isRead,
    key,
    number,
  ];
}

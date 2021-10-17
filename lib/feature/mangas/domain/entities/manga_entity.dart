import 'package:equatable/equatable.dart';

class MangaEntity extends Equatable {
  const MangaEntity({
    required this.authors,
    required this.chapterKeys,
    required this.coverLink,
    this.isFavorite = false,
    required this.key,
    required this.lastRelease,
    required this.status,
    required this.title,
  });

  final List<String> authors;
  final List<String> chapterKeys;
  final String coverLink;
  final bool isFavorite;
  final String key;
  final String lastRelease;
  final String status;
  final String title;

  @override
  List<Object?> get props => <dynamic>[
    authors,
    chapterKeys,
    coverLink,
    isFavorite,
    key,
    lastRelease,
    status,
    title,
  ];
}

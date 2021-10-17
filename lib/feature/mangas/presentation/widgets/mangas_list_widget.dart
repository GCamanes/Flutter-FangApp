import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/mangas/presentation/cubit/mangas_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'manga_tile_widget.dart';

class MangasListWidget extends StatelessWidget {
  const MangasListWidget({
    Key? key,
    this.showOnlyFavorites = false,
    required this.emptyMessage,
  }) : super(key: key);

  final bool showOnlyFavorites;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangasCubit, MangasState>(
      builder: (BuildContext context, MangasState state) {
        if (state is MangasLoading) {
          return const Center(child: LoadingWidget());
        }
        if (state is MangasLoaded) {
          final List<MangaEntity> filteredMangas = showOnlyFavorites
              ? state.mangas
                  .where((MangaEntity manga) => manga.isFavorite)
                  .toList()
              : state.mangas;
          if (filteredMangas.isEmpty) {
            return MessageWidget(message: emptyMessage);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            key: PageStorageKey<String>(
              showOnlyFavorites
                  ? AppConstants.mangasFavoritesPageStorageKey
                  : AppConstants.mangasPageStorageKey,
            ),
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.transparent, height: 10),
            itemBuilder: (BuildContext context, int index) => MangaTileWidget(
              manga: filteredMangas[index],
            ),
            itemCount: filteredMangas.length,
          );
        }
        if (state is MangasError) {
          return MessageWidget(
            message: 'error.${state.code}'.translate(),
          );
        }
        return const SizedBox();
      },
    );
  }
}

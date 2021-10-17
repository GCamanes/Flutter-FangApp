import 'dart:async';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/interaction_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/reading/presentation/cubit/chapter_reading_cubit.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ChapterReadingPage extends StatefulWidget {
  const ChapterReadingPage({
    Key? key,
    required this.manga,
    required this.chapter,
  }) : super(key: key);

  final MangaEntity? manga;
  final LightChapterEntity? chapter;

  @override
  _ChapterReadingPageState createState() => _ChapterReadingPageState();
}

class _ChapterReadingPageState extends State<ChapterReadingPage> {
  late final ChapterReadingCubit _chapterReadingCubit;
  int _currentPage = 0;
  late int _numberOfPage;
  Timer? _timerBeforeMarkChapterAsRead;
  bool _alreadyAskedMarkChapterAsRead = false;
  bool _loadedWithoutError = false;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _numberOfPage = 0;
    _chapterReadingCubit = ChapterReadingCubit(getPageUrls: getIt());
    _chapterReadingCubit.getPageUrls(
      chapterKey: widget.chapter?.key ?? '',
      mangaKey: widget.manga?.key ?? '',
    );
  }

  @override
  void dispose() {
    _chapterReadingCubit.close();
    _timerBeforeMarkChapterAsRead?.cancel();
    super.dispose();
  }

  Future<void> _markChapterAsRead({
    Duration durationBeforeAsk = AppConstants.durationBeforeAskChapterAsRead,
    bool popAfter = false,
  }) async {
    if (_loadedWithoutError &&
        !(widget.chapter?.isRead ?? true) &&
        !_alreadyAskedMarkChapterAsRead) {
      _timerBeforeMarkChapterAsRead = Timer(
        durationBeforeAsk,
        () async {
          if (mounted) {
            final bool needToMarkChapterAsRead =
                await InteractionHelper.showModal(
                      text: 'reading.considerChapterAsRead'.translateWithArgs(
                        args: <String>[widget.chapter?.number ?? ''],
                      ),
                      isDismissible: true,
                    ) ??
                    false;
            _alreadyAskedMarkChapterAsRead = true;
            if (needToMarkChapterAsRead) {
              BlocProvider.of<ChaptersCubit>(context).updateLastReadChapter(
                number: widget.chapter?.number ?? '',
              );
            }
            if (popAfter) Navigator.of(context).pop();
          }
        },
      );
    } else {
      if (popAfter) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChapterReadingCubit, ChapterReadingState>(
      bloc: _chapterReadingCubit,
      listener: (BuildContext context, ChapterReadingState state) {
        if (state is ChapterReadingLoaded) {
          setState(() {
            _currentPage = 1;
            _numberOfPage = state.pageUrls.length;
            _loadedWithoutError = true;
          });
        }
      },
      builder: (BuildContext context, ChapterReadingState state) {
        return Scaffold(
          appBar: AppBarWidget(
            title: widget.manga?.title ?? '',
            subTitle: widget.chapter?.number ?? '',
            onBackPressed: () {
              _timerBeforeMarkChapterAsRead?.cancel();
              _markChapterAsRead(
                durationBeforeAsk: Duration.zero,
                popAfter: true,
              );
            },
            actionsList: <Widget>[
              if (state is ChapterReadingLoaded)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      '$_currentPage / $_numberOfPage',
                      style: AppStyles.mediumTitle(
                        context,
                        color: AppColors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ChapterReadingState state) {
    if (state is ChapterReadingLoaded) {
      return PhotoViewGallery.builder(
        itemCount: state.pageUrls.length,
        loadingBuilder: (BuildContext context, ImageChunkEvent? event) {
          return const Center(
            child: LoadingWidget(),
          );
        },
        backgroundDecoration: const BoxDecoration(
          color: AppColors.white,
        ),
        onPageChanged: (int index) {
          _timerBeforeMarkChapterAsRead?.cancel();
          setState(() {
            _currentPage = index + 1;
          });
          if (index == _numberOfPage - 1) {
            _markChapterAsRead();
          }
        },
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(state.pageUrls[index]),
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return const Center(
                child: MessageWidget(message: ''),
              );
            },
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 4,
          );
        },
      );
    }
    if (state is ChapterReadingLoading) {
      return const LoadingWidget();
    }
    if (state is ChapterReadingError) {
      return Center(
        child: MessageWidget(
          message: 'error.${state.code}'.translate(),
        ),
      );
    }
    return const SizedBox();
  }
}

import 'dart:async';

import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/interaction_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:fangapp/core/widget/read_icon_widget.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/reading/presentation/cubit/chapter_reading_cubit.dart';
import 'package:fangapp/feature/reading/presentation/widgets/zoomable_image_widget.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../widgets/page_counter_widget.dart';

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

class _ChapterReadingPageState extends State<ChapterReadingPage>
    with TickerProviderStateMixin {
  late final ChapterReadingCubit _chapterReadingCubit;
  late LightChapterEntity? _chapter;
  int _currentPage = 0;
  late int _numberOfPage;

  late PhotoViewScaleStateController _scaleStateController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _chapter = widget.chapter;
    _currentPage = 0;
    _numberOfPage = 0;
    _chapterReadingCubit = ChapterReadingCubit(getPages: getIt());

    _scaleStateController = PhotoViewScaleStateController();

    _chapterReadingCubit.getPageUrls(
      chapterKey: _chapter?.key ?? '',
      mangaKey: widget.manga?.key ?? '',
    );

    _scaleStateController.outputScaleStateStream.listen((
      PhotoViewScaleState event,
    ) {
      print(event);
    });

    AnalyticsHelper().sendViewPageEvent(
      path: '${RouteConstants.routeChapterReading}/${_chapter?.key}',
    );
  }

  void initTabController() {
    _tabController = TabController(
      vsync: this,
      length: _numberOfPage,
    );
    _tabController.addListener(() {
      setState(() {
        _currentPage = _tabController.index + 1;
        if (_tabController.index == _numberOfPage - 1) {
          Timer(
            300.milliseconds,
                () => _markChapterAsRead(
              fromLastPage: true,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _chapterReadingCubit.close();
    super.dispose();
  }

  Future<void> _markChapterAsRead({bool fromLastPage = false}) async {
    if (!(_chapter?.isRead ?? false)) {
      AnalyticsHelper().sendChapterRead(
        readLastPage: fromLastPage,
        mangaKey: widget.manga?.key ?? '',
        chapterKey: _chapter?.key ?? '',
      );
      BlocProvider.of<ChaptersCubit>(context).updateLastReadChapter(
        number: _chapter?.number ?? '',
      );
    }
  }

  Future<void> _askMarkChapterAsRead() async {
    if (!(_chapter?.isRead ?? false)) {
      final bool needToMarkChapterAsRead = await InteractionHelper.showModal(
            text: 'reading.considerChapterAsRead'.translateWithArgs(
              args: <String>[widget.chapter?.number ?? ''],
            ),
            isDismissible: true,
          ) ??
          false;
      if (needToMarkChapterAsRead) {
        _markChapterAsRead();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<ChapterReadingCubit, ChapterReadingState>(
          bloc: _chapterReadingCubit,
          listener: (BuildContext context, ChapterReadingState state) {
            if (state is ChapterReadingLoaded) {
              setState(() {
                _currentPage = 1;
                _numberOfPage = state.pageUrls.length;
              });
              initTabController();
            }
          },
        ),
        BlocListener<ChaptersCubit, ChaptersState>(
          listener: (BuildContext context, ChaptersState state) {
            if (state is ChaptersLoaded) {
              setState(() {
                _chapter = state.findChapter(_chapter!);
              });
            }
          },
        )
      ],
      child: BlocBuilder<ChapterReadingCubit, ChapterReadingState>(
        bloc: _chapterReadingCubit,
        builder: (BuildContext context, ChapterReadingState state) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBarWidget(
                title: widget.manga?.title ?? '',
                subTitle: _chapter?.number ?? '',
                actionsList: state is ChapterReadingLoaded
                    ? <Widget>[
                        PageCounterWidget(
                          currentPage: _currentPage,
                          numberOfPage: _numberOfPage,
                        ),
                        ReadIconWidget(
                          isRead: _chapter?.isRead ?? false,
                          onPress: () {
                            _askMarkChapterAsRead();
                          },
                        ),
                      ]
                    : <Widget>[],
              ),
              body: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(ChapterReadingState state) {
    if (state is ChapterReadingLoaded) {
      return TabBarView(
        controller: _tabController,
        children: state.pageUrls
            .map(
              (String url) => ZoomableImageWidget(
                url: url,
                scaleStateController: _scaleStateController,
              ),
            )
            .toList(),
      );
      return ZoomableImageWidget(
        url: state.pageUrls.first,
        scaleStateController: _scaleStateController,
      );
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
          setState(() {
            _currentPage = index + 1;
            if (index == _numberOfPage - 1) {
              Timer(
                300.milliseconds,
                () => _markChapterAsRead(
                  fromLastPage: true,
                ),
              );
            }
          });
        },
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(state.pageUrls[index]),
            scaleStateController: _scaleStateController,
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return const Center(
                child: MessageWidget(),
              );
            },
            initialScale: PhotoViewComputedScale.contained * 0.9999,
            minScale: PhotoViewComputedScale.contained * 0.9999,
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

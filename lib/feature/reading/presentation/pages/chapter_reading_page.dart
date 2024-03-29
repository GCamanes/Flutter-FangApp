import 'dart:async';

import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/utils/interaction_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:fangapp/core/widget/read_icon_widget.dart';
import 'package:fangapp/feature/chapters/domain/entities/light_chapter_entity.dart';
import 'package:fangapp/feature/chapters/presentation/cubit/chapters_cubit.dart';
import 'package:fangapp/feature/mangas/domain/entities/manga_entity.dart';
import 'package:fangapp/feature/reading/presentation/cubit/chapter_reading_cubit.dart';
import 'package:fangapp/feature/reading/presentation/widgets/reading_button_widget.dart';
import 'package:fangapp/feature/reading/presentation/widgets/zoomable_image_widget.dart';
import 'package:fangapp/get_it_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:photo_view/photo_view.dart';

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
  int _currentPageIndex = 0;
  late int _numberOfPage;

  late PhotoViewScaleStateController _scaleStateController;
  late TabController _tabController;
  bool _tabScrollEnabled = true;
  bool _navigateButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _chapter = widget.chapter;
    _currentPageIndex = 0;
    _numberOfPage = 0;
    _chapterReadingCubit = ChapterReadingCubit(getPages: getIt());

    // Manage scroll physics with image zoom
    _scaleStateController = PhotoViewScaleStateController();
    _scaleStateController.outputScaleStateStream.listen(_handleImageZoomed);

    _chapterReadingCubit.getPageUrls(
      chapterKey: _chapter?.key ?? '',
      mangaKey: widget.manga?.key ?? '',
    );

    AnalyticsHelper().sendViewPageEvent(
      path: '${RouteConstants.routeChapterReading}/${_chapter?.key}',
    );
  }

  void _handleImageScrolled() {
    setState(() {
      _currentPageIndex = _tabController.index;
      if (_tabController.index == _numberOfPage - 1) {
        Timer(
          200.milliseconds,
          () => _markChapterAsRead(
            fromLastPage: true,
          ),
        );
      }
    });
  }

  void _initTabController() {
    _tabController = TabController(
      vsync: this,
      length: _numberOfPage,
    );
    _tabController.addListener(_handleImageScrolled);
  }

  void _handleImageZoomed(PhotoViewScaleState event) {
    setState(() {
      // Disable scroll when image is zoomed
      _tabScrollEnabled = event == PhotoViewScaleState.initial;
    });
  }

  void _navigateTo({bool isForward = true}) {
    late int nextIndex;
    if (isForward) {
      nextIndex = _currentPageIndex + 10 > _numberOfPage - 1
          ? _numberOfPage - 1
          : _currentPageIndex + 10;
    } else {
      nextIndex = _currentPageIndex - 10 < 0 ? 0 : _currentPageIndex - 10;
    }
    setState(() {
      _navigateButtonEnabled = false;
    });
    _tabController.animateTo(
      nextIndex,
      duration: AppConstants.animReadingNavDuration,
    );
    Timer(
      AppConstants.animReadingLoadDuration,
      () => setState(() {
        _navigateButtonEnabled = true;
      }),
    );
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
  void dispose() {
    _chapterReadingCubit.close();
    _tabController.removeListener(_handleImageScrolled);
    _tabController.dispose();
    _scaleStateController.dispose();
    super.dispose();
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
                _numberOfPage = state.pageUrls.length;
              });
              _initTabController();
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
                          currentPage: _currentPageIndex + 1,
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
      return Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            physics: _tabScrollEnabled
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            children: List<ZoomableImageWidget>.generate(
              state.pageUrls.length,
              (int index) => ZoomableImageWidget(
                url: state.pageUrls[index],
                index: index,
                currentIndex: _currentPageIndex,
                scaleStateController: _scaleStateController,
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: ReadingButtonWidget(
              isForward: false,
              show: _tabScrollEnabled,
              onPressed: _tabScrollEnabled && _navigateButtonEnabled
                  ? () => _navigateTo(isForward: false)
                  : null,
            ),
          ),
          Positioned(
            right: 0,
            child: ReadingButtonWidget(
              show: _tabScrollEnabled,
              onPressed: _tabScrollEnabled && _navigateButtonEnabled
                  ? () => _navigateTo()
                  : null,
            ),
          ),
        ],
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

import 'dart:async';

import 'package:fangapp/core/storage/presentation/cubit/storage_image_cubit.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../get_it_injection.dart';

class ZoomableImageWidget extends StatefulWidget {
  const ZoomableImageWidget({
    Key? key,
    required this.url,
    required this.index,
    required this.currentIndex,
    required this.scaleStateController,
  }) : super(key: key);

  final String url;
  final int index;
  final int currentIndex;
  final PhotoViewScaleStateController scaleStateController;

  @override
  _ZoomableImageWidgetState createState() => _ZoomableImageWidgetState();
}

class _ZoomableImageWidgetState extends State<ZoomableImageWidget> {
  final StorageImageCubit _storageImageCubit =
      StorageImageCubit(getStorageImageUrl: getIt());

  bool _imageLoaded = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _loadImage();
    });
  }

  @override
  void didUpdateWidget(covariant ZoomableImageWidget oldWidget) {
    _loadImage();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _storageImageCubit.close();
    _timer?.cancel();
    super.dispose();
  }

  void _loadImage() {
    _timer?.cancel();
    if (!_imageLoaded && widget.index == widget.currentIndex) {
      _timer = Timer(
        const Duration(milliseconds: 250),
        () => _storageImageCubit.getStorageImageUrl(url: widget.url),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageImageCubit, StorageImageState>(
      bloc: _storageImageCubit,
      builder: (BuildContext context, StorageImageState state) {
        if (state is StorageImageLoaded) {
          _imageLoaded = true;
          return PhotoView(
            backgroundDecoration: const BoxDecoration(
              color: AppColors.white,
            ),
            imageProvider: NetworkImage(state.imageUrl),
            scaleStateController: widget.scaleStateController,
            loadingBuilder: (
              BuildContext context,
              ImageChunkEvent? event,
            ) {
              return const LoadingWidget();
            },
            errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return const Center(
                child: MessageWidget(),
              );
            },
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 4,
          );
        } else if (state is StorageImageError) {
          return const Center(
            child: MessageWidget(),
          );
        }
        return const LoadingWidget();
      },
    );
  }
}

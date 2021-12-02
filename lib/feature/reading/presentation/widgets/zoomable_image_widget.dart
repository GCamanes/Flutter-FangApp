import 'package:fangapp/core/storage/presentation/cubit/storage_image_cubit.dart';
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
    required this.scaleStateController,
  }) : super(key: key);

  final String url;
  final PhotoViewScaleStateController scaleStateController;

  @override
  _ZoomableImageWidgetState createState() => _ZoomableImageWidgetState();
}

class _ZoomableImageWidgetState extends State<ZoomableImageWidget> {
  final StorageImageCubit _storageImageCubit =
      StorageImageCubit(getStorageImageUrl: getIt());

  @override
  void initState() {
    super.initState();
    _storageImageCubit.getStorageImageUrl(url: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageImageCubit, StorageImageState>(
      bloc: _storageImageCubit,
      builder: (BuildContext context, StorageImageState state) {
        if (state is StorageImageLoading) {
          return const LoadingWidget();
        } else if (state is StorageImageLoaded) {
          return PhotoView(
            imageProvider: NetworkImage(state.imageUrl),
            scaleStateController: widget.scaleStateController,
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
        } else if (state is StorageImageError) {
          return const MessageWidget();
        }
        return const SizedBox();
      },
    );
  }
}

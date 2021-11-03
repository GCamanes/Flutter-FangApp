import 'dart:async';

import 'package:flutter/material.dart';

abstract class ImageInfoHelper {
  static Future<ImageInfo> getImageInfo(
    BuildContext context,
    String assetName,
  ) async {
    final AssetImage assetImage = AssetImage(assetName);
    final ImageStream stream = assetImage.resolve(
      createLocalImageConfiguration(context),
    );
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    stream.addListener(
      ImageStreamListener((ImageInfo imageInfo, _) {
        return completer.complete(imageInfo);
      }),
    );
    return completer.future;
  }
}

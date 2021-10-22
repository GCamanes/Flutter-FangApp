import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/bonus/presentation/animation/sunny/sunny_particle_entity.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/timeline_tween/timeline_tween.dart';

class SunnyPainter extends CustomPainter {
  SunnyPainter({
    required this.particle,
    required this.sunnyImageInfo,
    required this.backgroundImageInfo,
    required this.waveImageInfo,
  });

  SunnyParticleEntity particle;
  ImageInfo sunnyImageInfo;
  ImageInfo backgroundImageInfo;
  ImageInfo waveImageInfo;

  void rotate({
    required Canvas canvas,
    required double cx,
    required double cy,
    required double angle,
  }) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double progress = particle.progress();
    final TimelineValue<AnimationEnum> animation =
        particle.particleTween.transform(progress);

    // Draw grey background
    final Paint greyBrush = Paint()..color = AppColors.greyLight;
    final Paint blueBrush = Paint()..color = AppColors.blueDark;

    final double backgroundHeight = size.height;
    final double backgroundWidth = size.width;

    final double backgroundImageRatio =
        backgroundImageInfo.image.height / backgroundImageInfo.image.width;
    final double backgroundImageHeight = backgroundWidth * backgroundImageRatio;
    final double backgroundImageTop =
        backgroundHeight / 2 - backgroundImageHeight / 2;
    final double backgroundImageBottom =
        backgroundHeight / 2 + backgroundImageHeight / 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, backgroundWidth, backgroundHeight),
      greyBrush,
    );

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        0,
        backgroundImageTop,
        backgroundWidth,
        backgroundImageHeight,
      ),
      image: backgroundImageInfo.image,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        backgroundImageBottom - 2,
        backgroundWidth,
        backgroundImageTop + 2,
      ),
      blueBrush,
    );

    // Draw sunny image with rotation
    canvas.save();
    final double angle =
        (animation.get(AnimationEnum.angle) as double) * 3.14 / 180;
    final Offset position = Offset(
      0.5 * size.width,
      (animation.get(AnimationEnum.y) as double) * size.height,
    );
    rotate(canvas: canvas, cx: position.dx, cy: position.dy, angle: -angle);
    final double imageSize = size.width * 0.4;
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        position.dx - imageSize / 2,
        position.dy - imageSize / 2,
        imageSize,
        imageSize,
      ),
      image: sunnyImageInfo.image,
    );
    rotate(canvas: canvas, cx: position.dx, cy: position.dy, angle: angle);
    canvas.restore();

    // Draw wave on sunny
    final double waveImageRatio =
        waveImageInfo.image.height / waveImageInfo.image.width;
    final double waveImageHeight = backgroundWidth * waveImageRatio;
    final double wavePositionY =
        (animation.get(AnimationEnum.y) as double) * 1.06 * size.height;
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        0,
        wavePositionY,
        backgroundWidth,
        waveImageHeight,
      ),
      image: waveImageInfo.image,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        wavePositionY + waveImageHeight - 2,
        backgroundWidth,
        size.height + 2 - (wavePositionY + waveImageHeight),
      ),
      blueBrush,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

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
  });

  SunnyParticleEntity particle;
  ImageInfo sunnyImageInfo;
  ImageInfo backgroundImageInfo;

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

    final double backgroundHeight = size.height - 20;
    final double backgroundWidth = size.width - 20;

    final double backgroundImageRatio =
        backgroundImageInfo.image.height / backgroundImageInfo.image.width;
    final double backgroundImageHeight = backgroundWidth * backgroundImageRatio;
    final double backgroundImageTop =
        backgroundHeight / 2 - backgroundImageHeight / 2;
    final double backgroundImageBottom =
        backgroundHeight / 2 + backgroundImageHeight / 2;

    canvas.drawRect(
      Rect.fromLTWH(10, 10, backgroundWidth, backgroundHeight),
      greyBrush,
    );

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        10,
        backgroundImageTop + 10,
        backgroundWidth,
        backgroundImageHeight,
      ),
      image: backgroundImageInfo.image,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        10,
        backgroundImageBottom + 5,
        backgroundWidth,
        backgroundImageTop + 5,
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
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

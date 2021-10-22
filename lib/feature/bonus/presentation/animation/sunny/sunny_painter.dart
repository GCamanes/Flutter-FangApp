import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/feature/bonus/presentation/animation/sunny/sunny_particle_entity.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/timeline_tween/timeline_tween.dart';

class SunnyPainter extends CustomPainter {
  SunnyPainter(this.particle, this.imageInfo);

  SunnyParticleEntity particle;
  ImageInfo imageInfo;

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
    final Offset position = Offset(
      0.5 * size.width,
      (animation.get(AnimationEnum.y) as double) * size.height,
    );

    final double imageSize = size.width * 0.4;

    double angle = (animation.get(AnimationEnum.angle) as double) * 3.14 / 180;

    Paint greenBrush = Paint()..color = AppColors.greyLight;
    canvas.drawRect(
        Rect.fromLTWH(10, 10, size.width - 20, size.height - 20), greenBrush);
    canvas.save();
    rotate(canvas: canvas, cx: position.dx, cy: position.dy, angle: -angle);

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        position.dx - imageSize / 2,
        position.dy - imageSize / 2,
        imageSize,
        imageSize,
      ),
      image: imageInfo.image,
    );

    rotate(canvas: canvas, cx: position.dx, cy: position.dy, angle: angle);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

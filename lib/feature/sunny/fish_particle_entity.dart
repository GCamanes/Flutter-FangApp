import 'dart:math';
import 'dart:ui';

import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:fangapp/feature/bonus/presentation/animation/particle_entity.dart';
import 'package:flutter/animation.dart';
import 'package:simple_animations/simple_animations.dart';

class FishParticleEntity extends ParticleEntity {
  FishParticleEntity({
    required Random random,
  }) : super(random: random, randomInitProgress: true);

  @override
  void initTween() {
    // Get random (x, y) offset for start and end of animation
    final Offset startPosition = Offset(1.15, 0.95 - 0.2 * random.nextDouble());
    final Offset endPosition = Offset(-0.15, 0.95 - 0.2 * random.nextDouble());

    animDuration = Duration(milliseconds: 3000 + random.nextInt(3000));

    tween = TimelineTween<AnimationEnum>()
      ..addScene(begin: Duration.zero, duration: animDuration).animate(
        AnimationEnum.x,
        tween: Tween<double>(begin: startPosition.dx, end: endPosition.dx),
        curve: Curves.linear,
      )
      ..addScene(begin: Duration.zero, duration: animDuration).animate(
        AnimationEnum.y,
        tween: Tween<double>(begin: startPosition.dy, end: endPosition.dy),
        curve: Curves.easeIn,
      );
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:flutter/animation.dart';
import 'package:simple_animations/simple_animations.dart';

import '../particle_entity.dart';

class SunnyParticleEntity extends ParticleEntity {
  SunnyParticleEntity({
    required Random random,
  }) : super(random: random);

  @override
  void initTween() {
    // Get random (x, y) offset for start and end of animation
    const Offset startPosition = Offset(0.5, 0.3);
    const Offset endPosition = Offset(0.5, 0.7);

    tween = TimelineTween<AnimationEnum>()
      // here
      ..addScene(begin: Duration.zero, duration: animDuration ~/ 2).animate(
        AnimationEnum.y,
        tween: Tween<double>(begin: startPosition.dy, end: endPosition.dy),
        curve: Curves.linear,
      )..addScene(begin: animDuration ~/ 2, duration: animDuration).animate(
        AnimationEnum.y,
        tween: Tween<double>(begin: endPosition.dy, end: startPosition.dy),
        curve: Curves.easeOut,
      )..addScene(begin: Duration.zero, duration: animDuration ~/ 2).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: -25, end: 25),
        curve: Curves.linear,
      )..addScene(begin: animDuration ~/ 2, duration: animDuration).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: 25, end:  -25),
        curve: Curves.easeOut,
      );
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:fangapp/feature/bonus/presentation/animation/particle_entity.dart';
import 'package:flutter/animation.dart';
import 'package:simple_animations/simple_animations.dart';


class SunnyParticleEntity extends ParticleEntity {
  SunnyParticleEntity({
    required Random random,
  }) : super(random: random);

  @override
  void initTween() {
    const Offset downPosition = Offset(0.5, 0.55);
    const Offset upPosition = Offset(0.5, 0.45);

    const double neutralAngle = 0;
    const double upAngle = -15;
    const double downAngle = 15;

    final Duration animationThird = animDuration ~/ 3;
    final Duration animationSixth = animDuration ~/ 6;

    final Duration animStep1 = animationSixth;
    final Duration animStep2 = animStep1 + animationThird;
    final Duration animStep3 = animStep2 + animationSixth;
    final Duration animStep4 = animStep3 + animationSixth;
    final Duration animStep5 = animStep4 + animationThird;
    final Duration animStep6 = animStep5 + animationSixth;

    tween = TimelineTween<AnimationEnum>()
      // y offset part
      ..addScene(begin: Duration.zero, duration: animDuration ~/ 2).animate(
        AnimationEnum.y,
        tween: Tween<double>(begin: downPosition.dy, end: upPosition.dy),
        curve: Curves.easeOut,
      )..addScene(begin: animDuration ~/ 2, duration: animDuration).animate(
        AnimationEnum.y,
        tween: Tween<double>(begin: upPosition.dy, end: downPosition.dy),
        curve: Curves.easeOut,
      )
      // Angle rotation part
      ..addScene(begin: Duration.zero, duration: animStep1).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: neutralAngle, end: upAngle),
        curve: Curves.linear,
      )..addScene(begin: animStep1, duration: animStep2 - animStep1).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: upAngle, end: neutralAngle),
        curve: Curves.linear,
      )..addScene(begin: animStep2, duration: animStep3 - animStep2).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: neutralAngle, end: downAngle),
        curve: Curves.linear,
      )..addScene(begin: animStep5, duration: animStep6 - animStep5).animate(
        AnimationEnum.angle,
        tween: Tween<double>(begin: downAngle, end: neutralAngle),
        curve: Curves.linear,
      );
  }
}

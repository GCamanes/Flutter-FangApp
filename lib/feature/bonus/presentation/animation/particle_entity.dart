import 'dart:math';

import 'package:fangapp/core/enum/animation_enum.dart';
import 'package:fangapp/core/extensions/date_extension.dart';

import 'package:simple_animations/simple_animations.dart';

// Class for generic particle behavior
abstract class ParticleEntity {
  ParticleEntity({
    required this.random,
    this.animDuration = const Duration(seconds: 3),
    bool randomInitProgress = true,
  }) {
    initProgress = randomInitProgress ? random.nextDouble() : 0.0;
    restart();
  }

  // Needed to randomize duration, size and path
  final Random random;

  Duration animDuration;

  // Tween define the path of the animation
  late TimelineTween<AnimationEnum> tween;
  late double size;

  // Needed to compute animation progress
  late Duration startTime;

  // First init progress
  late double initProgress;

  // Some getters used by painter
  TimelineTween<AnimationEnum> get particleTween => tween;

  double get particleSize => size;

  // This method must be override by all particle
  // The tween must be defined here
  void initTween();

  // Method to restart particle
  void restart({Duration time = Duration.zero}) {
    startTime = DateTime.now().duration;
    size = 0.2 + random.nextDouble() * 0.2;

    initTween();
  }

  // Method to compute progress of particle animation
  double progress() {
    final Duration now = DateTime.now().duration;
    return (((now.inMilliseconds - startTime.inMilliseconds) /
                animDuration.inMilliseconds) +
            initProgress)
        .clamp(0.0, 1.0);
  }

  // Method to control when particle need to be restarted
  void maintainRestart(Duration time) {
    if (progress() == 1.0) {
      // reset initProgress at first particle restart
      initProgress = 0.0;
      restart(time: time);
    }
  }
}

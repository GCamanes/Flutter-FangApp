import 'dart:async';
import 'dart:math';

import 'package:fangapp/core/extensions/date_extension.dart';
import 'package:fangapp/feature/bonus/presentation/animation/sunny/fish_particle_entity.dart';
import 'package:fangapp/feature/bonus/presentation/animation/sunny/sunny_painter.dart';
import 'package:fangapp/feature/bonus/presentation/animation/sunny/sunny_particle_entity.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/stateless_animation/loop_animation.dart';

class SunnyWidget extends StatefulWidget {
  const SunnyWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SunnyWidgetState createState() => _SunnyWidgetState();
}

class _SunnyWidgetState extends State<SunnyWidget> {
  late SunnyParticleEntity _sunnyParticle;
  late List<FishParticleEntity> _fishParticles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _sunnyParticle = SunnyParticleEntity(random: _random);
    _fishParticles = List<FishParticleEntity>.generate(5, (int index) {
      return FishParticleEntity(random: _random);
    });
    super.initState();
  }

  Future<ImageInfo> getImageInfo(BuildContext context, String assetName) async {
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

  void _simulateParticles(Duration time) {
    _sunnyParticle.maintainRestart(time);
    for (final FishParticleEntity fishParticle in _fishParticles) {
      fishParticle.maintainRestart(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: LoopAnimation<int>(
        tween: ConstantTween<int>(1), // Pass in tween
        builder: (BuildContext? context, Widget? child, int value) {
          _simulateParticles(DateTime.now().duration);
          return FutureBuilder<ImageInfo>(
            future: getImageInfo(
              context!,
              'assets/images/one_piece_sunny.png',
            ),
            builder:
                (BuildContext context, AsyncSnapshot<ImageInfo> snapshotSunny) {
              if (snapshotSunny.hasData) {
                return FutureBuilder<ImageInfo>(
                  future: getImageInfo(
                    context,
                    'assets/images/wave_background_sunny.png',
                  ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<ImageInfo> snapshotBackground,
                  ) {
                    if (snapshotBackground.hasData) {
                      return FutureBuilder<ImageInfo>(
                        future: getImageInfo(
                          context,
                          'assets/images/wave_sample.png',
                        ),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<ImageInfo> snapshotWave,
                        ) {
                          if (snapshotWave.hasData) {
                            return FutureBuilder<ImageInfo>(
                              future: getImageInfo(
                                context,
                                'assets/images/one_piece_prometheus.png',
                              ),
                              builder: (
                                BuildContext context,
                                AsyncSnapshot<ImageInfo> snapshotSun,
                              ) {
                                if (snapshotSun.hasData) {
                                  return FutureBuilder<ImageInfo>(
                                    future: getImageInfo(
                                      context,
                                      'assets/images/one_piece_fish.png',
                                    ),
                                    builder: (
                                      BuildContext context,
                                      AsyncSnapshot<ImageInfo> snapshotFish,
                                    ) {
                                      if (snapshotFish.hasData) {
                                        return CustomPaint(
                                          painter: SunnyPainter(
                                            sunnyParticle: _sunnyParticle,
                                            sunnyImageInfo: snapshotSunny.data!,
                                            backgroundImageInfo:
                                                snapshotBackground.data!,
                                            waveImageInfo: snapshotWave.data!,
                                            sunImageInfo: snapshotSun.data!,
                                            fishParticles: _fishParticles,
                                            fishImageInfo: snapshotFish.data!,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  );
                                }
                                return const SizedBox();
                              },
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    }
                    return const SizedBox();
                  },
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}

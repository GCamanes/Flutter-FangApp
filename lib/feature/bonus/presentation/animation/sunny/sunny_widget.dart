import 'dart:async';
import 'dart:math';

import 'package:fangapp/core/extensions/date_extension.dart';
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
  late SunnyParticleEntity _particle;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _particle = SunnyParticleEntity(random: _random);
    super.initState();
  }

  Future<ImageInfo> getImageInfo(BuildContext context) async {
    const AssetImage assetImage = AssetImage(
      'assets/images/one_piece_sunny.png',
    );
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
    _particle.maintainRestart(time);
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
            future: getImageInfo(context!),
            builder: (BuildContext context, AsyncSnapshot<ImageInfo> snapshot) {
              if (snapshot.hasData) {
                return CustomPaint(
                  painter: SunnyPainter(_particle, snapshot.data!),
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

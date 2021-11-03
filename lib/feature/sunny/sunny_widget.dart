import 'dart:async';
import 'dart:math';

import 'package:fangapp/core/extensions/date_extension.dart';
import 'package:fangapp/core/utils/image_info_helper.dart';
import 'package:fangapp/feature/sunny/sunny_painter.dart';
import 'package:fangapp/feature/sunny/sunny_particle_entity.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/stateless_animation/loop_animation.dart';

import 'fish_particle_entity.dart';

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

  late ImageInfo? _sunnyImageInfo;
  late ImageInfo? _backgroundImageInfo;
  late ImageInfo? _waveImageInfo;
  late ImageInfo? _prometheusImageInfo;
  late ImageInfo? _fishImageInfo;
  bool _allImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _sunnyParticle = SunnyParticleEntity(random: _random);
    _fishParticles = List<FishParticleEntity>.generate(5, (int index) {
      return FishParticleEntity(random: _random);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImageInfo();
  }

  Future<void> _loadImageInfo() async {
    _sunnyImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/one_piece_sunny.png',
    );
    _backgroundImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/wave_background_sunny.png',
    );
    _waveImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/wave_sample.png',
    );
    _prometheusImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/one_piece_prometheus.png',
    );
    _fishImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/one_piece_fish.png',
    );
    setState(() {
      _allImageLoaded = true;
    });
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
          if (_allImageLoaded) {
            return CustomPaint(
              painter: SunnyPainter(
                sunnyParticle: _sunnyParticle,
                sunnyImageInfo: _sunnyImageInfo!,
                backgroundImageInfo: _backgroundImageInfo!,
                waveImageInfo: _waveImageInfo!,
                sunImageInfo: _prometheusImageInfo!,
                fishParticles: _fishParticles,
                fishImageInfo: _fishImageInfo!,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

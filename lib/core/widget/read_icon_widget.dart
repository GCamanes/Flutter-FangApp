import 'dart:async';

import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

const double minIconSize = 30;
const double maxIconSize = 35;
const double deltaIconSize = maxIconSize - minIconSize;

const Duration forwardDuration = Duration(milliseconds: 300);
const Duration reverseDuration = Duration(milliseconds: 200);

class ReadIconWidget extends StatefulWidget {
  const ReadIconWidget({
    Key? key,
    required this.onPress,
    this.isRead = false,
  }) : super(key: key);

  final Function() onPress;
  final bool isRead;

  @override
  _ReadIconWidgetState createState() => _ReadIconWidgetState();
}

class _ReadIconWidgetState extends State<ReadIconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: forwardDuration,
      reverseDuration: reverseDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    final Tween<double> sizeTween = Tween<double>(
      begin: 0,
      end: deltaIconSize,
    );

    _sizeAnimation = sizeTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    )..addStatusListener((AnimationStatus status) async {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          _controller.reverse();
        }
      }
    });

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant ReadIconWidget oldWidget) {
    if (oldWidget.isRead != widget.isRead) startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return IconButton(
          onPressed: widget.onPress,
          iconSize: maxIconSize,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Center(
            child: Icon(
              widget.isRead
                  ? Icons.bookmark_added_outlined
                  : Icons.bookmark_add_outlined,
              color: widget.isRead ? AppColors.orange : AppColors.white,
              size: minIconSize + (_sizeAnimation?.value ?? 0),
            ),
          ),
        );
      },
    );
  }
}

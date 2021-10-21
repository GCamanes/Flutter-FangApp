import 'dart:async';

import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 300.milliseconds,
      reverseDuration: 200.milliseconds,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (mounted) {
      _controller.forward();
      Timer(
        300.milliseconds,
            () => _controller.reverse(),
      );
    }
  }

  @override
  void didUpdateWidget(covariant ReadIconWidget oldWidget) {
    startAnimation();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return IconButton(
          onPressed: widget.onPress,
          iconSize: 30 + _controller.value * 5,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            widget.isRead
                ? Icons.bookmark_added_outlined
                : Icons.bookmark_add_outlined,
            color: widget.isRead ? AppColors.orange : AppColors.white,
            size: 30 + _controller.value * 5,
          ),
        );
      },
    );
  }
}

import 'dart:math' as math;
import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ReloadIconWidget extends StatefulWidget {
  const ReloadIconWidget({
    Key? key,
    this.onPress,
  }) : super(key: key);

  final Function()? onPress;

  @override
  _ReloadIconWidgetState createState() => _ReloadIconWidgetState();
}

class _ReloadIconWidgetState extends State<ReloadIconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 1.seconds,
      reverseDuration: 500.milliseconds,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ReloadIconWidget oldWidget) {
    if (widget.onPress == null) {
      _controller.repeat();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Transform.rotate(
          angle: -_controller.value * 2 * math.pi,
          child: child,
        );
      },
      child: IconButton(
        onPressed: widget.onPress,
        iconSize: 30,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.sync,
          color:
              widget.onPress == null ? AppColors.orange : AppColors.blueLight,
          size: 30,
        ),
      ),
    );
  }
}

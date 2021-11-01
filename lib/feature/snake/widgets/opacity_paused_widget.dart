import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

class OpacityPausedWidget extends StatefulWidget {
  const OpacityPausedWidget({
    Key? key,
    this.opacity = 0.5,
    this.topPadding = 0,
  }) : super(key: key);

  final double opacity;
  final double topPadding;

  @override
  _OpacityPausedWidgetState createState() => _OpacityPausedWidgetState();
}

class _OpacityPausedWidgetState extends State<OpacityPausedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 500.milliseconds,
      reverseDuration: 500.milliseconds,
    );

    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, -widget.topPadding * 0.9),
    );

    _offsetAnimation = offsetTween.animate(
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
      if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    if (mounted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding),
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: Opacity(
              opacity: widget.opacity,
              child: Container(
                color: AppColors.black90,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 20,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) {
                return Transform.translate(
                  offset: _offsetAnimation.value,
                  child: child,
                );
              },
              child: const Icon(
                Icons.arrow_upward,
                color: AppColors.white,
                size: 30,
              ),
            ),
          ),
          Center(
            child: Text(
              'common.paused'.translate(),
              style: AppStyles.highTitle(color: AppColors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

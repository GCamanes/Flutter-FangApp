import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';

const double minTextSize = 40;
const double maxTextSize = 60;
const double deltaTextSize = maxTextSize - minTextSize;

class OpacityStartingWidget extends StatefulWidget {
  const OpacityStartingWidget({
    Key? key,
    this.opacity = 0.5,
    this.topPadding = 0,
    required this.onCountDownEnd,
  }) : super(key: key);

  final double opacity;
  final double topPadding;
  final Function() onCountDownEnd;

  @override
  _OpacityStartingWidgetState createState() => _OpacityStartingWidgetState();
}

class _OpacityStartingWidgetState extends State<OpacityStartingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _sizeAnimation;
  int timerValue = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 500.milliseconds,
      reverseDuration: 500.milliseconds,
    );

    final Tween<double> sizeTween = Tween<double>(
      begin: minTextSize,
      end: maxTextSize,
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
        if (status == AnimationStatus.dismissed) {
          if (timerValue == 1) {
            widget.onCountDownEnd();
          } else {
            setState(() {
              timerValue -= 1;
            });
            _controller.forward();
          }
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
          AnimatedBuilder(
            animation: _controller,
            builder: (_, Widget? child) {
              return Center(
                child: Text(
                  timerValue.toString(),
                  style: AppStyles.highTitle(
                    color: AppColors.white,
                    size: _sizeAnimation.value,
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

import 'package:fangapp/core/data/app_constants.dart';
import 'package:flutter/material.dart';

class CrossFadeWidget extends StatefulWidget {
  const CrossFadeWidget({
    Key? key,
    this.backgroundColor = Colors.transparent,
    this.animationDuration = AppConstants.animDefaultDuration,
    this.showSecondWidget = false,
    this.borderRadius,
    required this.firstWidget,
    required this.secondWidget,
  }) : super(key: key);

  final Color backgroundColor;
  final Duration animationDuration;
  final bool showSecondWidget;
  final BorderRadius? borderRadius;
  final Widget firstWidget;
  final Widget secondWidget;

  @override
  _BottomSheetCrossFade createState() => _BottomSheetCrossFade();
}

class _BottomSheetCrossFade extends State<CrossFadeWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      duration: widget.animationDuration,
      child: AnimatedCrossFade(
        firstChild: widget.firstWidget,
        secondChild: widget.secondWidget,
        crossFadeState: widget.showSecondWidget
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: widget.animationDuration,
      ),
    );
  }
}

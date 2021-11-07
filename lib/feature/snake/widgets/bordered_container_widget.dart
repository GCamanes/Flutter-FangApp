import 'package:flutter/material.dart';

class BorderedContainerWidget extends StatelessWidget {
  const BorderedContainerWidget({
    Key? key,
    this.child,
    this.color = Colors.transparent,
    this.height = double.infinity,
    this.width = double.infinity,
    this.borderWidth = 0,
    this.borderRadius = 0,
    this.borderColor = Colors.transparent,
    this.allBorder = false,
    this.bottomBorder = false,
    this.leftBorder = false,
    this.rightBorder = false,
    this.topBorder = false,
  }) : super(key: key);

  final Widget? child;
  final Color color;
  final double height;
  final double width;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;

  final bool allBorder;
  final bool bottomBorder;
  final bool leftBorder;
  final bool rightBorder;
  final bool topBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border(
          bottom: BorderSide(
            width: borderWidth,
            color: allBorder || bottomBorder ? borderColor : Colors.transparent,
          ),
          left: BorderSide(
            width: borderWidth,
            color: allBorder || leftBorder ? borderColor : Colors.transparent,
          ),
          right: BorderSide(
            width: borderWidth,
            color: allBorder || rightBorder ? borderColor : Colors.transparent,
          ),
          top: BorderSide(
            width: borderWidth,
            color: allBorder || topBorder ? borderColor : Colors.transparent,
          ),
        ),
      ),
      child: child,
    );
  }
}

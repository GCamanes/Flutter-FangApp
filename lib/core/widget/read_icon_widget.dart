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
      duration: 1.seconds,
      reverseDuration: 1.seconds,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ReadIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Transform.rotate(
          angle: 0,
          child: child,
        );
      },
      child: IconButton(
        onPressed: widget.onPress,
        iconSize: 30,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          widget.isRead
              ? Icons.bookmark_added_outlined
              : Icons.bookmark_add_outlined,
          color: widget.isRead ? AppColors.orange : AppColors.white,
          size: 30,
        ),
      ),
    );
  }
}

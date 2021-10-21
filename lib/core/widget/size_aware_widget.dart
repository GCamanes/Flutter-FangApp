import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SizeAwareWidget extends StatefulWidget {
  const SizeAwareWidget({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final Function onChange;

  @override
  _SizeAwareWidgetState createState() => _SizeAwareWidgetState();
}

class _SizeAwareWidgetState extends State<SizeAwareWidget> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback(postFrameCallback);
    return Container(
      key: _widgetKey,
      child: widget.child,
    );
  }

  final GlobalKey _widgetKey = GlobalKey();
  Size _oldSize = Size.zero;

  void postFrameCallback(_) {
    final BuildContext? context = _widgetKey.currentContext;
    if (context == null) return;

    final Size newSize = context.size!;
    if (_oldSize == newSize) return;

    _oldSize = newSize;
    widget.onChange(newSize);
  }
}

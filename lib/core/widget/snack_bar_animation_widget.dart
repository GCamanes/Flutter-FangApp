import 'package:fangapp/core/enum/status_enum.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:flutter/material.dart';

/// Widget that controls all animations
class TopSnackBar extends StatefulWidget {
  const TopSnackBar({
    Key? key,
    required this.text,
    this.status = StatusEnum.error,
    this.showOutAnimationDuration = const Duration(milliseconds: 1500),
    this.hideOutAnimationDuration = const Duration(seconds: 1),
    this.displayDuration = const Duration(seconds: 2),
    required this.onDismissed,
  }) : super(key: key);

  final String text;
  final StatusEnum status;
  final Duration showOutAnimationDuration;
  final Duration hideOutAnimationDuration;
  final Duration displayDuration;
  final VoidCallback onDismissed;

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> offsetAnimation;
  late AnimationController animationController;
  double? topPosition;

  @override
  void initState() {
    // To show snack bar under app bar
    topPosition = AppBarWidget.appBarHeight;
    // Init and run animation
    _setupAndStartAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  String getStatusImagePath(StatusEnum status) {
    switch (status) {
      case StatusEnum.success:
        return 'assets/images/app_luffy_success_250x250.png';
      default:
        return 'assets/images/app_luffy_error_250x250.png';
    }
  }

  Future<void> _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    // This tween allow to compute the animated offset
    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    );

    // Setting of the animation
    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    )..addStatusListener((AnimationStatus status) async {
        if (status == AnimationStatus.completed) {
          // Wait before reverse animation
          await Future<void>.delayed(widget.displayDuration);
          if (mounted) {
            animationController.reverse();
            // Create a little transition inside animation
            setState(() {
              topPosition = 0;
            });
          }
        }
        if (status == AnimationStatus.dismissed) {
          widget.onDismissed.call();
        }
      });

    if (mounted) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: widget.hideOutAnimationDuration,
      curve: Curves.linearToEaseOut,
      top: topPosition,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: offsetAnimation,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blackSmoke,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: widget.status == StatusEnum.error
                    ? AppColors.orange
                    : AppColors.blueLight,
              ),
            ),
            child: Row(
              children: <Widget>[
                Image.asset(getStatusImagePath(widget.status), width: 60),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.text,
                    style:
                        AppStyles.regularText(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

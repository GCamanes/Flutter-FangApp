import 'package:fangapp/core/enum/status_enum.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/widget/snack_bar_animation_widget.dart';
import 'package:flutter/material.dart';

abstract class SnackBarHelper {
  static OverlayEntry? _previousEntry;

  static void showSnackBar({
    required String text,
    StatusEnum status = StatusEnum.success,
  }) {
    // Create overlay to show
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => TopSnackBar(
        text: text,
        status: status,
        onDismissed: () {
          overlayEntry.remove();
          _previousEntry = null;
        },
      ),
    );

    // First remove previous overlay entry
    _previousEntry?.remove();
    // Getting overlay from global navigation key
    final OverlayState overlay =
        RoutesManager.globalNavKey.currentState!.overlay!;
    // Show new overlay entry
    overlay.insert(overlayEntry);
    // Save new overlay entry
    _previousEntry = overlayEntry;
  }
}

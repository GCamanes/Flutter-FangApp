import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:flutter/material.dart';

class TrackingWidget extends StatefulWidget {
  const TrackingWidget({Key? key}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget> {
  late bool _isTrackingOn;

  @override
  void initState() {
    super.initState();
    _isTrackingOn = AppHelper().trackingOn ?? false;
  }

  Future<void> _updateTracking(bool value) async {
    final bool newIsTracking = await AppHelper().updateTracking(
      tracking: value,
    );
    setState(() {
      _isTrackingOn = newIsTracking;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'tracking.title'.translate(),
          style: AppStyles.mediumTitle(
            color: AppColors.blackSmokeDark,
          ),
        ),
        const SizedBox(height: 20),
        Switch(
          value: _isTrackingOn,
          onChanged: (bool value) => _updateTracking(value),
          activeColor: AppColors.orange,
        ),
      ],
    );
  }
}

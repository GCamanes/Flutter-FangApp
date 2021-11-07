import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/feature/sunny/sunny_widget.dart';
import 'package:flutter/material.dart';

class BonusSunnyPage extends StatefulWidget {
  const BonusSunnyPage({Key? key}) : super(key: key);

  @override
  _BonusSunnyPageState createState() => _BonusSunnyPageState();
}

class _BonusSunnyPageState extends State<BonusSunnyPage> {
  @override
  void initState() {
    super.initState();
    AnalyticsHelper().sendViewPageEvent(path: RouteConstants.routeBonusSunny);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: 'Sunny',
      ),
      body: SunnyWidget(),
    );
  }
}

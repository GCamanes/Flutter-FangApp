import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/feature/snake/snake_game_widget.dart';
import 'package:flutter/material.dart';

class BonusSnakePage extends StatefulWidget {
  const BonusSnakePage({Key? key}) : super(key: key);

  @override
  _BonusSnakePageState createState() => _BonusSnakePageState();
}

class _BonusSnakePageState extends State<BonusSnakePage> {
  @override
  void initState() {
    super.initState();
    AnalyticsHelper().sendViewPageEvent(path: RouteConstants.routeBonusSnake);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black90,
      appBar: AppBarWidget(
        title: 'Snake',
      ),
      body: SnakeGameWidget(),
    );
  }
}

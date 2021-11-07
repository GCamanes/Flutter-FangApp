import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/navigation/routes.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/feature/bonus/presentation/widgets/tile_button_widget.dart';
import 'package:flutter/material.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({Key? key}) : super(key: key);

  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  late List<Widget> _tiles;

  @override
  void initState() {
    super.initState();
    _tiles = <Widget>[
      TileButtonWidget(
        title: 'Snake',
        onPressed: () async {
          final dynamic backPressed = await RoutesManager.pushNamed(
            context: context,
            pageRouteName: RouteConstants.routeBonusSnake,
            fullScreen: true,
          );
          if (backPressed != null) {
            AnalyticsHelper()
                .sendViewPageEvent(path: RouteConstants.routeBonus);
          }
        },
      ),
      TileButtonWidget(
        title: 'Sunny',
        onPressed: () async {
          final dynamic backPressed = await RoutesManager.pushNamed(
            context: context,
            pageRouteName: RouteConstants.routeBonusSunny,
            fullScreen: true,
          );
          if (backPressed != null) {
            AnalyticsHelper()
                .sendViewPageEvent(path: RouteConstants.routeBonus);
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'bottomBar.bonus'.translate(),
        isInitialPage: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        key: PageStorageKey<String>('bottomBar.bonus'.translate()),
        separatorBuilder: (_, __) =>
            const Divider(height: 10, color: Colors.transparent),
        itemBuilder: (BuildContext context, int index) => _tiles[index],
        itemCount: _tiles.length,
      ),
    );
  }
}

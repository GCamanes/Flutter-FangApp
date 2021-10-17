import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:flutter/material.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({Key? key}) : super(key: key);

  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'bottomBar.bonus'.translate(),
        isInitialPage: true,
      ),
      body: Center(
        child: Text('bottomBar.bonus'.translate()),
      ),
    );
  }
}

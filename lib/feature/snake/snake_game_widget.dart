import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/size_aware_widget.dart';
import 'package:fangapp/feature/snake/snake_score_widget.dart';
import 'package:flutter/cupertino.dart';

class SnakeGameWidget extends StatefulWidget {
  const SnakeGameWidget({Key? key}) : super(key: key);

  @override
  _SnakeGameWidgetState createState() => _SnakeGameWidgetState();
}

class _SnakeGameWidgetState extends State<SnakeGameWidget> {
  Size _screenSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              SizeAwareWidget(
                onChange: (Size size) => setState(() {
                  _screenSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight - size.height,
                  );
                }),
                child: const SnakeScoreWidget(),
              ),
              Container(
                height: _screenSize.height,
                width: _screenSize.width,
                color: AppColors.greyLight,
                child: Text(_screenSize.toString()),
              ),
            ],
          );
        },
      ),
    );
  }
}

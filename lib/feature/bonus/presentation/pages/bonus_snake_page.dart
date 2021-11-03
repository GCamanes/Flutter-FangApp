import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/enum/game_status_enum.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/icon_button_widget.dart';
import 'package:fangapp/feature/snake/widgets/snake_game_widget.dart';
import 'package:flutter/material.dart';

class BonusSnakePage extends StatefulWidget {
  const BonusSnakePage({Key? key}) : super(key: key);

  @override
  _BonusSnakePageState createState() => _BonusSnakePageState();
}

class _BonusSnakePageState extends State<BonusSnakePage> {
  late GameNotifier _gameNotifier;
  GameStatusEnum? _nextGameStatus;

  late GameBoardNotifier _gameBoardNotifier;

  @override
  void initState() {
    super.initState();
    _gameNotifier = GameNotifier();
    _gameBoardNotifier = GameBoardNotifier();
    _gameNotifier.addListener(() {
      if (_gameNotifier.status == GameStatusEnum.started) {
        setState(() {
          _nextGameStatus = GameStatusEnum.paused;
        });
      } else if (_gameNotifier.status == GameStatusEnum.paused) {
        setState(() {
          _nextGameStatus = GameStatusEnum.starting;
        });
      } else {
        setState(() {
          _nextGameStatus = null;
        });
      }
    });
    AnalyticsHelper().sendViewPageEvent(path: RouteConstants.routeBonusSnake);
  }

  IconData? _handleIcon() {
    if (_nextGameStatus == GameStatusEnum.paused) return Icons.pause_outlined;
    if (_nextGameStatus == GameStatusEnum.starting) {
      return Icons.play_arrow_outlined;
    }
    return null;
  }

  Color _handleIconColor() {
    if (_nextGameStatus == GameStatusEnum.paused) {
      return AppColors.orange;
    }
    return AppColors.white;
  }

  IconData? _handleIconPressed() {
    if (_nextGameStatus != null) {
      _gameBoardNotifier.setNextStatus(_nextGameStatus!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black90,
      appBar: AppBarWidget(
        title: 'Snake',
        actionsList: <Widget>[
          if (_handleIcon() != null)
            AppIconButtonWidget(
              icon: _handleIcon()!,
              color: _handleIconColor(),
              onPress: () {
                _handleIconPressed();
              },
            )
        ],
      ),
      body: SnakeGameWidget(
        gameNotifier: _gameNotifier,
        gameBoardNotifier: _gameBoardNotifier,
      ),
    );
  }
}

class GameNotifier extends ChangeNotifier {
  GameStatusEnum status = GameStatusEnum.notStarted;

  void updateGameStatus(GameStatusEnum newStatus) {
    status = newStatus;
    notifyListeners();
  }
}

class GameBoardNotifier extends ChangeNotifier {
  GameStatusEnum nextStatus = GameStatusEnum.notStarted;

  void setNextStatus(GameStatusEnum next) {
    nextStatus = next;
    notifyListeners();
  }
}

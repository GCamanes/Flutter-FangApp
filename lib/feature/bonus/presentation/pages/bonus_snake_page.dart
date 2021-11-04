import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/app_life_cycle/presentation/cubit/app_life_cycle_cubit.dart';
import 'package:fangapp/core/enum/game_status_enum.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/image_info_helper.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/icon_button_widget.dart';
import 'package:fangapp/feature/snake/widgets/snake_game_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BonusSnakePage extends StatefulWidget {
  const BonusSnakePage({Key? key}) : super(key: key);

  @override
  _BonusSnakePageState createState() => _BonusSnakePageState();
}

class _BonusSnakePageState extends State<BonusSnakePage> {
  late GameNotifier _gameNotifier;
  GameStatusEnum? _nextGameStatus;

  late GameBoardNotifier _gameBoardNotifier;

  late ImageInfo? _snackImageInfo;
  late ImageInfo? _wallImageInfo;
  bool _allImageLoaded = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImageInfo();
  }

  Future<void> _loadImageInfo() async {
    _snackImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/snake_apple.png',
    );
    _wallImageInfo = await ImageInfoHelper.getImageInfo(
      context,
      'assets/images/snake_wall2.png',
    );
    setState(() {
      _allImageLoaded = true;
    });
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
    if (_allImageLoaded) {
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
        body: BlocListener<AppLifeCycleCubit, AppLifeCycleState>(
          listener: (BuildContext context, AppLifeCycleState state) async {
            if (state is AppBackground) {
              if (_gameNotifier.status == GameStatusEnum.starting ||
                  _gameNotifier.status == GameStatusEnum.started) {
                _gameBoardNotifier.setNextStatus(GameStatusEnum.paused);
              }
            }
          },
          child: SnakeGameWidget(
            gameNotifier: _gameNotifier,
            gameBoardNotifier: _gameBoardNotifier,
            snackImageInfo: _snackImageInfo!,
            wallImageInfo: _wallImageInfo!,
          ),
        ),
      );
    }
    return const SizedBox();
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

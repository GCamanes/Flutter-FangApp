import 'package:fangapp/core/analytics/analytics_helper.dart';
import 'package:fangapp/core/extensions/version_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:fangapp/core/utils/navigation_helper.dart';
import 'package:fangapp/core/widget/loading_widget.dart';
import 'package:fangapp/core/widget/version_widget.dart';
import 'package:fangapp/feature/login/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    _loginCubit.getCurrentUser();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppHelper().deviceSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          AnalyticsHelper().sendLoginEvent(userMail: state.user.email);
          NavigationHelper.goToRoute(RouteConstants.routeMainContent, delay: 2);
        } else if (state is LoginError) {
          NavigationHelper.goToRoute(RouteConstants.routeLogin, delay: 2);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black90,
        body: Stack(
          children: <Widget>[
            const Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: VersionWidget(),
            ),
            const Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: LoadingWidget(),
            ),
            Center(child: Image.asset('assets/icons/icon.png'))
          ],
        ),
      ),
    );
  }
}

class SplashScreenNotifier extends ChangeNotifier {
  bool isLoading = true;

  void enterSplashScreen() {
    isLoading = true;
    notifyListeners();
  }

  void exitSplashScreen() {
    isLoading = false;
    notifyListeners();
  }
}

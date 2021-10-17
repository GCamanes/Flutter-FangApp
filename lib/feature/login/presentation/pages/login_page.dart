import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/enum/status_enum.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/navigation/route_constants.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/utils/navigation_helper.dart';
import 'package:fangapp/core/utils/snack_bar_helper.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:fangapp/core/widget/cross_fade_widget.dart';
import 'package:fangapp/feature/login/presentation/cubit/login_cubit.dart';
import 'package:fangapp/feature/login/presentation/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showLoginForm = false;
  late final LoginCubit _loginCubit;

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    super.initState();
  }

  Future<void> showLoginForm() async {
    setState(() {
      _showLoginForm = true;
    });
    if (_emailController.text.isEmpty) {
      await Future<void>.delayed(
        AppConstants.animLoginFormDuration,
        () => _emailNode.requestFocus(),
      );
    } else if (_passwordController.text.isEmpty) {
      await Future<void>.delayed(
        AppConstants.animLoginFormDuration,
        () => _passwordNode.requestFocus(),
      );
    }
  }

  void hideLoginForm() {
    setState(() {
      _showLoginForm = false;
    });
    FocusScope.of(context).unfocus();
  }

  void loginUser() {
    _loginCubit.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
      // Used to prevent exit app when back is pressed
      onWillPop: () async {
        if (_showLoginForm) {
          hideLoginForm();
          return false;
        } else {
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black90,
        body: BlocListener<LoginCubit, LoginState>(
          bloc: _loginCubit,
          listener: (BuildContext context, LoginState state) {
            if (state is LoginSuccess) {
              NavigationHelper.goToRoute(RouteConstants.routeBottomNav);
            } else if (state is LoginError) {
              SnackBarHelper.showSnackBar(
                text: 'error.${state.code}'.translate(),
                status: StatusEnum.error,
              );
            }
          },
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: size.height,
                    width: size.width,
                    child: AnimatedOpacity(
                      opacity: _showLoginForm ? 0.0 : 1.0,
                      duration: AppConstants.animLoginFadeDuration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/fangapp_logo.png',
                            width: size.width * 0.75,
                          ),
                          const SizedBox(height: 100),
                          AppButtonWidget(
                            onPressed: () => showLoginForm(),
                            text: 'login.title'.translate(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CrossFadeWidget(
                      showSecondWidget: _showLoginForm,
                      animationDuration: AppConstants.animLoginFormDuration,
                      firstWidget: const SizedBox(),
                      secondWidget: LoginFormWidget(
                        onBackPressed: () => hideLoginForm(),
                        emailNode: _emailNode,
                        emailController: _emailController,
                        passwordNode: _passwordNode,
                        passwordController: _passwordController,
                        onSubmit: () => loginUser(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: AnimatedContainer(
                      duration: AppConstants.animLoginCloudDuration,
                      transform: Transform.translate(
                        offset: Offset(
                          _showLoginForm ? -75 : 0,
                          _showLoginForm ? -150 : 0,
                        ),
                      ).transform,
                      child: Image.asset(
                        'assets/images/wave_top.png',
                        width: size.width * 0.75,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/wave_bottom.png',
                      width: size.width * 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fangapp/core/extensions/int_extension.dart';
import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/widget/app_bar_widget.dart';
import 'package:fangapp/core/widget/app_button_widget.dart';
import 'package:fangapp/core/widget/custom_text_field_widget.dart';
import 'package:fangapp/feature/login/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({
    Key? key,
    required this.onBackPressed,
    required this.emailNode,
    required this.passwordNode,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  }) : super(key: key);

  final Function() onBackPressed;
  final FocusNode emailNode;
  final FocusNode passwordNode;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Function() onSubmit;

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    _loginCubit = BlocProvider.of<LoginCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: AppColors.white,
        height: size.height,
        child: Column(
          children: <Widget>[
            AppBarWidget(
              onBackPressed: widget.onBackPressed,
              iconButton: Icons.close,
              title: 'login.title'.translate(),
              centerTitle: true,
            ),
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height / 5,
                      child: Center(
                        child: Image.asset(
                          'assets/images/one_piece_skull_fangapp_themed.png',
                          height: size.height / 7,
                        ),
                      ),
                    ),
                    CustomTextFieldWidget(
                      focusNode: widget.emailNode,
                      controller: widget.emailController,
                      hintText: 'login.email'.translate(),
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      onSubmitted: (String str) {
                        widget.passwordNode.requestFocus();
                      },
                    ),
                    CustomTextFieldWidget(
                      focusNode: widget.passwordNode,
                      controller: widget.passwordController,
                      hintText: 'login.pwd'.translate(),
                      isObscure: true,
                      onSubmitted: (String str) {
                        widget.onSubmit();
                      },
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<LoginCubit, LoginState>(
                      bloc: _loginCubit,
                      builder: (BuildContext context, LoginState state) {
                        return AnimatedContainer(
                          duration: 500.milliseconds,
                          transform: Transform.translate(
                            offset: Offset(
                              0,
                              state is LoginLoading || state is LoginSuccess
                                  ? 100
                                  : 0,
                            ),
                          ).transform,
                          child: AnimatedOpacity(
                            opacity:
                                state is LoginLoading || state is LoginSuccess
                                    ? 0.0
                                    : 1.0,
                            duration: 300.milliseconds,
                            child: AppButtonWidget(
                              text: 'login.enterApp'.translate(),
                              onPressed: state is! LoginLoading
                                  ? () {
                                      FocusScope.of(context).unfocus();
                                      widget.onSubmit();
                                    }
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

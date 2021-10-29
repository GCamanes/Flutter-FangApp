import 'package:fangapp/core/extensions/string_extension.dart';
import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:fangapp/core/utils/interaction_helper.dart';
import 'package:fangapp/core/widget/icon_button_widget.dart';
import 'package:fangapp/feature/login/presentation/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final bool needToLogout = await InteractionHelper.showModal(
      text: 'settings.logoutConfirm'.translate(),
      isDismissible: true,
    ) ?? false;
    if (needToLogout) {
      BlocProvider.of<LoginCubit>(context).logoutUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          return Column(
            children: <Widget>[
              Text(
                state.user.email,
                style: AppStyles.mediumTitle(
                  color: AppColors.blackSmokeDark,
                ),
              ),
              const SizedBox(height: 20),
              AppIconButtonWidget(
                icon: Icons.logout,
                size: 35,
                onPress: () => _logout(context),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

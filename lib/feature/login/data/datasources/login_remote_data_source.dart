import 'package:fangapp/feature/login/data/models/app_user_model.dart';

abstract class LoginRemoteDataSource {
  // Get current user from firebase auth
  AppUserModel getCurrentAppUser();

  // Login user to firebase auth (email/pwd)
  Future<AppUserModel> loginAppUser({
    required String email,
    required String password,
  });

  // Logout user from firebase auth
  Future<void> logoutAppUser();
}

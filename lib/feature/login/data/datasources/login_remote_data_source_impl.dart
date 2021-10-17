import 'package:fangapp/feature/login/data/models/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_remote_data_source.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  @override
  AppUserModel getCurrentAppUser() {
    final User? user = FirebaseAuth.instance.currentUser;
    return AppUserModel.fromFireBaseUser(firebaseUser: user);
  }

  @override
  Future<AppUserModel> loginAppUser({
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return AppUserModel.fromFireBaseUser(firebaseUser: userCredential.user);
  }

  @override
  Future<void> logoutAppUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

import 'package:fangapp/feature/login/domain/entities/app_user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required String displayName,
    required String email,
    required bool emailVerified,
    required bool success,
  }) : super(
          displayName: displayName,
          email: email,
          emailVerified: emailVerified,
          success: success,
        );

  factory AppUserModel.fromFireBaseUser({User? firebaseUser}) {
    return AppUserModel(
      displayName: firebaseUser?.displayName ?? '',
      email: firebaseUser?.email ?? '',
      emailVerified: firebaseUser?.emailVerified ?? false,
      success: firebaseUser != null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'emailVerified': emailVerified,
      'success': success,
    };
  }
}

import 'package:fangapp/core/data/app_constants.dart';

abstract class FirebaseErrorHelper {
  static String getAppException(String firebaseCode) {
    switch (firebaseCode) {
      case AppConstants.userNotFoundFirebaseException:
        return AppConstants.userNotFoundException;
      case AppConstants.userPasswordFirebaseException:
        return AppConstants.wrongPasswordException;
      case AppConstants.invalidEmailFirebaseException:
        return AppConstants.invalidEmailException;
      case AppConstants.userDisabledFirebaseException:
        return AppConstants.userDisabledException;
      case AppConstants.tooManyRequestFirebaseException:
        return AppConstants.tooManyRequestException;
      case AppConstants.objectNotFoundFirebaseException:
        return AppConstants.objectNotFoundException;
      case AppConstants.offlineFirebaseException:
        return AppConstants.offlineException;
      default:
        return AppConstants.unexpectedException;
    }
  }
}

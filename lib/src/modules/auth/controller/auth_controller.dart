import 'package:my_musics/src/modules/auth/model/auth_model.dart';

class AuthController {
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    // Firebase authentication removed
    onError('Firebase authentication has been removed');
  }

  Future<UserModel?> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    // Firebase authentication removed
    return null;
  }
}

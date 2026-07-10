import 'package:get/get.dart';
import 'package:my_musics/src/modules/auth/model/auth_model.dart';
import 'package:my_musics/app/services/twilio_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final TwilioService _twilioService = TwilioService();
  String _currentOTP = '';
  String _currentPhoneNumber = '';

  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      _currentPhoneNumber = phoneNumber;
      _currentOTP = _twilioService.generateOTP();

      await _twilioService.sendOTP(phoneNumber: phoneNumber, otp: _currentOTP);

      // Use phone number as verification ID for simplicity
      onCodeSent(phoneNumber);
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<UserModel?> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      if (smsCode == _currentOTP && verificationId == _currentPhoneNumber) {
        // Return a user model on successful verification
        return UserModel(phoneNumber: _currentPhoneNumber);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

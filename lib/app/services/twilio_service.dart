import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  late TwilioFlutter _twilioFlutter;

  // Replace with your actual Twilio credentials
  static const String _accountSid = 'YOUR_TWILIO_ACCOUNT_SID';
  static const String _authToken = 'YOUR_TWILIO_AUTH_TOKEN';
  static const String _twilioNumber = 'YOUR_TWILIO_PHONE_NUMBER';

  // Set to false to use actual Twilio SMS
  static const bool _devMode = true;

  TwilioService() {
    _twilioFlutter = TwilioFlutter(
      accountSid: _accountSid,
      authToken: _authToken,
      twilioNumber: _twilioNumber,
    );
  }

  // Generate a 6-digit OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Send OTP via SMS
  Future<void> sendOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      if (_devMode) {
        // Development mode: log OTP to console
        debugPrint('========================================');
        debugPrint('DEV MODE: OTP for $phoneNumber');
        debugPrint('Your verification code is: $otp');
        debugPrint('========================================');
        return;
      }

      // Production mode: send via Twilio
      await _twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: 'Your My Music verification code is: $otp',
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }
}

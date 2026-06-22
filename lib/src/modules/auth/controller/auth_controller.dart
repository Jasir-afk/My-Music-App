import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_musics/src/modules/auth/model/auth_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      print('📱 Sending OTP to: $phoneNumber'); // ← LOG 1

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          print('✅ Auto verification completed'); // ← LOG 2
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          print('❌ Verification failed: ${e.code} — ${e.message}'); // ← LOG 3
          onError(e.message ?? 'Verification failed');
        },

        codeSent: (String verificationId, int? resendToken) {
          print('📨 Code sent! verificationId: $verificationId'); // ← LOG 4
          onCodeSent(verificationId);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏱ Auto retrieval timeout'); // ← LOG 5
        },
      );
    } catch (e) {
      print('💥 sendOTP exception: $e'); // ← LOG 6
      onError(e.toString());
    }
  }

  Future<UserModel?> verifyOTP({
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      print('🔑 Verifying OTP: $smsCode');
      print('🔑 VerificationId: $verificationId');

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      print('🔐 Signing in with credential...');

      final userCredential = await _auth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      print('👤 Firebase user: ${firebaseUser?.uid}');

      if (firebaseUser == null) {
        print('❌ Firebase user is null');
        return null;
      }

      final userDoc = _firestore.collection('users').doc(firebaseUser.uid);

      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        final newUser = UserModel(
          uid: firebaseUser.uid,
          phoneNumber: firebaseUser.phoneNumber ?? '',
          displayName: '',
          createdAt: DateTime.now(),
        );

        await userDoc.set(newUser.toMap());

        return newUser;
      } else {
        return UserModel.fromMap(docSnapshot.data()!);
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}");
      print("Message: ${e.message}");
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}

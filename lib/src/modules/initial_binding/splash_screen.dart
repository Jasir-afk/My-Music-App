import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/services/auth_service.dart';
import 'package:my_musics/src/modules/homescreen/view/home_screen.dart';
import '../auth/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final auth = Get.find<AuthService>();

    if (auth.isLoggedIn) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

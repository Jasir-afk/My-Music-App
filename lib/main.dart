import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_musics/src/modules/auth/view/login_screen.dart';
import 'package:my_musics/src/modules/homescreen/view/home_screen.dart';
import 'package:my_musics/src/modules/initial_binding/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      home: LoginScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        // '/signup': (context) => const SignUpScreen(phoneNumber: ''),
      },
    );
  }
}

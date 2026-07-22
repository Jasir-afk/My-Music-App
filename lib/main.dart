import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/services/theme_service.dart';
import 'package:my_musics/src/modules/dashboard/view/button_navigationbar.dart';
import 'package:my_musics/src/modules/initial_binding/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: '/home',
        themeMode: themeService.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
        darkTheme: themeService.getTheme(),
        routes: {'/home': (context) => BottomNavScreen()},
      ),
    );
  }
}

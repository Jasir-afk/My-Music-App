import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/Playlist/view/playlist_sccreen.dart';
import 'package:my_musics/src/modules/dashboard/controller/bottom_nav_controller.dart';
import 'package:my_musics/src/modules/favorite/view/favorite_screen.dart';
import 'package:my_musics/src/modules/homescreen/view/home_screen.dart';
import 'package:my_musics/src/modules/settings/view/settings_screen.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomeScreen(),
    FavoriteScreen(),
    PlaylistScreen(),
    SettingsScreen(),
  ];
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.black,
        body: pages[controller.currentIndex.value],

        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.card.withOpacity(0.75),
              elevation: 0,

              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_rounded),
                  label: "Favorites",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.playlist_play_rounded),
                  label: "Playlist",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: "Settings",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

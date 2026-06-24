import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/dashboard/controller/tab_controller.dart';
import 'package:my_musics/src/modules/dashboard/view/tab_bar.dart';
import 'widgets/suggested_screen.dart';
import 'widgets/songs_screen.dart';
import 'widgets/artists_screen.dart';
import 'widgets/albums_screen.dart';
import 'widgets/folders_screen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TabBarController controller = Get.put(TabBarController());
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: const Text(
          "My Music",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 25, color: AppColors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: HomeTabBar(),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                SuggestedScreen(),
                const SongsScreen(),
                const ArtistsScreen(),
                const AlbumsScreen(),
                const FoldersScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

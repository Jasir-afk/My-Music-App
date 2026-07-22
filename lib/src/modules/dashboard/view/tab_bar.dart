import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/dashboard/controller/tab_controller.dart';

class HomeTabBar extends StatelessWidget {
  HomeTabBar({super.key});

  final TabBarController controller = Get.find<TabBarController>();

  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        dividerColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        tabs: const [
          Tab(text: "Suggested"),
          Tab(text: "Songs"),
          Tab(text: "Artists"),
          Tab(text: "Albums"),
          Tab(text: "Folders"),
        ],
      ),
    );
  }
}

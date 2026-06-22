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

        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppColors.primary, width: 3),
          borderRadius: BorderRadius.circular(20),
          insets: const EdgeInsets.symmetric(horizontal: 18),
        ),

        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,

        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: .3,
        ),

        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),

        labelPadding: const EdgeInsets.symmetric(horizontal: 18),
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

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/app_cards/ArtistCard.dart';
import 'package:my_musics/src/app_cards/SongCard.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';

class SuggestedScreen extends StatelessWidget {
  SuggestedScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Recently Played
          _sectionTitle("Recently Played"),

          const SizedBox(height: 15),

          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.songList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final song = controller.songList[index];

                  return Songcard(
                    title: song.title,
                    artist: song.artist,
                    album: song.album,
                    image: song.imageUrl,
                    onTap: () {},
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 30),

          /// Artists
          _sectionTitle("Artists"),

          const SizedBox(height: 15),

          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 15),
              itemBuilder: (context, index) {
                return ArtistCard(
                  name: "Imagine Dragons",
                  subtitle: "2 Albums • 18 Songs",
                  image:
                      "https://i.scdn.co/image/ab6761610000e5eb920dc1f617550de8388f368e",
                  onTap: () {},
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          /// Most Played
          _sectionTitle("Most Played"),

          const SizedBox(height: 15),

          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.songList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final song = controller.songList[index];

                  return Songcard(
                    title: song.title,
                    artist: song.artist,
                    album: song.album,
                    image: song.imageUrl,
                    onTap: () {},
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            "See All",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

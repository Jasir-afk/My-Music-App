import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/app_cards/ArtistCard.dart';
import 'package:my_musics/src/app_cards/SongCard.dart';
import 'package:my_musics/src/modules/dashboard/controller/tab_controller.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/homescreen/view/artist_detail_screen.dart';

class SuggestedScreen extends StatelessWidget {
  SuggestedScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  final AudioService audioService = AudioService.to;

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hello Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "John Johnson",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=60",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Bar & Filter Button Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.onSearchTextChanged,
                    style: const TextStyle(color: AppColors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Search album, song...",
                      hintStyle: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      suffixIcon: Obx(() {
                        if (controller.searchQuery.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.textSecondary, size: 18),
                          onPressed: controller.clearSearch,
                        );
                      }),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Promotional Gradient Banner
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "40% OFF",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Get Unlimited Download",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "PREMIUM NOW",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: -10,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.white.withOpacity(0.2), AppColors.white.withOpacity(0.02)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.headphones_rounded,
                      size: 96,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          _sectionHeader("Most Popular", onViewAll: () {
            // Switch to trending tab
            final tabController = Get.find<TabBarController>();
            tabController.tabController.animateTo(1);
          }),
          const SizedBox(height: 15),
          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Sort by play count descending for "Most Popular"
              final popularSongs = [...controller.trendingSongs]
                ..sort((a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0));
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popularSongs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final song = popularSongs[index];
                  return Songcard(
                    title: song.title ?? 'Unknown',
                    artist: song.artist ?? 'Unknown',
                    album: song.genre ?? '',
                    image: song.artwork ?? '',
                    onTap: () {
                      audioService.setPlaylist(popularSongs, index);
                    },
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 30),
          _sectionHeader("Artists"),
          const SizedBox(height: 15),
          SizedBox(
            height: 130,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Extract unique artists from trending songs
              final Map<String, Map<String, dynamic>> artistMap = {};
              for (final song in controller.trendingSongs) {
                final artistName = song.artist ?? 'Unknown';
                if (!artistMap.containsKey(artistName)) {
                  artistMap[artistName] = {
                    'name': artistName,
                    'image': song.artistImage ?? '',
                    // Prefer actual track count from API; fall back to 1
                    'trackCount': song.artistTrackCount ?? 1,
                    'followerCount': song.artistFollowerCount ?? 0,
                  };
                }
              }

              final artists = artistMap.values.toList();

              if (artists.isEmpty) {
                return const Center(
                  child: Text(
                    'No artists found',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final artist = artists[index];
                  final trackCount = artist['trackCount'] as int;
                  final followerCount = artist['followerCount'] as int;

                  // Format large numbers nicely
                  String formatCount(int n) {
                    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
                    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
                    return '$n';
                  }

                  final subtitle = followerCount > 0
                      ? '${formatCount(followerCount)} followers'
                      : '${formatCount(trackCount)} ${trackCount == 1 ? 'Track' : 'Tracks'}';

                  return ArtistCard(
                    name: artist['name'] as String,
                    subtitle: subtitle,
                    image: artist['image'] as String,
                    onTap: () {
                      // Filter all songs from this artist
                      final artistSongs = controller.trendingSongs
                          .where((s) => s.artist == artist['name'])
                          .toList();
                      Get.to(() => ArtistDetailScreen(
                            artistName: artist['name'] as String,
                            artistImage: artist['image'] as String,
                            subtitle: subtitle,
                            songs: artistSongs,
                          ));
                    },
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 30),
          _sectionHeader("Most Favorited"),
          const SizedBox(height: 15),
          SizedBox(
            height: 240,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // Sort by favorite count descending for "Most Favorited"
              final favoritedSongs = [...controller.trendingSongs]
                ..sort((a, b) => (b.favoriteCount ?? 0).compareTo(a.favoriteCount ?? 0));
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: favoritedSongs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 15),
                itemBuilder: (context, index) {
                  final song = favoritedSongs[index];
                  return Songcard(
                    title: song.title ?? 'Unknown',
                    artist: song.artist ?? 'Unknown',
                    album: song.genre ?? '',
                    image: song.artwork ?? '',
                    onTap: () {
                      audioService.setPlaylist(favoritedSongs, index);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "View All",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

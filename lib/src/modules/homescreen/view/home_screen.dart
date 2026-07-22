import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/app_cards/ArtistCard.dart';
import 'package:my_musics/src/app_cards/SongCard.dart';
import 'package:my_musics/src/modules/dashboard/controller/tab_controller.dart';
import 'package:my_musics/src/modules/dashboard/view/tab_bar.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';
import 'package:my_musics/src/modules/homescreen/view/artist_detail_screen.dart';
import 'widgets/suggested_screen.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/search/view/search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TabBarController controller = Get.put(TabBarController());
  final HomeController homeController = Get.find<HomeController>();
  final PlaybackService audioService = PlaybackService.to;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchScreen());
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: homeController.searchController,
                          onChanged: homeController.onSearchTextChanged,
                          readOnly: true,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 13,
                          ),
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
                              if (homeController.searchQuery.value.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                                onPressed: homeController.clearSearch,
                              );
                            }),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
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
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: HomeTabBar(),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [SuggestedScreen(), _buildTrendingScreen()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingScreen() {
    return Obx(() {
      if (homeController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (homeController.trendingSongs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: 48,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 16),
              const Text(
                "No trending songs",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Split the list for reference design sections
      // Show first 5 as "Upcoming", rest as "Recently Play"
      final upcomingSongs = homeController.trendingSongs.length > 5
          ? homeController.trendingSongs.take(5).toList()
          : homeController.trendingSongs.toList();
      final recentlyPlaySongs = homeController.trendingSongs.length > 5
          ? homeController.trendingSongs.skip(5).toList()
          : <TrackModel>[];

      return RefreshIndicator(
        onRefresh: homeController.refreshTrendingSongs,
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo is ScrollEndNotification) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                homeController.loadMoreTrendingSongs();
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Most Played" Section
                _sectionHeader("Most Played"),
                const SizedBox(height: 15),
                SizedBox(
                  height: 240,
                  child: Obx(() {
                    if (homeController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Sort by play count descending for "Most Played"
                    final mostPlayedSongs = [...homeController.trendingSongs]
                      ..sort(
                        (a, b) =>
                            (b.playCount ?? 0).compareTo(a.playCount ?? 0),
                      );
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: mostPlayedSongs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final song = mostPlayedSongs[index];
                        return Songcard(
                          title: song.title ?? 'Unknown',
                          artist: song.artist ?? 'Unknown',
                          album: song.genre ?? '',
                          image: song.artwork ?? '',
                          onTap: () {
                            audioService.setPlaylist(mostPlayedSongs, index);
                          },
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),

                // "Related Artists" Section
                _sectionHeader("Related Artists"),
                const SizedBox(height: 15),
                SizedBox(
                  height: 130,
                  child: Obx(() {
                    if (homeController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Extract unique artists from trending songs
                    final Map<String, Map<String, dynamic>> artistMap = {};
                    for (final song in homeController.trendingSongs) {
                      final artistName = song.artist ?? 'Unknown';
                      if (!artistMap.containsKey(artistName)) {
                        artistMap[artistName] = {
                          'name': artistName,
                          'image': song.artistImage ?? '',
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
                      separatorBuilder: (_, _) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final artist = artists[index];
                        final trackCount = artist['trackCount'] as int;
                        final followerCount = artist['followerCount'] as int;

                        String formatCount(int n) {
                          if (n >= 1000000) {
                            return '${(n / 1000000).toStringAsFixed(1)}M';
                          }
                          if (n >= 1000) {
                            return '${(n / 1000).toStringAsFixed(1)}k';
                          }
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
                            Get.to(
                              () => ArtistDetailScreen(
                                artistName: artist['name'] as String,
                                artistImage: artist['image'] as String,
                                subtitle: subtitle,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),

                // "Upcoming" Section
                _sectionHeader("Upcoming"),
                const SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingSongs.length,
                  itemBuilder: (context, index) {
                    final song = upcomingSongs[index];
                    return _buildRecentlyPlayTile(context, song, index);
                  },
                ),
                const SizedBox(height: 24),

                // "Recently Play" Section
                _sectionHeader("Recently Play"),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentlyPlaySongs.length,
                  itemBuilder: (context, index) {
                    final song = recentlyPlaySongs[index];
                    // Offset the index to match index in the original list
                    final originalIndex = index + 5;
                    return _buildRecentlyPlayTile(context, song, originalIndex);
                  },
                ),
                // Loading indicator for pagination
                Obx(() {
                  if (homeController.isTrendingLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayTile(
    BuildContext context,
    TrackModel song,
    int index,
  ) {
    return InkWell(
      onTap: () {
        audioService.setPlaylist(homeController.trendingSongs, index);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.artwork ?? '',
                height: 52,
                width: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 52,
                  width: 52,
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title ?? 'Unknown Track',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showAddToPlaylistBottomSheet(context, song),
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToPlaylistBottomSheet(BuildContext context, TrackModel song) {
    final playlistController = PlaylistController.to;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Add to Playlist",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final lists = playlistController.playlists;
              if (lists.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "No playlists found. Create one in the Playlists tab!",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final playlist = lists[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.queue_music_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      playlist.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${playlist.songs.length} songs",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    onTap: () {
                      playlistController.addSongToPlaylist(playlist.id, song);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

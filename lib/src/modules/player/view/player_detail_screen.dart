import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';

class PlayerDetailScreen extends StatelessWidget {
  PlayerDetailScreen({super.key});

  final PlaybackService audioService = PlaybackService.to;
  final HomeController homeController = Get.find<HomeController>();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Obx(() {
        final track = audioService.currentTrack.value;
        if (track == null) {
          return const Center(
            child: Text(
              "No track playing",
              style: TextStyle(color: AppColors.white),
            ),
          );
        }

        final isPlaying = audioService.isPlaying.value;
        final position = audioService.position.value;
        final duration = audioService.duration.value;

        // Formatted durations
        String formatDuration(Duration d) {
          final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
          final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
          return "$minutes:$seconds";
        }

        return Stack(
          children: [
            // Ambient background blur from artwork
            if (track.artwork != null && track.artwork!.isNotEmpty)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        track.artwork!,
                        errorListener: (error) {
                          print('Error loading artwork: $error');
                        },
                      ),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        print('Image load error: $exception');
                      },
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Container(color: AppColors.black.withOpacity(0.55)),
                  ),
                ),
              ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.white,
                            size: 32,
                          ),
                        ),
                        Text(
                          "NOW PLAYING",
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Obx(() {
                          final isFav = homeController.isFavorite(track);
                          return IconButton(
                            onPressed: () =>
                                homeController.toggleFavorite(track),
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav
                                  ? AppColors.primary
                                  : AppColors.white,
                              size: 24,
                            ),
                          );
                        }),
                      ],
                    ),

                    const Spacer(),

                    // Artwork
                    Hero(
                      tag: 'player_artwork',
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            track.artwork ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.surface,
                              child: Icon(
                                Icons.music_note_rounded,
                                color: AppColors.primary.withOpacity(0.5),
                                size: 100,
                              ),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.surface,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                        : null,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Track Info
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            track.title ?? 'Unknown Track',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            track.artist ?? 'Unknown Artist',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Slider & Time stamps
                    Column(
                      children: [
                        SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.white.withOpacity(
                              0.15,
                            ),
                            thumbColor: AppColors.white,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                          ),
                          child: Slider(
                            min: 0,
                            max: duration.inMilliseconds.toDouble(),
                            value: position.inMilliseconds.toDouble().clamp(
                              0.0,
                              duration.inMilliseconds.toDouble(),
                            ),
                            onChanged: (val) {
                              audioService.seek(
                                Duration(milliseconds: val.toInt()),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatDuration(position),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                formatDuration(duration),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: audioService.playPrevious,
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: audioService.togglePlayPause,
                          child: Container(
                            height: 64,
                            width: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: AppColors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: audioService.playNext,
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Floating Bottom Action Bar from Reference Design
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Shuffle button
                          Obx(() {
                            final active = audioService.isShuffle.value;
                            return IconButton(
                              onPressed: audioService.toggleShuffle,
                              icon: Icon(
                                Icons.shuffle_rounded,
                                color: active
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                size: 22,
                              ),
                            );
                          }),

                          // Repeat button — cycles off → one → all
                          Obx(() {
                            final mode = audioService.repeatMode.value;
                            final IconData icon;
                            final Color color;
                            if (mode == RepeatMode.one) {
                              icon = Icons.repeat_one_rounded;
                              color = AppColors.primary;
                            } else if (mode == RepeatMode.all) {
                              icon = Icons.repeat_rounded;
                              color = AppColors.primary;
                            } else {
                              icon = Icons.repeat_rounded;
                              color = AppColors.textSecondary;
                            }
                            return IconButton(
                              onPressed: audioService.toggleRepeat,
                              icon: Icon(icon, color: color, size: 22),
                            );
                          }),

                          // Add to Playlist
                          IconButton(
                            onPressed: () {
                              final track = audioService.currentTrack.value;
                              if (track == null) return;
                              _showAddToPlaylistSheet(context, track);
                            },
                            icon: const Icon(
                              Icons.queue_music_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),

                          // Queue
                          IconButton(
                            onPressed: () {
                              _showQueueSheet(context);
                            },
                            icon: const Icon(
                              Icons.list_rounded,
                              color: AppColors.textSecondary,
                              size: 22,
                            ),
                          ),

                          // Volume
                          Obx(() {
                            final vol = audioService.volume.value;
                            return IconButton(
                              onPressed: () {
                                _showVolumeSheet(context);
                              },
                              icon: Icon(
                                vol == 0
                                    ? Icons.volume_off_rounded
                                    : vol < 0.5
                                    ? Icons.volume_down_rounded
                                    : Icons.volume_up_rounded,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showAddToPlaylistSheet(BuildContext context, dynamic song) {
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
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "No playlists yet. Create one in the Playlists tab!",
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
                itemBuilder: (_, index) {
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

  void _showQueueSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
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
              "Queue",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final playlist = audioService.playlist;
              final currentIndex = audioService.currentIndex.value;
              if (playlist.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "Queue is empty",
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
                itemCount: playlist.length,
                itemBuilder: (_, index) {
                  final track = playlist[index];
                  final isCurrent = index == currentIndex;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: isCurrent
                        ? const Icon(
                            Icons.play_circle_rounded,
                            color: AppColors.primary,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                    title: Text(
                      track.title ?? 'Unknown Track',
                      style: TextStyle(
                        color: isCurrent ? AppColors.primary : AppColors.white,
                        fontSize: 14,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      track.artist ?? 'Unknown Artist',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    onTap: () {
                      audioService.setPlaylist(playlist, index);
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

  void _showVolumeSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 24),
            const Text(
              "Volume",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              final vol = audioService.volume.value;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        vol == 0
                            ? Icons.volume_off_rounded
                            : vol < 0.5
                            ? Icons.volume_down_rounded
                            : Icons.volume_up_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(vol * 100).toInt()}%',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.white.withOpacity(0.15),
                      thumbColor: AppColors.white,
                      overlayColor: AppColors.primary.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: 1,
                      value: vol,
                      onChanged: (val) {
                        audioService.setVolume(val);
                      },
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';
import 'package:my_musics/app/services/audio_service.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;
  PlaylistDetailScreen({super.key, required this.playlistId});

  final PlaylistController playlistController = PlaylistController.to;
  final PlaybackService audioService = PlaybackService.to;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final index = playlistController.playlists.indexWhere(
            (p) => p.id == playlistId,
          );
          if (index == -1) {
            return const Center(
              child: Text(
                "Playlist not found",
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          final playlist = playlistController.playlists[index];
          final songs = playlist.songs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        playlist.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _confirmDeletePlaylist(context, playlist.name),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Playlist info summary
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    "${songs.length} ${songs.length == 1 ? 'Song' : 'Songs'}",
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Song list inside the playlist
                Expanded(
                  child: songs.isEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            // Playlists are stored locally, no need to refresh from API
                          },
                          color: AppColors.primary,
                          backgroundColor: AppColors.card,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.music_off_rounded,
                                      size: 48,
                                      color: AppColors.textHint,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No songs inside playlist",
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            // Playlists are stored locally, no need to refresh from API
                          },
                          color: AppColors.primary,
                          backgroundColor: AppColors.card,
                          child: ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              return InkWell(
                                onTap: () {
                                  audioService.setPlaylist(songs, index);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          song.artwork ?? '',
                                          height: 52,
                                          width: 52,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      Obx(() {
                                        final isCurrentTrack =
                                            audioService
                                                .currentTrack
                                                .value
                                                ?.id ==
                                            song.id;
                                        final isPlaying =
                                            audioService.isPlaying.value &&
                                            isCurrentTrack;
                                        return IconButton(
                                          onPressed: () {
                                            if (isCurrentTrack) {
                                              audioService.togglePlayPause();
                                            } else {
                                              audioService.setPlaylist(
                                                songs,
                                                index,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            isPlaying
                                                ? Icons.pause_circle_rounded
                                                : Icons
                                                      .play_circle_outline_rounded,
                                            color: AppColors.primary,
                                            size: 28,
                                          ),
                                        );
                                      }),
                                      IconButton(
                                        onPressed: () {
                                          playlistController
                                              .removeSongFromPlaylist(
                                                playlistId,
                                                song.id!,
                                              );
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void _confirmDeletePlaylist(BuildContext context, String name) {
    Get.defaultDialog(
      title: "Delete Playlist",
      titleStyle: const TextStyle(color: AppColors.white),
      middleText: 'Are you sure you want to delete "$name"?',
      middleTextStyle: const TextStyle(color: AppColors.textSecondary),
      backgroundColor: AppColors.card,
      textConfirm: "Yes, Delete",
      textCancel: "Cancel",
      confirmTextColor: AppColors.white,
      cancelTextColor: AppColors.primary,
      buttonColor: AppColors.primary,
      onConfirm: () {
        playlistController.deletePlaylist(playlistId);
        // Use Navigator.pop() to dismiss the dialog to avoid the GetX
        // snackbar assertion crash ('!_transitionCompleter.isCompleted')
        // that occurs when Get.back() tries to close an already-disposed snackbar.
        Get.closeAllSnackbars();
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss dialog
        Navigator.of(context).pop(); // Go back to Playlist Screen
      },
    );
  }
}

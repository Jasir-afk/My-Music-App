import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/Playlist/controller/playlist_controller.dart';
import 'package:my_musics/src/modules/Playlist/model/playlist_model.dart';
import 'package:my_musics/src/modules/Playlist/view/playlist_detail_screen.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({super.key});

  final PlaylistController playlistController = PlaylistController.to;



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row matching reference design
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Library",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Playlists",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
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
                      radius: 18,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=60",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  final list = playlistController.playlists;
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.playlist_add_rounded,
                              size: 36,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "No playlists yet",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Tap the button below to create your first playlist.",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final playlist = list[index];
                      return _buildPlaylistCard(context, playlist);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePlaylistDialog(context),
        backgroundColor: AppColors.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: AppColors.white, size: 28),
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, PlaylistModel playlist) {
    // Determine gradient based on name/id to make it colorful
    final gradientIndex = playlist.name.length % 3;
    final List<Color> gradientColors;
    if (gradientIndex == 0) {
      gradientColors = [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)];
    } else if (gradientIndex == 1) {
      gradientColors = [const Color(0xFFFD3C5B), const Color(0xFFFF6B81)];
    } else {
      gradientColors = [const Color(0xFFFFB703), const Color(0xFFFB8500)];
    }

    return InkWell(
      onTap: () => Get.to(() => PlaylistDetailScreen(playlistId: playlist.id)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
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
                  "${playlist.songs.length} ${playlist.songs.length == 1 ? 'Song' : 'Songs'}",
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final textController = TextEditingController();
    Get.defaultDialog(
      title: "New Playlist",
      titleStyle: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: AppColors.card,
      barrierDismissible: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: textController,
          style: const TextStyle(color: AppColors.white, fontSize: 14),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter playlist name...",
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 13),
            border: InputBorder.none,
          ),
        ),
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      confirmTextColor: AppColors.white,
      cancelTextColor: AppColors.primary,
      buttonColor: AppColors.primary,
      onConfirm: () {
        final name = textController.text.trim();
        if (name.isNotEmpty) {
          playlistController.createPlaylist(name);
          Get.back();
        }
      },
    );
  }
}

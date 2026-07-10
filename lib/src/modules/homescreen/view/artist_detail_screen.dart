import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/homescreen/controller/artist_detail_controller.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';

class ArtistDetailScreen extends StatelessWidget {
  final String artistName;
  final String artistImage;
  final String subtitle;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
    required this.artistImage,
    required this.subtitle,
  });

  Widget build(BuildContext context) {
    Get.put(ArtistDetailController());
    final controller = Get.find<ArtistDetailController>();
    controller.artistName = artistName;
    controller.loadSongs();
    final audioService = PlaybackService.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refresh();
        },
        color: AppColors.primary,
        backgroundColor: AppColors.card,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // --- Collapsible Header ---
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.background,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.keyboard_arrow_left_rounded,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred background from artist image
                    if (artistImage.isNotEmpty)
                      Image.network(
                        artistImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.surface),
                      ),
                    // Dark overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withOpacity(0.3),
                            AppColors.background,
                          ],
                        ),
                      ),
                    ),
                    // Artist info centered
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          // Circular avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                artistImage,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  height: 90,
                                  width: 90,
                                  color: AppColors.surface,
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: AppColors.primary.withOpacity(0.5),
                                    size: 44,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            artistName,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Play All Button ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.songs.isNotEmpty) {
                            audioService.setPlaylist(controller.songs, 0);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.white,
                                size: 22,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Play All',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        if (controller.songs.isNotEmpty) {
                          audioService.toggleShuffle();
                          audioService.setPlaylist(controller.songs, 0);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.border.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.shuffle_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Section header ---
            Obx(
              () => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Songs (${controller.songs.length})',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // --- Song List ---
            Obx(
              () => controller.isLoading.value && controller.songs.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : controller.songs.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.music_off_rounded,
                              color: AppColors.textHint,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No songs available',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final song = controller.songs[index];
                        return _buildSongTile(
                          context,
                          song,
                          index,
                          audioService,
                          controller,
                        );
                      }, childCount: controller.songs.length),
                    ),
            ),

            Obx(
              () => controller.isLoadingMore.value
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongTile(
    BuildContext context,
    TrackModel song,
    int index,
    PlaybackService audioService,
    ArtistDetailController controller,
  ) {
    return Obx(() {
      final isCurrentTrack = audioService.currentTrack.value?.id == song.id;
      final isPlaying = audioService.isPlaying.value && isCurrentTrack;

      return InkWell(
        onTap: () => audioService.setPlaylist(controller.songs, index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Index number or playing indicator
              SizedBox(
                width: 28,
                child: isPlaying
                    ? const Icon(
                        Icons.equalizer,
                        color: AppColors.primary,
                        size: 16,
                      )
                    : isCurrentTrack
                    ? const Icon(
                        Icons.pause_rounded,
                        color: AppColors.primary,
                        size: 18,
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(width: 12),
              // Artwork
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  song.artwork ?? '',
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 52,
                      width: 52,
                      color: AppColors.surface,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  },
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
              const SizedBox(width: 14),
              // Title + artist
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title ?? 'Unknown Track',
                      style: TextStyle(
                        color: isCurrentTrack
                            ? AppColors.primary
                            : AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      song.genre ?? '',
                      style: TextStyle(
                        color: isCurrentTrack
                            ? AppColors.primary.withOpacity(0.8)
                            : AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Play count
              if (song.playCount != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppColors.textHint,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatCount(song.playCount!),
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

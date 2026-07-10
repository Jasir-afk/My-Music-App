import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/Playlist/view/playlist_sccreen.dart';
import 'package:my_musics/src/modules/dashboard/controller/bottom_nav_controller.dart';
import 'package:my_musics/src/modules/favorite/view/favorite_screen.dart';
import 'package:my_musics/src/modules/homescreen/view/home_screen.dart';
import 'package:my_musics/src/modules/Settings/view/settings_screen.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/player/view/player_detail_screen.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());
  final AudioService audioService = AudioService.to;

  final List<Widget> pages = [
    HomeScreen(),
    FavoriteScreen(),
    PlaylistScreen(),
    SettingsScreen(),
  ];

  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.black,
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMiniPlayer(context),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.border.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: BottomNavigationBar(
                    currentIndex: controller.currentIndex.value,
                    onTap: controller.changeIndex,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: AppColors.card.withOpacity(0.6),
                    elevation: 0,
                    selectedItemColor: AppColors.primary,
                    unselectedItemColor: AppColors.iconInactive,
                    selectedFontSize: 11,
                    unselectedFontSize: 11,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(Icons.home_rounded, 0),
                        activeIcon: _buildNavIcon(Icons.home_rounded, 0, selected: true),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(Icons.favorite_rounded, 1),
                        activeIcon: _buildNavIcon(Icons.favorite_rounded, 1, selected: true),
                        label: "Favorites",
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(Icons.playlist_play_rounded, 2),
                        activeIcon: _buildNavIcon(Icons.playlist_play_rounded, 2, selected: true),
                        label: "Playlist",
                      ),
                      BottomNavigationBarItem(
                        icon: _buildNavIcon(Icons.settings_rounded, 3),
                        activeIcon: _buildNavIcon(Icons.settings_rounded, 3, selected: true),
                        label: "Settings",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer(BuildContext context) {
    return Obx(() {
      final track = audioService.currentTrack.value;
      if (track == null) return const SizedBox.shrink();

      final isPlaying = audioService.isPlaying.value;
      final position = audioService.position.value;
      final duration = audioService.duration.value;
      
      double progress = 0.0;
      if (duration.inMilliseconds > 0) {
        progress = position.inMilliseconds / duration.inMilliseconds;
      }

      return GestureDetector(
        onTap: () => Get.to(
          () => PlayerDetailScreen(),
          transition: Transition.downToUp,
          duration: const Duration(milliseconds: 350),
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mini Progress Bar
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.white.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      // Song image
                      Hero(
                        tag: 'player_artwork',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            track.artwork ?? '',
                            height: 44,
                            width: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 44,
                              width: 44,
                              color: AppColors.surface,
                              child: const Icon(Icons.music_note_rounded,
                                  color: AppColors.primary, size: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Song title & artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track.title ?? 'Unknown Track',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              track.artist ?? 'Unknown Artist',
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Controls
                      IconButton(
                        onPressed: audioService.togglePlayPause,
                        icon: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: audioService.playNext,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: AppColors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavIcon(IconData icon, int index, {bool selected = false}) {
    if (!selected) {
      return Icon(icon, size: 24);
    }
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: AppColors.primaryGradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}

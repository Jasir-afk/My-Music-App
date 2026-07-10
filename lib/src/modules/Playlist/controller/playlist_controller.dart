import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/Playlist/model/playlist_model.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';

class PlaylistController extends GetxController {
  static PlaylistController get to => Get.find<PlaylistController>();

  RxList<PlaylistModel> playlists = <PlaylistModel>[].obs;


  void onInit() {
    super.onInit();
    // Seed with a sample playlist
    playlists.add(
      PlaylistModel(
        id: 'favorites_seeded',
        name: 'My Vibe Mix',
        songs: [],
      ),
    );
  }

  void createPlaylist(String name) {
    if (name.trim().isEmpty) return;
    
    // Check if playlist name already exists
    if (playlists.any((p) => p.name.toLowerCase() == name.trim().toLowerCase())) {
      Get.snackbar(
        'Playlists',
        'A playlist with name "$name" already exists.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card.withOpacity(0.9),
        colorText: AppColors.white,
      );
      return;
    }

    playlists.add(PlaylistModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      songs: [],
    ));

    Get.snackbar(
      'Playlists',
      'Created playlist "$name"',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.card.withOpacity(0.9),
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void addSongToPlaylist(String playlistId, TrackModel song) {
    final index = playlists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      final playlist = playlists[index];
      
      // Prevent duplicates
      if (playlist.songs.any((s) => s.id == song.id)) {
        Get.snackbar(
          'Playlists',
          '"${song.title}" is already in "${playlist.name}"',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.card.withOpacity(0.9),
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      final updatedSongs = List<TrackModel>.from(playlist.songs)..add(song);
      playlists[index] = PlaylistModel(
        id: playlist.id,
        name: playlist.name,
        songs: updatedSongs,
      );

      Get.snackbar(
        'Playlists',
        'Added "${song.title}" to "${playlist.name}"',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card.withOpacity(0.9),
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removeSongFromPlaylist(String playlistId, String songId) {
    final index = playlists.indexWhere((p) => p.id == playlistId);
    if (index != -1) {
      final playlist = playlists[index];
      final updatedSongs = List<TrackModel>.from(playlist.songs)
        ..removeWhere((s) => s.id == songId);
      
      playlists[index] = PlaylistModel(
        id: playlist.id,
        name: playlist.name,
        songs: updatedSongs,
      );
    }
  }

  void deletePlaylist(String id) {
    playlists.removeWhere((p) => p.id == id);
    Get.snackbar(
      'Playlists',
      'Deleted playlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.card.withOpacity(0.9),
      colorText: AppColors.white,
      duration: const Duration(seconds: 2),
    );
  }
}

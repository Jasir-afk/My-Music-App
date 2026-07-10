import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';
import 'package:my_musics/src/modules/homescreen/repo/home_repo.dart';

class HomeController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  RxList<TrackModel> trendingSongs = <TrackModel>[].obs;
  RxList<TrackModel> latestSongs = <TrackModel>[].obs;
  RxList<TrackModel> mostLovedSongs = <TrackModel>[].obs;
  RxList<TrackModel> recommendedSongs = <TrackModel>[].obs;
  RxBool isLoading = false.obs;

  final searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<TrackModel> favoriteSongs = <TrackModel>[].obs;

  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchController.clear();
    onSearchTextChanged('');
  }

  void onInit() {
    super.onInit();
    loadTrendingSongs();
  }

  Future<void> loadTrendingSongs() async {
    try {
      isLoading.value = true;
      final songs = await _repository.getTrendingSongs();
      trendingSongs.assignAll(songs);
      print("Trending Songs Loaded: ${trendingSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLatestSongs() async {
    try {
      isLoading.value = true;
      final songs = await _repository.getLatestSongs();
      latestSongs.assignAll(songs);
      print("Latest Songs Loaded: ${latestSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMostLovedSongs() async {
    try {
      isLoading.value = true;
      final songs = await _repository.getMostLovedSongs();
      mostLovedSongs.assignAll(songs);
      print("Most Loved Songs Loaded: ${mostLovedSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecommendedSongs() async {
    try {
      isLoading.value = true;
      final songs = await _repository.getRecommendedSongs();
      recommendedSongs.assignAll(songs);
      print("Recommended Songs Loaded: ${recommendedSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // RxString searchQuery = ''.obs;
  // RxList<TrackModel> favoriteSongs = <TrackModel>[].obs;

  void onSearchTextChanged(String val) {
    searchQuery.value = val;
    if (val.trim().isEmpty) {
      loadTrendingSongs();
    } else {
      searchSongs(val);
    }
  }

  void toggleFavorite(TrackModel track) {
    final isFav = isFavorite(track);
    if (isFav) {
      favoriteSongs.removeWhere((s) => s.id == track.id);
      Get.snackbar(
        'Favorites',
        'Removed "${track.title}" from favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card.withOpacity(0.9),
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      favoriteSongs.add(track);
      Get.snackbar(
        'Favorites',
        'Added "${track.title}" to favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.card.withOpacity(0.9),
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  bool isFavorite(TrackModel track) {
    return favoriteSongs.any((s) => s.id == track.id);
  }

  Future<void> searchSongs(String query) async {
    try {
      isLoading.value = true;
      final songs = await _repository.searchTracks(query);
      trendingSongs.assignAll(songs);
      print("Search Results Loaded: ${trendingSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';
import 'package:my_musics/src/modules/homescreen/repo/home_repo.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find<HomeController>();

  final HomeRepository _repository = HomeRepository();

  RxList<TrackModel> trendingSongs = <TrackModel>[].obs;
  RxList<TrackModel> latestSongs = <TrackModel>[].obs;
  RxList<TrackModel> mostLovedSongs = <TrackModel>[].obs;
  RxList<TrackModel> recommendedSongs = <TrackModel>[].obs;
  RxBool isLoading = false.obs;

  final searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  RxList<TrackModel> favoriteSongs = <TrackModel>[].obs;

  // Track loading states for each data type
  final RxBool _trendingLoaded = false.obs;
  final RxBool _latestLoaded = false.obs;
  final RxBool _mostLovedLoaded = false.obs;
  final RxBool _recommendedLoaded = false.obs;

  // Pagination
  final RxInt _trendingOffset = 0.obs;
  final RxBool _trendingHasMore = true.obs;
  final RxBool _trendingLoadingMore = false.obs;
  final int _pageSize = 20;

  bool get isTrendingLoadingMore => _trendingLoadingMore.value;

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
    // Only load trending songs on init, others load lazily
    loadTrendingSongs();
  }

  Future<void> loadTrendingSongs() async {
    if (_trendingLoaded.value && trendingSongs.isNotEmpty) return;

    try {
      isLoading.value = true;
      final songs = await _repository.getTrendingSongs(
        offset: _trendingOffset.value,
        limit: _pageSize,
      );
      trendingSongs.assignAll(songs);
      _trendingLoaded.value = true;
      _trendingHasMore.value = songs.length >= _pageSize;
      print("Trending Songs Loaded: ${trendingSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreTrendingSongs() async {
    if (_trendingLoadingMore.value || !_trendingHasMore.value) return;

    try {
      _trendingLoadingMore.value = true;
      _trendingOffset.value += _pageSize;
      final songs = await _repository.getTrendingSongs(
        offset: _trendingOffset.value,
        limit: _pageSize,
      );
      if (songs.isEmpty) {
        _trendingHasMore.value = false;
      } else {
        trendingSongs.addAll(songs);
        _trendingHasMore.value = songs.length >= _pageSize;
      }
      print(
        "More Trending Songs Loaded: ${songs.length}, Total: ${trendingSongs.length}",
      );
    } catch (e) {
      print(e);
      _trendingOffset.value -= _pageSize;
    } finally {
      _trendingLoadingMore.value = false;
    }
  }

  void resetTrendingPagination() {
    _trendingOffset.value = 0;
    _trendingHasMore.value = true;
    _trendingLoaded.value = false;
    _trendingLoadingMore.value = false;
  }

  Future<void> loadLatestSongs() async {
    if (_latestLoaded.value && latestSongs.isNotEmpty) return;

    try {
      isLoading.value = true;
      final songs = await _repository.getLatestSongs();
      latestSongs.assignAll(songs);
      _latestLoaded.value = true;
      print("Latest Songs Loaded: ${latestSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMostLovedSongs() async {
    if (_mostLovedLoaded.value && mostLovedSongs.isNotEmpty) return;

    try {
      isLoading.value = true;
      final songs = await _repository.getMostLovedSongs();
      mostLovedSongs.assignAll(songs);
      _mostLovedLoaded.value = true;
      print("Most Loved Songs Loaded: ${mostLovedSongs.length}");
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRecommendedSongs() async {
    if (_recommendedLoaded.value && recommendedSongs.isNotEmpty) return;

    try {
      isLoading.value = true;
      final songs = await _repository.getRecommendedSongs();
      recommendedSongs.assignAll(songs);
      _recommendedLoaded.value = true;
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

  Future<void> refreshTrendingSongs() async {
    resetTrendingPagination();
    await loadTrendingSongs();
  }

  Future<void> refreshFavoriteSongs() async {
    // Favorites are stored locally, no need to refresh from API
  }
}

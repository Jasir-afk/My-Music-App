import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/src/modules/homescreen/model/track_model.dart';
import 'package:my_musics/src/modules/homescreen/repo/home_repo.dart';

class ArtistDetailController extends GetxController {
  final HomeRepository _repository = HomeRepository();

  RxList<TrackModel> songs = <TrackModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;

  final RxInt _offset = 0.obs;
  final int _pageSize = 20;

  String artistName = '';
  late ScrollController scrollController;
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreSongs();
    }
  }

  Future<void> loadSongs() async {
    if (artistName.isEmpty) return;

    try {
      isLoading.value = true;
      _offset.value = 0;
      hasMore.value = true;

      final fetchedSongs = await _repository.getSongsByArtist(
        artistName: artistName,
        offset: _offset.value,
        limit: _pageSize,
      );

      songs.assignAll(fetchedSongs);
      hasMore.value = fetchedSongs.length >= _pageSize;
    } catch (e) {
      print('Error loading artist songs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreSongs() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      _offset.value += _pageSize;

      final fetchedSongs = await _repository.getSongsByArtist(
        artistName: artistName,
        offset: _offset.value,
        limit: _pageSize,
      );

      if (fetchedSongs.isEmpty) {
        hasMore.value = false;
      } else {
        songs.addAll(fetchedSongs);
        hasMore.value = fetchedSongs.length >= _pageSize;
      }
    } catch (e) {
      print('Error loading more artist songs: $e');
      _offset.value -= _pageSize;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refresh() async {
    await loadSongs();
  }
}

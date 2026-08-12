import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HomeController homeController = HomeController.to;
  final PlaybackService audioService = PlaybackService.to;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  RxString searchQuery = ''.obs;
  RxList<String> recentSearches = <String>[].obs;

  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchFocusNode.requestFocus();
    _searchController.addListener(() {
      searchQuery.value = _searchController.text;
      if (_searchController.text.trim().isNotEmpty) {
        homeController.searchSongs(_searchController.text);
        _saveRecentSearch(_searchController.text);

        // Only search for artists if the query appears to be an artist name
        // Check if query matches artist names in results
        Future.delayed(const Duration(milliseconds: 300), () {
          if (homeController.trendingSongs.isNotEmpty) {
            final queryLower = _searchController.text.toLowerCase();
            final hasArtistMatch = homeController.trendingSongs.any(
              (song) =>
                  (song.artist?.toLowerCase().contains(queryLower) ?? false) ||
                  (song.artist?.toLowerCase() == queryLower),
            );

            if (hasArtistMatch) {
              homeController.searchArtists(_searchController.text);
            }

            // Fetch related songs after search completes
            final firstSong = homeController.trendingSongs.first;
            if (firstSong.artist != null) {
              homeController.loadRelatedSongs(
                firstSong.artist!,
                excludeTrackId: firstSong.id,
              );
            }
          }
        });
      }
    });
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];
    recentSearches.value = searches;
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recent_searches') ?? [];

    // Remove if already exists
    searches.remove(query);

    // Add to beginning
    searches.insert(0, query);

    // Keep only last 10
    if (searches.length > 10) {
      searches.removeRange(10, searches.length);
    }

    await prefs.setStringList('recent_searches', searches);
    recentSearches.value = searches;
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recent_searches');
    recentSearches.value = [];
  }

  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: const TextStyle(color: AppColors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Search songs, artists...",
              hintStyle: const TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              suffixIcon: Obx(() {
                if (searchQuery.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    searchQuery.value = '';
                    homeController.loadTrendingSongs();
                  },
                );
              }),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (searchQuery.value.isEmpty) {
          return _buildRecentSearches();
        }

        if (homeController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (homeController.trendingSongs.isEmpty) {
          return const SizedBox.shrink();
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (searchQuery.value.isNotEmpty) {
              await homeController.searchSongs(searchQuery.value);
            } else {
              await homeController.loadTrendingSongs();
            }
          },
          color: AppColors.primary,
          backgroundColor: AppColors.card,
          child: _buildSearchResults(),
        );
      }),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Obx(
                () => recentSearches.isNotEmpty
                    ? GestureDetector(
                        onTap: _clearRecentSearches,
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (recentSearches.isEmpty) {
              return const Text(
                'Start typing to search...',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((query) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = query;
                    searchQuery.value = query;
                    homeController.searchSongs(query);
                    _saveRecentSearch(query);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          color: AppColors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          query,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return CustomScrollView(
      slivers: [
        // Artists Section
        Obx(() {
          if (homeController.artists.isEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Artists',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: homeController.artists.length,
                    itemBuilder: (context, index) {
                      final artist = homeController.artists[index];
                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _searchController.text = artist.name ?? '';
                                searchQuery.value = artist.name ?? '';
                                homeController.searchSongs(artist.name ?? '');
                                _saveRecentSearch(artist.name ?? '');
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:
                                    artist.image != null &&
                                        artist.image!.isNotEmpty
                                    ? Image.network(
                                        artist.image!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: AppColors.card,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  color:
                                                      AppColors.textSecondary,
                                                  size: 40,
                                                ),
                                              );
                                            },
                                      )
                                    : Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.card,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: AppColors.textSecondary,
                                          size: 40,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artist.name ?? 'Unknown',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            if (artist.trackCount != null)
                              Text(
                                '${artist.trackCount} songs',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }),

        // Search Results Section
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Search Results',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homeController.trendingSongs.length,
                itemBuilder: (context, index) {
                  final song = homeController.trendingSongs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: song.artwork != null && song.artwork!.isNotEmpty
                            ? Image.network(
                                song.artwork!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.card,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.music_note_rounded,
                                      color: AppColors.textSecondary,
                                      size: 28,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.music_note_rounded,
                                  color: AppColors.textSecondary,
                                  size: 28,
                                ),
                              ),
                      ),
                      title: Text(
                        song.title ?? 'Unknown',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        song.artist ?? 'Unknown',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Obx(() {
                        final isCurrentTrack =
                            audioService.currentTrack.value?.id == song.id;
                        final isPlaying =
                            audioService.isPlaying.value && isCurrentTrack;
                        return IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_rounded
                                : Icons.play_circle_outline_rounded,
                            color: isPlaying
                                ? AppColors.primary
                                : AppColors.primary,
                            size: 32,
                          ),
                          onPressed: () {
                            if (isCurrentTrack) {
                              audioService.togglePlayPause();
                            } else {
                              audioService.setPlaylist(
                                homeController.trendingSongs,
                                index,
                              );
                            }
                          },
                        );
                      }),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Related Songs Section
        Obx(() {
          if (homeController.relatedSongs.isEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }

          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Related Songs',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: homeController.relatedSongs.length,
                  itemBuilder: (context, index) {
                    final song = homeController.relatedSongs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              song.artwork != null && song.artwork!.isNotEmpty
                              ? Image.network(
                                  song.artwork!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: AppColors.card,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.music_note_rounded,
                                        color: AppColors.textSecondary,
                                        size: 28,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.music_note_rounded,
                                    color: AppColors.textSecondary,
                                    size: 28,
                                  ),
                                ),
                        ),
                        title: Text(
                          song.title ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          song.artist ?? 'Unknown',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Obx(() {
                          final isCurrentTrack =
                              audioService.currentTrack.value?.id == song.id;
                          final isPlaying =
                              audioService.isPlaying.value && isCurrentTrack;
                          return IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_rounded
                                  : Icons.play_circle_outline_rounded,
                              color: isPlaying
                                  ? AppColors.primary
                                  : AppColors.primary,
                              size: 32,
                            ),
                            onPressed: () {
                              if (isCurrentTrack) {
                                audioService.togglePlayPause();
                              } else {
                                audioService.setPlaylist(
                                  homeController.relatedSongs,
                                  index,
                                );
                              }
                            },
                          );
                        }),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        }),
      ],
    );
  }
}

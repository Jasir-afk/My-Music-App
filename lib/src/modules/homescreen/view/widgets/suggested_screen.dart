import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/src/app_cards/ArtistCard.dart';
import 'package:my_musics/src/app_cards/SongCard.dart';
import 'package:my_musics/src/modules/dashboard/controller/tab_controller.dart';
import 'package:my_musics/src/modules/homescreen/controller/home_controller.dart';
import 'package:my_musics/app/services/audio_service.dart';
import 'package:my_musics/src/modules/homescreen/view/artist_detail_screen.dart';

class HeroBanner {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String badge;

  HeroBanner({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

class HeroBannerCarousel extends StatefulWidget {
  const HeroBannerCarousel({super.key});

  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  final List<HeroBanner> _banners = [
    HeroBanner(
      imageUrl: 'assets/hero_banner.png',
      title: 'My Music',
      subtitle: 'Your personal music library',
      badge: '100% FREE',
    ),
    HeroBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&auto=format&fit=crop&q=80',
      title: 'Create Playlists',
      subtitle: 'Your music, your way',
      badge: 'UNLIMITED',
    ),
    HeroBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&auto=format&fit=crop&q=80',
      title: 'Listen Anywhere',
      subtitle: 'Offline mode available',
      badge: 'NO ADS',
    ),
    HeroBanner(
      imageUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&auto=format&fit=crop&q=80',
      title: 'Discover New Artists',
      subtitle: 'Find your next favorite artist',
      badge: 'EXPLORE',
    ),
  ];

  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (_currentPage < _banners.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoSlide();
      }
    });
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.card,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  banner.imageUrl.startsWith('http')
                      ? Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.accent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            );
                          },
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.background.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            banner.badge,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          banner.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          banner.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SuggestedScreen extends StatefulWidget {
  const SuggestedScreen({super.key});

  State<SuggestedScreen> createState() => _SuggestedScreenState();
}

class _SuggestedScreenState extends State<SuggestedScreen> {
  final HomeController controller = HomeController.to;
  final PlaybackService audioService = PlaybackService.to;
  final ScrollController _scrollController = ScrollController();

  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      controller.loadMoreTrendingSongs();
    }
  }

  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshTrendingSongs,
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner Carousel
            const HeroBannerCarousel(),
            const SizedBox(height: 30),

            _sectionHeader(
              "Most Popular",
              onViewAll: () {
                // Switch to trending tab
                final tabController = Get.find<TabBarController>();
                tabController.tabController.animateTo(1);
              },
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Sort by play count descending for "Most Popular"
                final popularSongs = [...controller.trendingSongs]
                  ..sort(
                    (a, b) => (b.playCount ?? 0).compareTo(a.playCount ?? 0),
                  );
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final song = popularSongs[index];
                    return Songcard(
                      title: song.title ?? 'Unknown',
                      artist: song.artist ?? 'Unknown',
                      album: song.genre ?? '',
                      image: song.artwork ?? '',
                      onTap: () {
                        audioService.setPlaylist(popularSongs, index);
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 30),
            _sectionHeader("Artists"),
            const SizedBox(height: 15),
            SizedBox(
              height: 130,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Extract unique artists from trending songs
                final Map<String, Map<String, dynamic>> artistMap = {};
                for (final song in controller.trendingSongs) {
                  final artistName = song.artist ?? 'Unknown';
                  if (!artistMap.containsKey(artistName)) {
                    artistMap[artistName] = {
                      'name': artistName,
                      'image': song.artistImage ?? '',
                      // Prefer actual track count from API; fall back to 1
                      'trackCount': song.artistTrackCount ?? 1,
                      'followerCount': song.artistFollowerCount ?? 0,
                    };
                  }
                }

                final artists = artistMap.values.toList();

                if (artists.isEmpty) {
                  return const Center(
                    child: Text(
                      'No artists found',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: artists.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final artist = artists[index];
                    final trackCount = artist['trackCount'] as int;
                    final followerCount = artist['followerCount'] as int;

                    // Format large numbers nicely
                    String formatCount(int n) {
                      if (n >= 1000000) {
                        return '${(n / 1000000).toStringAsFixed(1)}M';
                      }
                      if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
                      return '$n';
                    }

                    final subtitle = followerCount > 0
                        ? '${formatCount(followerCount)} followers'
                        : '${formatCount(trackCount)} ${trackCount == 1 ? 'Track' : 'Tracks'}';

                    return ArtistCard(
                      name: artist['name'] as String,
                      subtitle: subtitle,
                      image: artist['image'] as String,
                      onTap: () {
                        Get.to(
                          () => ArtistDetailScreen(
                            artistName: artist['name'] as String,
                            artistImage: artist['image'] as String,
                            subtitle: subtitle,
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 30),

            _sectionHeader("Most Favorited"),
            const SizedBox(height: 15),
            SizedBox(
              height: 240,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Sort by favorite count descending for "Most Favorited"
                final favoritedSongs = [...controller.trendingSongs]
                  ..sort(
                    (a, b) =>
                        (b.favoriteCount ?? 0).compareTo(a.favoriteCount ?? 0),
                  );
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoritedSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    final song = favoritedSongs[index];
                    return Songcard(
                      title: song.title ?? 'Unknown',
                      artist: song.artist ?? 'Unknown',
                      album: song.genre ?? '',
                      image: song.artwork ?? '',
                      onTap: () {
                        audioService.setPlaylist(favoritedSongs, index);
                      },
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 30),

            // Loading indicator for pagination
            Obx(() {
              if (controller.isTrendingLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onViewAll != null)
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "View All",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

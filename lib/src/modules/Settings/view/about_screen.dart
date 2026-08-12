import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        title: const Text(
          'About',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // App Name
            const Text(
              'My Music',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Version
            // Text(
            //   'Version 1.0.0 (Build 240)',
            //   style: TextStyle(
            //     color: AppColors.textSecondary.withOpacity(0.8),
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            // const SizedBox(height: 32),

            // Description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'My Music is a modern music streaming application that brings you the best music experience. Discover new tracks, create playlists, and enjoy high-quality audio streaming.',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.9),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Features Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Features',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              icon: Icons.trending_up_rounded,
              title: 'Trending Music',
              description: 'Discover the hottest tracks',
            ),
            _buildFeatureItem(
              icon: Icons.playlist_play_rounded,
              title: 'Custom Playlists',
              description: 'Create and manage your playlists',
            ),
            _buildFeatureItem(
              icon: Icons.high_quality_rounded,
              title: 'High Quality Audio',
              description: 'Stream at 320kbps',
            ),
            _buildFeatureItem(
              icon: Icons.favorite_rounded,
              title: 'Favorites',
              description: 'Save your favorite tracks',
            ),
            _buildFeatureItem(
              icon: Icons.download_rounded,
              title: 'Offline Mode',
              description: 'Download for offline listening',
            ),
            const SizedBox(height: 32),

            // Links Section
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Links',
            //     style: TextStyle(
            //       color: AppColors.white,
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            // _buildLinkTile(
            //   icon: Icons.privacy_tip_rounded,
            //   title: 'Privacy Policy',
            //   onTap: () => _launchUrl('https://example.com/privacy'),
            // ),
            // _buildLinkTile(
            //   icon: Icons.description_rounded,
            //   title: 'Terms of Service',
            //   onTap: () => _launchUrl('https://example.com/terms'),
            // ),
            // _buildLinkTile(
            //   icon: Icons.support_agent_rounded,
            //   title: 'Support',
            //   onTap: () => _launchUrl('https://example.com/support'),
            // ),
            // _buildLinkTile(
            //   icon: Icons.rate_review_rounded,
            //   title: 'Rate Us',
            //   onTap: () => _launchUrl('https://example.com/rate'),
            // ),
            // const SizedBox(height: 32),

            // Copyright
            Text(
              '© 2024 My Music. All rights reserved.',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Made with ❤️ for music lovers',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

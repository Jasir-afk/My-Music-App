import 'package:flutter/material.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.album_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text(
              "No albums yet",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

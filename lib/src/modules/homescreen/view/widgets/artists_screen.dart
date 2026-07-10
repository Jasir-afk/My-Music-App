import 'package:flutter/material.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class ArtistsScreen extends StatelessWidget {
  const ArtistsScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_rounded, size: 48, color: AppColors.textHint),
            const SizedBox(height: 16),
            const Text(
              "No artists yet",
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

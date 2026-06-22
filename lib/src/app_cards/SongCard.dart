import 'package:flutter/material.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class Songcard extends StatelessWidget {
  final String title;
  final String artist;
  final String album;
  final String image;
  final VoidCallback onTap;

  const Songcard({
    super.key,
    required this.title,
    required this.artist,
    required this.album,
    required this.image,
    required this.onTap,
  });

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // song cover
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                image,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),

            // song title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Artist Name
            Text(
              artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

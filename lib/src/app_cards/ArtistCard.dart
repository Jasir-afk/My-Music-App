import 'package:flutter/material.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String image;
  final String subtitle; // e.g. "1 Album | 20 Songs"
  final VoidCallback onTap;

  const ArtistCard({
    super.key,
    required this.name,
    required this.image,
    required this.subtitle,
    required this.onTap,
  });

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            // Circular artist image
            ClipOval(
              child: Image.network(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey[800],
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // Artist name
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),

            // Subtitle (album/song count)
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

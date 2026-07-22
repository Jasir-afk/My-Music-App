import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color primary = Color(0xFFFD3C5B); // Crimson Red
  static const Color primaryLight = Color(0xFFFF6B81);
  static const Color primaryDark = Color(0xFFC91E3A);

  static const Color accent = Color(0xFFC77DFF); // Light violet/purple accent
  static const Color accentLight = Color(0xFFE0AAFF);

  // Background Colors
  static const Color background = Color(
    0xFF0F0F13,
  ); // Deep slate-dark background
  static const Color scaffold = Color(0xFF0F0F13);
  static const Color card = Color(0xFF1B1B22); // Card color
  static const Color surface = Color(0xFF262630); // Raised elements

  // Text Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF8F8F99); // Subtle gray-blue text
  static const Color textHint = Color(0xFF5A5A66);

  // Icon Colors
  static const Color icon = Colors.white;
  static const Color iconInactive = Color(0xFF72727D);

  // Divider & Border
  static const Color divider = Color(0xFF22222B);
  static const Color border = Color(0xFF282835);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF1744);
  static const Color warning = Color(0xFFFFD740);
  static const Color info = Color(0xFF40C4FF);

  // Player Colors
  static const Color playButton = primary;
  static const Color progress = primary;
  static const Color progressBackground = Color(0xFF282835);

  // Navigation
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFF72727D);

  // Gradient helpers
  static const List<Color> primaryGradient = [
    Color(0xFFFD3C5B),
    Color(0xFFFF6B81),
  ];
  static const List<Color> accentGradient = [
    Color(0xFFC77DFF),
    Color(0xFFE0AAFF),
  ];
  static const List<Color> subtleGradient = [
    Color(0xFFFD3C5B),
    Color(0xFFC77DFF),
  ];

  static const Color transparent = Colors.transparent;
}

class AppColorsLight {
  AppColorsLight._();
  static const Color primary = Color(0xFFFD3C5B); // Crimson Red
  static const Color primaryLight = Color(0xFFFF6B81);
  static const Color primaryDark = Color(0xFFC91E3A);

  static const Color accent = Color(0xFFC77DFF); // Light violet/purple accent
  static const Color accentLight = Color(0xFFE0AAFF);

  // Background Colors
  static const Color background = Color(0xFFF5F5F7); // Light gray background
  static const Color scaffold = Color(0xFFF5F5F7);
  static const Color card = Color(0xFFFFFFFF); // White card color
  static const Color surface = Color(0xFFE8E8ED); // Light gray surface

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C1E); // Dark text
  static const Color textSecondary = Color(0xFF636366); // Medium gray text
  static const Color textHint = Color(0xFFAEAEB2); // Light gray hint text

  // Icon Colors
  static const Color icon = Color(0xFF1C1C1E);
  static const Color iconInactive = Color(0xFFAEAEB2);

  // Divider & Border
  static const Color divider = Color(0xFFE5E5EA);
  static const Color border = Color(0xFFD1D1D6);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);

  // Player Colors
  static const Color playButton = primary;
  static const Color progress = primary;
  static const Color progressBackground = Color(0xFFE5E5EA);

  // Navigation
  static const Color navSelected = primary;
  static const Color navUnselected = Color(0xFFAEAEB2);
}

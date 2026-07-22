import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/app/services/theme_service.dart';

class ThemeColors {
  ThemeColors._();

  static final ThemeService _themeService = Get.find<ThemeService>();

  static bool get _isDark => _themeService.isDarkMode.value;

  static Color get background =>
      _isDark ? AppColors.background : AppColorsLight.background;

  static Color get card => _isDark ? AppColors.card : AppColorsLight.card;

  static Color get surface =>
      _isDark ? AppColors.surface : AppColorsLight.surface;

  static Color get textPrimary =>
      _isDark ? AppColors.textPrimary : AppColorsLight.textPrimary;

  static Color get textSecondary =>
      _isDark ? AppColors.textSecondary : AppColorsLight.textSecondary;

  static Color get textHint =>
      _isDark ? AppColors.textHint : AppColorsLight.textHint;

  static Color get icon => _isDark ? AppColors.icon : AppColorsLight.icon;

  static Color get border => _isDark ? AppColors.border : AppColorsLight.border;

  static Color get divider =>
      _isDark ? AppColors.divider : AppColorsLight.divider;
}

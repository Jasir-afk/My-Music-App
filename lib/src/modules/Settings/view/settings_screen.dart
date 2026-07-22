import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';
import 'package:my_musics/app/services/auth_service.dart';
import 'package:my_musics/app/services/theme_service.dart';
import 'package:my_musics/src/modules/Settings/view/equalizer_screen.dart';
import 'package:my_musics/src/modules/Settings/view/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final RxBool isHighQuality = true.obs;
  final RxBool isOfflineMode = false.obs;
  final RxBool isNotificationsEnabled = true.obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxDouble cacheSize = 0.0.obs;

  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Chinese',
  ];

  late ThemeService _themeService;

  void onInit() {
    super.onInit();
    _themeService = Get.find<ThemeService>();
    _loadSettings();
    _calculateCacheSize();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isHighQuality.value = prefs.getBool('high_quality') ?? true;
    isOfflineMode.value = prefs.getBool('offline_mode') ?? false;
    isNotificationsEnabled.value =
        prefs.getBool('notifications_enabled') ?? true;
    selectedLanguage.value = prefs.getString('language') ?? 'English';
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_quality', isHighQuality.value);
    await prefs.setBool('offline_mode', isOfflineMode.value);
    await prefs.setBool('notifications_enabled', isNotificationsEnabled.value);
    await prefs.setString('language', selectedLanguage.value);
  }

  void toggleHighQuality(bool value) {
    isHighQuality.value = value;
    _saveSettings();
  }

  void toggleOfflineMode(bool value) {
    isOfflineMode.value = value;
    _saveSettings();
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
    _saveSettings();
  }

  void toggleDarkMode(bool value) {
    _themeService.setTheme(value);
  }

  bool get isDarkMode => _themeService.isDarkMode.value;

  void setLanguage(String language) {
    selectedLanguage.value = language;
    _saveSettings();
  }

  Future<void> _calculateCacheSize() async {
    // Simulate cache size calculation
    cacheSize.value = 45.6; // MB
  }

  Future<void> clearCache() async {
    // Simulate cache clearing
    cacheSize.value = 0.0;
    Get.snackbar(
      'Cache Cleared',
      'All cached data has been removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.card,
      colorText: AppColors.white,
    );
  }

  Future<void> logout() async {
    final authService = Get.find<AuthService>();
    authService.logout();
    Get.offAllNamed('/login');
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&auto=format&fit=crop&q=60",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "John Johnson",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "john.johnson@example.com",
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "PREMIUM",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("Audio Playback"),
              Obx(
                () => _buildSettingTile(
                  icon: Icons.high_quality_rounded,
                  iconColor: const Color(0xFFC77DFF),
                  title: "High Quality Audio",
                  subtitle: "Stream at 320kbps for premium sound",
                  trailing: Switch(
                    value: controller.isHighQuality.value,
                    activeColor: AppColors.primary,
                    onChanged: controller.toggleHighQuality,
                  ),
                ),
              ),
              _buildSettingTile(
                icon: Icons.equalizer_rounded,
                iconColor: const Color(0xFFFFB703),
                title: "Equalizer",
                subtitle: "Adjust frequency bands & custom presets",
                onTap: () => Get.to(() => const EqualizerScreen()),
              ),
              Obx(
                () => _buildSettingTile(
                  icon: Icons.download_done_rounded,
                  iconColor: const Color(0xFF00E676),
                  title: "Offline Mode",
                  subtitle: "Only play downloaded tracks",
                  trailing: Switch(
                    value: controller.isOfflineMode.value,
                    activeColor: AppColors.primary,
                    onChanged: controller.toggleOfflineMode,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle("Notifications"),
              Obx(
                () => _buildSettingTile(
                  icon: Icons.notifications_active_rounded,
                  iconColor: const Color(0xFF40C4FF),
                  title: "Push Notifications",
                  subtitle: "Get updates on new releases & playlists",
                  trailing: Switch(
                    value: controller.isNotificationsEnabled.value,
                    activeColor: AppColors.primary,
                    onChanged: controller.toggleNotifications,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle("Appearance"),
              Obx(
                () => _buildSettingTile(
                  icon: Icons.dark_mode_rounded,
                  iconColor: const Color(0xFF7C4DFF),
                  title: "Dark Mode",
                  subtitle: "Switch between light and dark theme",
                  trailing: Switch(
                    value: ThemeService.to.isDarkMode.value,
                    activeColor: AppColors.primary,
                    onChanged: (value) => controller.toggleDarkMode(value),
                  ),
                ),
              ),
              _buildSettingTile(
                icon: Icons.language_rounded,
                iconColor: const Color(0xFF00BFA5),
                title: "Language",
                subtitle: controller.selectedLanguage.value,
                onTap: () => _showLanguageDialog(controller),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle("Storage"),
              Obx(
                () => _buildSettingTile(
                  icon: Icons.storage_rounded,
                  iconColor: const Color(0xFFFF6E40),
                  title: "Cache Size",
                  subtitle:
                      "${controller.cacheSize.value.toStringAsFixed(1)} MB",
                  onTap: () => _showCacheDialog(controller),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle("General"),
              _buildSettingTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.textSecondary,
                title: "About My Music",
                subtitle: "Version 1.0.0 (Build 240)",
                onTap: () => Get.to(() => const AboutScreen()),
              ),
              _buildSettingTile(
                icon: Icons.logout_rounded,
                iconColor: AppColors.primary,
                title: "Log Out",
                subtitle: "Sign out of your account",
                onTap: () {
                  Get.defaultDialog(
                    title: "Log Out",
                    titleStyle: const TextStyle(color: AppColors.white),
                    middleText: "Are you sure you want to log out?",
                    middleTextStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.card,
                    textConfirm: "Yes",
                    textCancel: "Cancel",
                    confirmTextColor: AppColors.white,
                    cancelTextColor: AppColors.primary,
                    buttonColor: AppColors.primary,
                    onConfirm: controller.logout,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          "Select Language",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.languages.length,
            itemBuilder: (context, index) {
              final language = controller.languages[index];
              return Obx(
                () => ListTile(
                  title: Text(
                    language,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  trailing: controller.selectedLanguage.value == language
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    controller.setLanguage(language);
                    Get.back();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCacheDialog(SettingsController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text(
          "Clear Cache",
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                "Current cache size: ${controller.cacheSize.value.toStringAsFixed(1)} MB",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Clearing cache will remove all downloaded music and images. This action cannot be undone.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.clearCache();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              "Clear Cache",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.textSecondary.withOpacity(0.6),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textSecondary,
                    size: 14,
                  )
                : null),
      ),
    );
  }
}

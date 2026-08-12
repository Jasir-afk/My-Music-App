import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_musics/app/theme_data/app_colors.dart';

class EqualizerController extends GetxController {
  final RxDouble bass = 0.0.obs;
  final RxDouble mid = 0.0.obs;
  final RxDouble treble = 0.0.obs;
  final RxString selectedPreset = 'Flat'.obs;

  final List<String> presets = [
    'Flat',
    'Bass Boost',
    'Treble Boost',
    'Vocal',
    'Rock',
    'Pop',
    'Jazz',
    'Classical',
  ];

  void setPreset(String preset) {
    selectedPreset.value = preset;
    switch (preset) {
      case 'Flat':
        bass.value = 0.0;
        mid.value = 0.0;
        treble.value = 0.0;
        break;
      case 'Bass Boost':
        bass.value = 0.8;
        mid.value = 0.2;
        treble.value = 0.0;
        break;
      case 'Treble Boost':
        bass.value = 0.0;
        mid.value = 0.2;
        treble.value = 0.8;
        break;
      case 'Vocal':
        bass.value = -0.2;
        mid.value = 0.6;
        treble.value = 0.3;
        break;
      case 'Rock':
        bass.value = 0.6;
        mid.value = 0.3;
        treble.value = 0.4;
        break;
      case 'Pop':
        bass.value = 0.4;
        mid.value = 0.5;
        treble.value = 0.3;
        break;
      case 'Jazz':
        bass.value = 0.3;
        mid.value = 0.4;
        treble.value = 0.5;
        break;
      case 'Classical':
        bass.value = 0.2;
        mid.value = 0.3;
        treble.value = 0.6;
        break;
    }
  }

  void reset() {
    setPreset('Flat');
  }
}

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});

  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  late final EqualizerController controller;

  void initState() {
    super.initState();
    controller = Get.put(EqualizerController(), tag: 'equalizer');
  }

  void dispose() {
    Get.delete<EqualizerController>(tag: 'equalizer');
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
        title: const Text(
          'Equalizer',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() => TextButton(
                onPressed: controller.selectedPreset.value != 'Flat'
                    ? controller.reset
                    : null,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: controller.selectedPreset.value != 'Flat'
                        ? AppColors.primary
                        : AppColors.textHint,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Presets Section
                const Text(
                  'Presets',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: controller.presets.map((preset) {
                    final isSelected =
                        controller.selectedPreset.value == preset;
                    return FilterChip(
                      label: Text(preset),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      selected: isSelected,
                      onSelected: (_) => controller.setPreset(preset),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.card,
                      checkmarkColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Frequency Bands Section
                const Text(
                  'Frequency Bands',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Bass Slider
                _buildSlider(
                  label: 'Bass',
                  value: controller.bass.value,
                  onChanged: (value) => controller.bass.value = value,
                  color: const Color(0xFFC77DFF),
                ),
                const SizedBox(height: 24),

                // Mid Slider
                _buildSlider(
                  label: 'Mid',
                  value: controller.mid.value,
                  onChanged: (value) => controller.mid.value = value,
                  color: const Color(0xFFFFB703),
                ),
                const SizedBox(height: 24),

                // Treble Slider
                _buildSlider(
                  label: 'Treble',
                  value: controller.treble.value,
                  onChanged: (value) => controller.treble.value = value,
                  color: const Color(0xFF00E676),
                ),
                const SizedBox(height: 32),

                // Visualizer
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: EqualizerPainter(
                      bass: controller.bass.value,
                      mid: controller.mid.value,
                      treble: controller.treble.value,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(value * 10).toInt()} dB',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.border,
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: -1.0,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class EqualizerPainter extends CustomPainter {
  final double bass;
  final double mid;
  final double treble;

  EqualizerPainter({
    required this.bass,
    required this.mid,
    required this.treble,
  });

  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final barCount = 40;
    final barWidth = width / barCount - 2;
    final spacing = 2.0;

    for (int i = 0; i < barCount; i++) {
      final normalizedPos = i / barCount;

      double barHeight;
      if (normalizedPos < 0.33) {
        barHeight = height * (0.3 + bass * 0.5) * (0.6 + normalizedPos * 1.2);
      } else if (normalizedPos < 0.66) {
        barHeight =
            height * (0.3 + mid * 0.5) * (0.7 + (normalizedPos - 0.33) * 0.9);
      } else {
        barHeight = height *
            (0.3 + treble * 0.5) *
            (0.5 + (normalizedPos - 0.66) * 1.5);
      }

      barHeight = barHeight.clamp(height * 0.05, height * 0.9);

      final x = i * (barWidth + spacing) + spacing;
      final y = height - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(3),
      );

      final paint = Paint()..style = PaintingStyle.fill;

      final hue = 340 + normalizedPos * 40;
      paint.color = HSLColor.fromAHSL(1.0, hue, 0.7, 0.6).toColor();

      canvas.drawRRect(rect, paint);

      final glowPaint = Paint()
        ..color = paint.color.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawRRect(rect, glowPaint);
    }
  }

  bool shouldRepaint(EqualizerPainter oldDelegate) {
    return oldDelegate.bass != bass ||
        oldDelegate.mid != mid ||
        oldDelegate.treble != treble;
  }
}

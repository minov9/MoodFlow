import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/constants/mood_types.dart';
import '../core/theme/app_theme.dart';

/// 情绪选择器 - Apple 风格
class MoodPicker extends StatelessWidget {
  final MoodType? selectedMood;
  final ValueChanged<MoodType> onMoodSelected;

  const MoodPicker({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MoodType.values.map((mood) {
        final isSelected = selectedMood == mood;
        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: 60,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标容器
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? mood.color
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    mood.icon,
                    color: isSelected ? Colors.white : mood.color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                // 标签
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? mood.color : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

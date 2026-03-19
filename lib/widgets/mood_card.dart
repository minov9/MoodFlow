import 'package:flutter/material.dart';
import '../core/constants/mood_types.dart';
import '../core/theme/app_theme.dart';

/// 情绪卡片组件
class MoodCard extends StatelessWidget {
  final MoodType mood;
  final String dateLabel;
  final String? note;
  final VoidCallback? onTap;

  const MoodCard({
    super.key,
    required this.mood,
    required this.dateLabel,
    this.note,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 情绪图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: mood.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                mood.icon,
                color: mood.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mood.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        dateLabel,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      note!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

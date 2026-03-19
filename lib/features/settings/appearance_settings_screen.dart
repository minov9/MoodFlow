import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/settings_provider.dart';

/// 外观设置页 - 真正切换主题
class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: context.backgroundColor,
        border: null,
        middle: Text(
          '外观',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
            color: AppColors.primary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 预览卡片
          _ThemePreview(isDark: isDark),

          const SizedBox(height: 24),

          // 主题选项
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? [] : AppShadows.small,
            ),
            child: Column(
              children: [
                _ThemeOption(
                  title: '跟随系统',
                  subtitle: '自动适应系统深浅色设置',
                  icon: CupertinoIcons.device_phone_portrait,
                  isSelected: settings.themeMode == ThemeMode.system,
                  onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.system),
                ),
                Divider(
                  height: 0.5,
                  indent: 60,
                  color: context.dividerColor,
                ),
                _ThemeOption(
                  title: '浅色模式',
                  subtitle: '始终使用浅色外观',
                  icon: CupertinoIcons.sun_max_fill,
                  isSelected: settings.themeMode == ThemeMode.light,
                  onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.light),
                ),
                Divider(
                  height: 0.5,
                  indent: 60,
                  color: context.dividerColor,
                ),
                _ThemeOption(
                  title: '深色模式',
                  subtitle: '始终使用深色外观',
                  icon: CupertinoIcons.moon_fill,
                  isSelected: settings.themeMode == ThemeMode.dark,
                  onTap: () => ref.read(settingsProvider.notifier).setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '选择「跟随系统」后，MoodFlow 会自动跟随系统的深浅色模式切换外观。',
              style: TextStyle(
                fontSize: 14,
                color: context.textTertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 主题预览
class _ThemePreview extends StatelessWidget {
  final bool isDark;

  const _ThemePreview({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(colors: [Color(0xFF2C2C2E), Color(0xFF3A3A3C)])
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? [] : AppShadows.colored(AppColors.primary),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              isDark ? '深色模式' : '浅色模式',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              isDark ? '护眼舒适' : '明亮清新',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 主题选项
class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.primaryGradient : null,
                color: isSelected ? null : context.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : context.textSecondary,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                CupertinoIcons.checkmark_circle_fill,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

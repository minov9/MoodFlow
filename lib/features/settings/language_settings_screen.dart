import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/settings_provider.dart';

/// 语言设置页 - 支持深色模式和真正的语言切换
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentLanguage = settings.language;

    final options = [
      _LanguageOption(
        code: 'zh',
        title: '简体中文',
        subtitle: 'Chinese Simplified',
        flag: '🇨🇳',
      ),
      _LanguageOption(
        code: 'en',
        title: 'English',
        subtitle: '英文',
        flag: '🇺🇸',
      ),
    ];

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: context.backgroundColor,
        border: null,
        middle: Text(
          currentLanguage == 'zh' ? '语言' : 'Language',
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
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: context.isDark ? [] : AppShadows.small,
            ),
            child: Column(
              children: options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isSelected = option.code == currentLanguage;
                final isLast = index == options.length - 1;

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(settingsProvider.notifier).setLanguage(option.code);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  option.flag,
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    option.subtitle,
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
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 0.5,
                        indent: 70,
                        color: context.dividerColor,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              currentLanguage == 'zh'
                  ? '切换语言后，应用界面将显示为所选语言。'
                  : 'After switching, the app interface will display in the selected language.',
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

class _LanguageOption {
  final String code;
  final String title;
  final String subtitle;
  final String flag;

  _LanguageOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.flag,
  });
}

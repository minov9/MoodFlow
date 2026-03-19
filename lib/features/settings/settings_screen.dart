import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/settings_provider.dart';
import 'reminder_settings_screen.dart';
import 'appearance_settings_screen.dart';
import 'language_settings_screen.dart';
import 'export_data_screen.dart';
import 'data_sync_screen.dart';
import 'privacy_settings_screen.dart';
import 'about_screen.dart';

/// 设置页 - 支持深色模式和多语言
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isEn = settings.language == 'en';

    // 翻译字典
    final tr = isEn ? _enStrings : _zhStrings;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 渐变头部
          SliverToBoxAdapter(
            child: _SettingsHeader(title: tr['title']!),
          ),

          // 设置列表
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // 通用设置
                  _SettingsGroup(
                    children: [
                      _SettingsItem(
                        icon: CupertinoIcons.bell_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                        ),
                        title: tr['reminder']!,
                        trailing: Text(
                          settings.reminderEnabled
                              ? '${settings.reminderTime.hour.toString().padLeft(2, '0')}:${settings.reminderTime.minute.toString().padLeft(2, '0')}'
                              : tr['off']!,
                        ),
                        onTap: () => _navigateTo(context, const ReminderSettingsScreen()),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.paintbrush_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                        title: tr['appearance']!,
                        trailing: Text(isEn ? settings.themeMode.labelEn : settings.themeMode.label),
                        onTap: () => _navigateTo(context, const AppearanceSettingsScreen()),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.globe,
                        iconGradient: AppColors.calmGradient,
                        title: tr['language']!,
                        trailing: Text(settings.language == 'zh' ? '简体中文' : 'English'),
                        onTap: () => _navigateTo(context, const LanguageSettingsScreen()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 数据
                  _SettingsGroup(
                    children: [
                      _SettingsItem(
                        icon: CupertinoIcons.cloud_download_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        title: tr['exportData']!,
                        onTap: () => _navigateTo(context, const ExportDataScreen()),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.arrow_2_circlepath,
                        iconGradient: AppColors.warmGradient,
                        title: tr['dataSync']!,
                        trailing: Text(tr['notEnabled']!),
                        onTap: () => _navigateTo(context, const DataSyncScreen()),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.lock_shield_fill,
                        iconGradient: AppColors.primaryGradient,
                        title: tr['privacy']!,
                        onTap: () => _navigateTo(context, const PrivacySettingsScreen()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 关于
                  _SettingsGroup(
                    children: [
                      _SettingsItem(
                        icon: CupertinoIcons.info_circle_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
                        ),
                        title: tr['about']!,
                        trailing: Text('1.0.0'),
                        onTap: () => _navigateTo(context, const AboutScreen()),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.star_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFFFDC830), Color(0xFFF37335)],
                        ),
                        title: tr['rate']!,
                        onTap: () => _openAppStore(context, isEn),
                      ),
                      _SettingsItem(
                        icon: CupertinoIcons.heart_fill,
                        iconGradient: LinearGradient(
                          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
                        ),
                        title: tr['share']!,
                        onTap: () => _shareApp(isEn),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // 版权信息
                  Text(
                    'Made with ❤️',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textTertiary,
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      CupertinoPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _openAppStore(BuildContext context, bool isEn) async {
    const appStoreUrl = 'https://apps.apple.com/app/id123456789';
    final uri = Uri.parse(appStoreUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text(isEn ? 'Unable to open' : '暂时无法打开'),
            content: Text(isEn ? 'Please try again later' : '请稍后再试'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.of(context).pop(),
                child: Text(isEn ? 'OK' : '好的'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _shareApp(bool isEn) async {
    final message = isEn
        ? 'I\'m using MoodFlow to track my mood, check it out!\n\nDownload: https://apps.apple.com/app/moodflow'
        : '我正在使用 MoodFlow 记录每日心情，推荐给你！\n\n下载链接: https://apps.apple.com/app/moodflow';
    final subject = isEn
        ? 'Check out this awesome mood diary app!'
        : '推荐给你一个超棒的心情日记 App';

    await Share.share(
      message,
      subject: subject,
      sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100),
    );
  }
}

// 中文翻译
const _zhStrings = {
  'title': '设置',
  'reminder': '提醒设置',
  'appearance': '外观',
  'language': '语言',
  'exportData': '导出数据',
  'dataSync': '数据同步',
  'notEnabled': '未开启',
  'privacy': '隐私设置',
  'about': '关于 MoodFlow',
  'rate': '给个好评',
  'share': '分享给朋友',
  'off': '已关闭',
};

// 英文翻译
const _enStrings = {
  'title': 'Settings',
  'reminder': 'Reminder',
  'appearance': 'Appearance',
  'language': 'Language',
  'exportData': 'Export Data',
  'dataSync': 'Data Sync',
  'notEnabled': 'Not enabled',
  'privacy': 'Privacy',
  'about': 'About MoodFlow',
  'rate': 'Rate Us',
  'share': 'Share with Friends',
  'off': 'Off',
};

/// 设置页头部
class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: context.isDark ? 0.05 : 0.10),
            context.backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: context.textPrimary,
        ),
      ),
    );
  }
}

/// 设置分组
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 0.5,
                  indent: 60,
                  color: context.dividerColor,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// 设置项
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconGradient;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconGradient,
    required this.title,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: iconGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: context.textPrimary,
                ),
              ),
            ),
            if (trailing != null) ...[
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 15,
                  color: context.textTertiary,
                ),
                child: trailing!,
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              CupertinoIcons.chevron_right,
              color: context.textTertiary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

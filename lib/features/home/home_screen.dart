import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/mood_types.dart';
import '../../core/models/mood_entry.dart';
import '../../core/providers/mood_provider.dart';
import '../../core/providers/settings_provider.dart';

/// 首页 - 支持深色模式、语言切换和实时刷新
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentEntries = ref.watch(recentEntriesProvider);
    final todayMood = ref.watch(todayMoodProvider);
    final settings = ref.watch(settingsProvider);
    final isEn = settings.language == 'en';

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 顶部欢迎区域
          SliverToBoxAdapter(
            child: _WelcomeHeader(isEn: isEn),
          ),

          // 内容区域
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // 今日情绪卡片
                  _TodayMoodCard(
                    todayEntry: todayMood,
                    isEn: isEn,
                    onTap: () => context.push('/record'),
                  ),

                  const SizedBox(height: 32),

                  // 最近记录标题
                  Text(
                    isEn ? 'Recent Records' : '最近记录',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 水平滚动卡片
                  recentEntries.isEmpty
                      ? _EmptyState(isEn: isEn)
                      : _RecentMoodCards(entries: recentEntries),

                  const SizedBox(height: 32),

                  // 快捷入口
                  _QuickActions(isEn: isEn),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 欢迎头部
class _WelcomeHeader extends StatelessWidget {
  final bool isEn;

  const _WelcomeHeader({required this.isEn});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour, isEn);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: context.isDark ? 0.08 : 0.15),
            AppColors.accent.withValues(alpha: context.isDark ? 0.04 : 0.08),
            context.backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn ? 'Record now, meet a better you' : '记录此刻，遇见更好的自己',
            style: TextStyle(
              fontSize: 17,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour, bool isEn) {
    if (isEn) {
      if (hour < 6) return 'Good Night';
      if (hour < 12) return 'Good Morning';
      if (hour < 18) return 'Good Afternoon';
      return 'Good Evening';
    } else {
      if (hour < 6) return '夜深了';
      if (hour < 12) return '早上好';
      if (hour < 14) return '中午好';
      if (hour < 18) return '下午好';
      return '晚上好';
    }
  }
}

/// 今日情绪卡片
class _TodayMoodCard extends StatelessWidget {
  final MoodEntry? todayEntry;
  final bool isEn;
  final VoidCallback onTap;

  const _TodayMoodCard({
    required this.todayEntry,
    required this.isEn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: todayEntry != null
              ? todayEntry!.moodType.gradient
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.colored(
            todayEntry?.moodType.color ?? AppColors.primary,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 大型情绪图标
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      todayEntry?.moodType.emoji ?? '✨',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayEntry != null
                            ? (isEn ? "Today's Mood" : '今日心情')
                            : (isEn ? "Record Today's Mood" : '记录今天的心情'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        todayEntry != null
                            ? todayEntry!.moodType.description
                            : (isEn ? 'How are you feeling today?' : '你今天感觉怎么样？'),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 底部提示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    todayEntry != null ? CupertinoIcons.pencil : CupertinoIcons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    todayEntry != null
                        ? (isEn ? 'Edit Record' : '修改记录')
                        : (isEn ? 'Tap to Start' : '点击开始记录'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 空状态
class _EmptyState extends StatelessWidget {
  final bool isEn;

  const _EmptyState({required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '📝',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? 'No records yet' : '还没有记录',
            style: TextStyle(
              fontSize: 15,
              color: context.textSecondary,
            ),
          ),
          Text(
            isEn ? 'Start recording your first mood' : '开始记录你的第一个心情吧',
            style: TextStyle(
              fontSize: 13,
              color: context.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 最近情绪卡片
class _RecentMoodCards extends StatelessWidget {
  final List<MoodEntry> entries;

  const _RecentMoodCards({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: _MoodCard(entry: entry),
          );
        },
      ),
    );
  }
}

/// 单个情绪卡片
class _MoodCard extends StatelessWidget {
  final MoodEntry entry;

  const _MoodCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 情绪图标
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: entry.moodType.gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                entry.moodType.emoji,
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 笔记
          Text(
            entry.note ?? entry.moodType.description,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // 时间
          Text(
            entry.relativeTime,
            style: TextStyle(
              fontSize: 12,
              color: context.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 快捷入口
class _QuickActions extends StatelessWidget {
  final bool isEn;

  const _QuickActions({required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: CupertinoIcons.chart_bar_alt_fill,
            title: isEn ? 'Weekly Stats' : '本周统计',
            subtitle: isEn ? 'View mood trends' : '查看情绪趋势',
            gradient: AppColors.calmGradient,
            onTap: () => context.go('/stats'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: CupertinoIcons.calendar,
            title: isEn ? 'Calendar' : '日历',
            subtitle: isEn ? 'Review each day' : '回顾每一天',
            gradient: AppColors.warmGradient,
            onTap: () => context.go('/calendar'),
          ),
        ),
      ],
    );
  }
}

/// 快捷入口卡片
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: context.isDark ? [] : AppShadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
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
    );
  }
}

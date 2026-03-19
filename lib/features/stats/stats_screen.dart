import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/mood_types.dart';
import '../../core/data/mood_repository.dart';
import '../../core/providers/mood_provider.dart';
import '../../core/providers/settings_provider.dart';

/// 统计页 - 支持深色模式和语言切换
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final settings = ref.watch(settingsProvider);
    final isEn = settings.language == 'en';

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 渐变头部
          SliverToBoxAdapter(
            child: _StatsHeader(isEn: isEn),
          ),

          // 概览卡片
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _OverviewCards(stats: stats, isEn: isEn),
            ),
          ),

          // 趋势图
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _TrendSection(weeklyTrend: stats.weeklyTrend, isEn: isEn),
            ),
          ),

          // 情绪分布 - 环形图
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _DistributionSection(distribution: stats.moodDistribution, isEn: isEn),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

/// 统计页头部
class _StatsHeader extends StatelessWidget {
  final bool isEn;

  const _StatsHeader({required this.isEn});

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
            AppColors.primary.withValues(alpha: context.isDark ? 0.05 : 0.12),
            AppColors.accent.withValues(alpha: context.isDark ? 0.03 : 0.06),
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
            isEn ? 'Statistics' : '统计',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isEn ? 'Understand your mood patterns' : '了解你的情绪规律',
            style: TextStyle(
              fontSize: 17,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// 概览卡片组
class _OverviewCards extends StatelessWidget {
  final MoodStats stats;
  final bool isEn;

  const _OverviewCards({required this.stats, required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: isEn ? 'Days' : '记录天数',
            value: '${stats.totalDays}',
            icon: CupertinoIcons.calendar,
            gradient: AppColors.primaryGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: isEn ? 'Streak' : '连续记录',
            value: '${stats.streakDays}',
            icon: CupertinoIcons.flame_fill,
            gradient: AppColors.warmGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: isEn ? 'Avg Mood' : '平均心情',
            value: stats.averageMood?.emoji ?? '—',
            icon: CupertinoIcons.heart_fill,
            gradient: AppColors.calmGradient,
          ),
        ),
      ],
    );
  }
}

/// 单个统计卡片 - 渐变背景
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.9),
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// 趋势图区块
class _TrendSection extends StatelessWidget {
  final List<double> weeklyTrend;
  final bool isEn;

  const _TrendSection({required this.weeklyTrend, required this.isEn});

  @override
  Widget build(BuildContext context) {
    // 检查是否有数据
    final hasData = weeklyTrend.any((v) => v > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Weekly Trend' : '本周趋势',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: context.isDark ? [] : AppShadows.medium,
          ),
          child: hasData ? _buildTrendChart(context) : _buildEmptyChart(context),
        ),
      ],
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '📊',
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            isEn ? 'No data this week' : '暂无本周数据',
            style: TextStyle(
              fontSize: 15,
              color: context.textSecondary,
            ),
          ),
          Text(
            isEn ? 'Start recording to see trends' : '开始记录心情后会显示趋势',
            style: TextStyle(
              fontSize: 13,
              color: context.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    final days = isEn
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : ['一', '二', '三', '四', '五', '六', '日'];

    // 过滤有效数据点
    final spots = <FlSpot>[];
    for (int i = 0; i < weeklyTrend.length; i++) {
      if (weeklyTrend[i] > 0) {
        spots.add(FlSpot(i.toDouble(), weeklyTrend[i]));
      }
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.textTertiary,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: AppColors.primaryGradient,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: context.cardColor,
                  strokeWidth: 3,
                  strokeColor: AppColors.primary,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.25),
                  AppColors.accent.withValues(alpha: 0.05),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 情绪分布区块 - 环形图
class _DistributionSection extends StatelessWidget {
  final Map<MoodType, int> distribution;
  final bool isEn;

  const _DistributionSection({required this.distribution, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final total = distribution.values.fold(0, (sum, count) => sum + count);
    final hasData = total > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEn ? 'Mood Distribution' : '情绪分布',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: context.isDark ? [] : AppShadows.medium,
          ),
          child: hasData ? _buildChart(context, total) : _buildEmptyState(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🥧',
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              isEn ? 'No distribution data' : '暂无分布数据',
              style: TextStyle(
                fontSize: 15,
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, int total) {
    return Row(
      children: [
        // 环形图
        SizedBox(
          width: 120,
          height: 120,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: MoodType.values.map((mood) {
                final count = distribution[mood] ?? 0;
                if (count == 0) {
                  return PieChartSectionData(
                    value: 0,
                    color: Colors.transparent,
                    radius: 0,
                    showTitle: false,
                  );
                }
                return PieChartSectionData(
                  value: count.toDouble(),
                  color: mood.color,
                  radius: 25,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // 图例
        Expanded(
          child: Column(
            children: MoodType.values.map((mood) {
              final count = distribution[mood] ?? 0;
              if (count == 0) return const SizedBox.shrink();

              final percentage = (count / total * 100).round();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: mood.gradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          mood.emoji,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isEn ? mood.labelEn : mood.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: mood.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

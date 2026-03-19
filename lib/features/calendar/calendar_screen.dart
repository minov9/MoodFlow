import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/mood_types.dart';
import '../../core/models/mood_entry.dart';
import '../../core/providers/mood_provider.dart';
import '../../core/providers/settings_provider.dart';

/// 日历页 - 支持深色模式和语言切换
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();
  int? _selectedDay;

  Map<int, MoodEntry> _getMoodDataForMonth(List<MoodEntry> entries) {
    final result = <int, MoodEntry>{};
    for (final entry in entries) {
      if (entry.date.year == _focusedMonth.year &&
          entry.date.month == _focusedMonth.month) {
        result[entry.date.day] = entry;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final allEntries = ref.watch(moodProvider);
    final moodData = _getMoodDataForMonth(allEntries);
    final settings = ref.watch(settingsProvider);
    final isEn = settings.language == 'en';

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 渐变头部
          SliverToBoxAdapter(
            child: _CalendarHeader(
              focusedMonth: _focusedMonth,
              isEn: isEn,
              onPreviousMonth: () {
                setState(() {
                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                  _selectedDay = null;
                });
              },
              onNextMonth: () {
                setState(() {
                  _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                  _selectedDay = null;
                });
              },
            ),
          ),

          // 日历网格
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: context.isDark ? [] : AppShadows.medium,
                ),
                child: Column(
                  children: [
                    // 星期标题
                    _WeekdayHeader(isEn: isEn),
                    const SizedBox(height: 12),
                    // 日期网格
                    _buildCalendarGrid(moodData),
                  ],
                ),
              ),
            ),
          ),

          // 情绪图例
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _MoodLegend(isEn: isEn),
            ),
          ),

          // 选中日期详情
          if (_selectedDay != null && moodData[_selectedDay] != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SelectedDayCard(
                  entry: moodData[_selectedDay]!,
                  isEn: isEn,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(Map<int, MoodEntry> moodData) {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final startWeekday = firstDayOfMonth.weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        final dayOffset = index - startWeekday;
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final day = dayOffset + 1;
        final entry = moodData[day];
        final isToday = day == DateTime.now().day &&
            _focusedMonth.month == DateTime.now().month &&
            _focusedMonth.year == DateTime.now().year;
        final isSelected = day == _selectedDay;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: entry != null ? entry.moodType.gradient : null,
              color: entry == null ? (isToday ? context.backgroundColor : null) : null,
              borderRadius: BorderRadius.circular(12),
              border: isToday && entry == null
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
              boxShadow: isSelected ? AppShadows.small : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: entry != null
                      ? Colors.white
                      : (isToday ? AppColors.primary : context.textPrimary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 日历头部
class _CalendarHeader extends StatelessWidget {
  final DateTime focusedMonth;
  final bool isEn;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const _CalendarHeader({
    required this.focusedMonth,
    required this.isEn,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];

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
            AppColors.accent.withValues(alpha: context.isDark ? 0.05 : 0.12),
            AppColors.primary.withValues(alpha: context.isDark ? 0.03 : 0.06),
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
            isEn ? 'Calendar' : '日历',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 月份选择器
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: context.isDark ? [] : AppShadows.small,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: onPreviousMonth,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_left,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
                Text(
                  isEn
                      ? '${monthNames[focusedMonth.month - 1]} ${focusedMonth.year}'
                      : '${focusedMonth.year}年${focusedMonth.month}月',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: onNextMonth,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 星期标题行
class _WeekdayHeader extends StatelessWidget {
  final bool isEn;

  const _WeekdayHeader({required this.isEn});

  @override
  Widget build(BuildContext context) {
    final weekdays = isEn
        ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        : ['日', '一', '二', '三', '四', '五', '六'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textTertiary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 情绪图例
class _MoodLegend extends StatelessWidget {
  final bool isEn;

  const _MoodLegend({required this.isEn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: MoodType.values.map((mood) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: mood.gradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isEn ? mood.labelEn : mood.label,
                style: TextStyle(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// 选中日期详情卡片
class _SelectedDayCard extends StatelessWidget {
  final MoodEntry entry;
  final bool isEn;

  const _SelectedDayCard({required this.entry, required this.isEn});

  @override
  Widget build(BuildContext context) {
    final monthNames = isEn
        ? ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        : ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: entry.moodType.gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.colored(entry.moodType.color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 日期
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${entry.date.day}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      monthNames[entry.date.month - 1],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 情绪信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry.moodType.emoji,
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEn ? entry.moodType.labelEn : entry.moodType.label,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.note ?? entry.moodType.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

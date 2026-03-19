import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/mood_types.dart';
import '../../core/providers/mood_provider.dart';

/// 情绪记录页 - 支持深色模式和即时刷新
class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  MoodType? _selectedMood;
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // 顶部导航
          SliverAppBar(
            backgroundColor: context.backgroundColor,
            elevation: 0,
            floating: true,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: Text(
                '取消',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                ),
              ),
            ),
            actions: [
              CupertinoButton(
                padding: EdgeInsets.only(right: 16),
                onPressed: _selectedMood != null && !_isSaving ? _saveMood : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: _selectedMood != null && !_isSaving
                        ? AppColors.primaryGradient
                        : null,
                    color: _selectedMood == null || _isSaving
                        ? context.dividerColor
                        : null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '保存',
                          style: TextStyle(
                            color: _selectedMood != null
                                ? Colors.white
                                : context.textTertiary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),

          // 内容
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // 日期显示
                  _DateDisplay(),

                  const SizedBox(height: 32),

                  // 情绪选择
                  Text(
                    '你现在感觉如何？',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 大型情绪选择器
                  _MoodSelector(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood) {
                      setState(() => _selectedMood = mood);
                    },
                  ),

                  const SizedBox(height: 40),

                  // 笔记输入
                  Text(
                    '想说点什么？',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _NoteInput(controller: _noteController),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      // 通过 Provider 保存，自动触发 UI 刷新
      await ref.read(moodProvider.notifier).saveMood(
        mood: _selectedMood!,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      if (!mounted) return;

      // 直接返回主页
      context.go('/');
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('保存失败'),
          content: Text('请稍后再试'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('好的'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

/// 日期显示
class _DateDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['一', '二', '三', '四', '五', '六', '日'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                '${now.day}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${now.year}年${now.month}月${now.day}日',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              Text(
                '星期${weekdays[now.weekday - 1]}',
                style: TextStyle(
                  fontSize: 14,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 情绪选择器
class _MoodSelector extends StatelessWidget {
  final MoodType? selectedMood;
  final Function(MoodType) onMoodSelected;

  const _MoodSelector({
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: MoodType.values.map((mood) {
        final isSelected = selectedMood == mood;
        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: isSelected ? mood.gradient : null,
              color: isSelected ? null : context.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? AppShadows.colored(mood.color) : (context.isDark ? [] : AppShadows.small),
              border: isSelected
                  ? null
                  : Border.all(color: context.dividerColor, width: 1),
            ),
            child: Column(
              children: [
                Text(
                  mood.emoji,
                  style: TextStyle(fontSize: 36),
                ),
                SizedBox(height: 8),
                Text(
                  mood.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : context.textSecondary,
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

/// 笔记输入
class _NoteInput extends StatelessWidget {
  final TextEditingController controller;

  const _NoteInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.isDark ? [] : AppShadows.small,
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: TextStyle(
          fontSize: 16,
          color: context.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: '记录此刻的想法...',
          hintStyle: TextStyle(color: context.textTertiary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
      ),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mood_repository.dart';
import '../models/mood_entry.dart';
import '../constants/mood_types.dart';

/// 心情数据 Notifier - 管理即时刷新
class MoodNotifier extends Notifier<List<MoodEntry>> {
  @override
  List<MoodEntry> build() {
    return MoodRepository.getAllEntries();
  }

  /// 刷新数据
  void refresh() {
    state = MoodRepository.getAllEntries();
  }

  /// 保存心情并刷新
  Future<MoodEntry> saveMood({
    required MoodType mood,
    String? note,
    DateTime? date,
  }) async {
    final entry = await MoodRepository.saveMood(
      mood: mood,
      note: note,
      date: date,
    );
    refresh();
    return entry;
  }

  /// 删除记录并刷新
  Future<void> deleteEntry(String id) async {
    await MoodRepository.deleteEntry(id);
    refresh();
  }

  /// 清空所有并刷新
  Future<void> clearAll() async {
    await MoodRepository.clearAll();
    refresh();
  }
}

/// 心情数据 Provider
final moodProvider = NotifierProvider<MoodNotifier, List<MoodEntry>>(() {
  return MoodNotifier();
});

/// 今日心情 Provider
final todayMoodProvider = Provider<MoodEntry?>((ref) {
  final entries = ref.watch(moodProvider);
  final today = DateTime.now();
  final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

  try {
    return entries.firstWhere((e) => e.dateKey == todayKey);
  } catch (_) {
    return null;
  }
});

/// 统计数据 Provider
final statsProvider = Provider<MoodStats>((ref) {
  ref.watch(moodProvider); // 依赖 moodProvider 触发刷新
  return MoodRepository.getStats();
});

/// 最近记录 Provider
final recentEntriesProvider = Provider<List<MoodEntry>>((ref) {
  final entries = ref.watch(moodProvider);
  return entries.take(10).toList();
});

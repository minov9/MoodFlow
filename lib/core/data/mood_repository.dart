import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/mood_entry.dart';
import '../constants/mood_types.dart';

/// 心情数据仓库
class MoodRepository {
  static const String _boxName = 'mood_entries';
  static Box<MoodEntry>? _box;

  /// 初始化
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MoodEntryAdapter());
    }
    _box = await Hive.openBox<MoodEntry>(_boxName);
  }

  /// 获取 Box
  static Box<MoodEntry> get box {
    if (_box == null) {
      throw Exception('MoodRepository not initialized. Call init() first.');
    }
    return _box!;
  }

  /// 保存心情记录
  static Future<MoodEntry> saveMood({
    required MoodType mood,
    String? note,
    DateTime? date,
  }) async {
    final entry = MoodEntry(
      id: const Uuid().v4(),
      date: date ?? DateTime.now(),
      moodValue: mood.value,
      note: note,
      createdAt: DateTime.now(),
    );

    await box.put(entry.id, entry);
    return entry;
  }

  /// 获取所有记录（按日期倒序）
  static List<MoodEntry> getAllEntries() {
    final entries = box.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// 获取最近 N 条记录
  static List<MoodEntry> getRecentEntries({int limit = 10}) {
    final all = getAllEntries();
    return all.take(limit).toList();
  }

  /// 获取某天的记录
  static MoodEntry? getEntryForDate(DateTime date) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      return box.values.firstWhere((e) => e.dateKey == dateKey);
    } catch (_) {
      return null;
    }
  }

  /// 获取某月的所有记录
  static Map<int, MoodEntry> getEntriesForMonth(int year, int month) {
    final result = <int, MoodEntry>{};
    for (final entry in box.values) {
      if (entry.date.year == year && entry.date.month == month) {
        result[entry.date.day] = entry;
      }
    }
    return result;
  }

  /// 获取统计数据
  static MoodStats getStats() {
    final entries = getAllEntries();
    if (entries.isEmpty) {
      return MoodStats(
        totalDays: 0,
        streakDays: 0,
        averageMood: null,
        moodDistribution: {},
        weeklyTrend: [],
      );
    }

    // 计算连续记录天数
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final checkDate = now.subtract(Duration(days: i));
      if (getEntryForDate(checkDate) != null) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    // 计算平均心情
    final avgValue = entries.map((e) => e.moodValue).reduce((a, b) => a + b) / entries.length;
    MoodType avgMood;
    if (avgValue >= 4.5) {
      avgMood = MoodType.happy;
    } else if (avgValue >= 3.5) {
      avgMood = MoodType.calm;
    } else if (avgValue >= 2.5) {
      avgMood = MoodType.neutral;
    } else if (avgValue >= 1.5) {
      avgMood = MoodType.sad;
    } else {
      avgMood = MoodType.angry;
    }

    // 情绪分布
    final distribution = <MoodType, int>{};
    for (final entry in entries) {
      distribution[entry.moodType] = (distribution[entry.moodType] ?? 0) + 1;
    }

    // 本周趋势
    final weeklyTrend = <double>[];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final entry = getEntryForDate(date);
      weeklyTrend.add(entry?.moodValue.toDouble() ?? 0);
    }

    return MoodStats(
      totalDays: entries.length,
      streakDays: streak,
      averageMood: avgMood,
      moodDistribution: distribution,
      weeklyTrend: weeklyTrend,
    );
  }

  /// 删除记录
  static Future<void> deleteEntry(String id) async {
    await box.delete(id);
  }

  /// 清空所有记录
  static Future<void> clearAll() async {
    await box.clear();
  }
}

/// 统计数据
class MoodStats {
  final int totalDays;
  final int streakDays;
  final MoodType? averageMood;
  final Map<MoodType, int> moodDistribution;
  final List<double> weeklyTrend;

  MoodStats({
    required this.totalDays,
    required this.streakDays,
    required this.averageMood,
    required this.moodDistribution,
    required this.weeklyTrend,
  });
}

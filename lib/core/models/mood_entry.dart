import 'package:hive/hive.dart';
import '../constants/mood_types.dart';

part 'mood_entry.g.dart';

/// 心情记录数据模型
@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int moodValue; // 1-5 对应 MoodType

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final DateTime createdAt;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodValue,
    this.note,
    required this.createdAt,
  });

  /// 获取情绪类型
  MoodType get moodType {
    switch (moodValue) {
      case 5:
        return MoodType.happy;
      case 4:
        return MoodType.calm;
      case 3:
        return MoodType.neutral;
      case 2:
        return MoodType.sad;
      case 1:
        return MoodType.angry;
      default:
        return MoodType.neutral;
    }
  }

  /// 格式化日期
  String get dateKey => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// 相对时间描述
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;

    if (diff == 0) return '今天';
    if (diff == 1) return '昨天';
    if (diff == 2) return '前天';
    if (diff < 7) return '$diff天前';
    return '${date.month}月${date.day}日';
  }
}

import '../core/constants/mood_types.dart';

/// 情绪记录模型
class MoodEntry {
  final String id;
  final DateTime date;
  final int moodIndex;
  final String? note;
  final List<String> tags;
  final String? aiInsight;
  final DateTime createdAt;

  MoodEntry({
    required this.id,
    required this.date,
    required this.moodIndex,
    this.note,
    this.tags = const [],
    this.aiInsight,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 获取情绪类型
  MoodType get moodType => MoodType.values[moodIndex];

  /// 复制并修改
  MoodEntry copyWith({
    String? id,
    DateTime? date,
    int? moodIndex,
    String? note,
    List<String>? tags,
    String? aiInsight,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodIndex: moodIndex ?? this.moodIndex,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      aiInsight: aiInsight ?? this.aiInsight,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'MoodEntry(id: $id, date: $date, mood: ${moodType.label}, note: $note)';
  }
}

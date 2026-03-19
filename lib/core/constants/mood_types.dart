import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../theme/app_theme.dart';

/// 情绪类型枚举
enum MoodType {
  happy,
  calm,
  neutral,
  sad,
  angry,
}

/// 情绪类型扩展
extension MoodTypeExtension on MoodType {
  /// 情绪名称 - 中文
  String get label {
    switch (this) {
      case MoodType.happy:
        return '开心';
      case MoodType.calm:
        return '平静';
      case MoodType.neutral:
        return '一般';
      case MoodType.sad:
        return '难过';
      case MoodType.angry:
        return '生气';
    }
  }

  /// 情绪名称 - 英文
  String get labelEn {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.calm:
        return 'Calm';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
      case MoodType.angry:
        return 'Angry';
    }
  }


  /// 情绪图标
  IconData get icon {
    switch (this) {
      case MoodType.happy:
        return CupertinoIcons.smiley_fill;
      case MoodType.calm:
        return CupertinoIcons.drop_fill;
      case MoodType.neutral:
        return CupertinoIcons.circle_fill;
      case MoodType.sad:
        return CupertinoIcons.cloud_rain_fill;
      case MoodType.angry:
        return CupertinoIcons.flame_fill;
    }
  }

  /// 情绪表情符号
  String get emoji {
    switch (this) {
      case MoodType.happy:
        return '😊';
      case MoodType.calm:
        return '😌';
      case MoodType.neutral:
        return '😐';
      case MoodType.sad:
        return '😢';
      case MoodType.angry:
        return '😡';
    }
  }

  /// 情绪颜色
  Color get color {
    switch (this) {
      case MoodType.happy:
        return AppColors.moodHappy;
      case MoodType.calm:
        return AppColors.moodCalm;
      case MoodType.neutral:
        return AppColors.moodNeutral;
      case MoodType.sad:
        return AppColors.moodSad;
      case MoodType.angry:
        return AppColors.moodAngry;
    }
  }

  /// 情绪渐变色 - 珊瑚暖色系
  LinearGradient get gradient {
    switch (this) {
      case MoodType.happy:
        return LinearGradient(
          colors: [Color(0xFF56C5B0), Color(0xFF7BC5AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MoodType.calm:
        return LinearGradient(
          colors: [Color(0xFF7BC5AE), Color(0xFF9DD5C6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MoodType.neutral:
        return LinearGradient(
          colors: [Color(0xFFFFCC33), Color(0xFFFFDD66)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MoodType.sad:
        return LinearGradient(
          colors: [Color(0xFF8FA4B3), Color(0xFFB5C4CF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case MoodType.angry:
        return LinearGradient(
          colors: [Color(0xFFFF7B6B), Color(0xFFFFAA85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// 情绪描述语
  String get description {
    switch (this) {
      case MoodType.happy:
        return '今天心情很棒！';
      case MoodType.calm:
        return '内心平和宁静';
      case MoodType.neutral:
        return '普普通通的一天';
      case MoodType.sad:
        return '有些低落...';
      case MoodType.angry:
        return '需要冷静一下';
    }
  }

  /// 情绪数值 (1-5)
  int get value {
    switch (this) {
      case MoodType.happy:
        return 5;
      case MoodType.calm:
        return 4;
      case MoodType.neutral:
        return 3;
      case MoodType.sad:
        return 2;
      case MoodType.angry:
        return 1;
    }
  }
}

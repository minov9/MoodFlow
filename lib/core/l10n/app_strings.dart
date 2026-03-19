import 'package:flutter/material.dart';

/// 轻量级本地化系统 - 支持中英双语
class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    'zh': {
      // 首页
      'home.greeting.night': '夜深了',
      'home.greeting.morning': '早上好',
      'home.greeting.noon': '中午好',
      'home.greeting.afternoon': '下午好',
      'home.greeting.evening': '晚上好',
      'home.subtitle': '记录此刻，遇见更好的自己',
      'home.recordToday': '记录今天的心情',
      'home.howDoYouFeel': '你今天感觉怎么样？',
      'home.todayMood': '今日心情',
      'home.clickToStart': '点击开始记录',
      'home.editRecord': '修改记录',
      'home.recentRecords': '最近记录',
      'home.noRecords': '还没有记录',
      'home.startFirstRecord': '开始记录你的第一个心情吧',
      'home.weeklyStats': '本周统计',
      'home.viewTrend': '查看情绪趋势',
      'home.calendar': '日历',
      'home.reviewDays': '回顾每一天',

      // 记录页
      'record.cancel': '取消',
      'record.save': '保存',
      'record.howDoYouFeel': '你现在感觉如何？',
      'record.wantToSay': '想说点什么？',
      'record.placeholder': '记录此刻的想法...',
      'record.saved': '已保存',
      'record.todayMood': '今日心情',
      'record.ok': '好的',
      'record.saveFailed': '保存失败',
      'record.tryLater': '请稍后再试',

      // 日历页
      'calendar.title': '日历',

      // 统计页
      'stats.title': '统计',
      'stats.subtitle': '了解你的情绪规律',
      'stats.recordDays': '记录天数',
      'stats.streak': '连续记录',
      'stats.average': '平均心情',
      'stats.weeklyTrend': '本周趋势',
      'stats.noWeeklyData': '暂无本周数据',
      'stats.recordToSeeTrend': '开始记录心情后会显示趋势',
      'stats.distribution': '情绪分布',
      'stats.noDistData': '暂无分布数据',

      // 设置页
      'settings.title': '设置',
      'settings.reminder': '提醒设置',
      'settings.appearance': '外观',
      'settings.language': '语言',
      'settings.export': '导出数据',
      'settings.sync': '数据同步',
      'settings.notEnabled': '未开启',
      'settings.privacy': '隐私设置',
      'settings.about': '关于 MoodFlow',
      'settings.rate': '给个好评',
      'settings.share': '分享给朋友',
      'settings.madeWith': 'Made with ❤️',
      'settings.off': '已关闭',

      // 提醒设置
      'reminder.title': '提醒设置',
      'reminder.daily': '每日提醒',
      'reminder.enabled': '已开启',
      'reminder.disabled': '已关闭',
      'reminder.time': '提醒时间',
      'reminder.tip': '开启后，MoodFlow 会在设定时间提醒你记录今天的心情。定期记录有助于更好地了解自己的情绪变化。',
      'reminder.cancel': '取消',
      'reminder.confirm': '确定',

      // 外观设置
      'appearance.title': '外观',
      'appearance.followSystem': '跟随系统',
      'appearance.followSystemDesc': '根据系统设置自动切换',
      'appearance.light': '浅色模式',
      'appearance.lightDesc': '始终使用浅色主题',
      'appearance.dark': '深色模式',
      'appearance.darkDesc': '始终使用深色主题',
      'appearance.tip': '选择你喜欢的外观模式。跟随系统将根据设备设置自动切换深浅色。',

      // 语言设置
      'language.title': '语言',
      'language.tip': '切换语言后，应用界面将显示为所选语言。',

      // 情绪类型
      'mood.happy': '开心',
      'mood.calm': '平静',
      'mood.neutral': '一般',
      'mood.sad': '难过',
      'mood.angry': '生气',

      // 星期
      'weekday.sun': '日',
      'weekday.mon': '一',
      'weekday.tue': '二',
      'weekday.wed': '三',
      'weekday.thu': '四',
      'weekday.fri': '五',
      'weekday.sat': '六',

      // 底部导航
      'nav.home': '首页',
      'nav.calendar': '日历',
      'nav.stats': '统计',
      'nav.settings': '设置',
    },
    'en': {
      // Home
      'home.greeting.night': 'Good Night',
      'home.greeting.morning': 'Good Morning',
      'home.greeting.noon': 'Good Afternoon',
      'home.greeting.afternoon': 'Good Afternoon',
      'home.greeting.evening': 'Good Evening',
      'home.subtitle': 'Record now, meet a better you',
      'home.recordToday': 'Record Today\'s Mood',
      'home.howDoYouFeel': 'How are you feeling today?',
      'home.todayMood': 'Today\'s Mood',
      'home.clickToStart': 'Tap to start recording',
      'home.editRecord': 'Edit Record',
      'home.recentRecords': 'Recent Records',
      'home.noRecords': 'No records yet',
      'home.startFirstRecord': 'Start recording your first mood',
      'home.weeklyStats': 'Weekly Stats',
      'home.viewTrend': 'View mood trends',
      'home.calendar': 'Calendar',
      'home.reviewDays': 'Review each day',

      // Record
      'record.cancel': 'Cancel',
      'record.save': 'Save',
      'record.howDoYouFeel': 'How are you feeling?',
      'record.wantToSay': 'Want to say something?',
      'record.placeholder': 'Record your thoughts...',
      'record.saved': 'Saved',
      'record.todayMood': 'Today\'s mood',
      'record.ok': 'OK',
      'record.saveFailed': 'Save Failed',
      'record.tryLater': 'Please try again later',

      // Calendar
      'calendar.title': 'Calendar',

      // Stats
      'stats.title': 'Statistics',
      'stats.subtitle': 'Understand your mood patterns',
      'stats.recordDays': 'Days Recorded',
      'stats.streak': 'Day Streak',
      'stats.average': 'Average',
      'stats.weeklyTrend': 'Weekly Trend',
      'stats.noWeeklyData': 'No weekly data',
      'stats.recordToSeeTrend': 'Start recording to see trends',
      'stats.distribution': 'Mood Distribution',
      'stats.noDistData': 'No distribution data',

      // Settings
      'settings.title': 'Settings',
      'settings.reminder': 'Reminder',
      'settings.appearance': 'Appearance',
      'settings.language': 'Language',
      'settings.export': 'Export Data',
      'settings.sync': 'Data Sync',
      'settings.notEnabled': 'Not enabled',
      'settings.privacy': 'Privacy',
      'settings.about': 'About MoodFlow',
      'settings.rate': 'Rate Us',
      'settings.share': 'Share with Friends',
      'settings.madeWith': 'Made with ❤️',
      'settings.off': 'Off',

      // Reminder
      'reminder.title': 'Reminder',
      'reminder.daily': 'Daily Reminder',
      'reminder.enabled': 'Enabled',
      'reminder.disabled': 'Disabled',
      'reminder.time': 'Reminder Time',
      'reminder.tip': 'When enabled, MoodFlow will remind you to record your mood at the set time.',
      'reminder.cancel': 'Cancel',
      'reminder.confirm': 'Confirm',

      // Appearance
      'appearance.title': 'Appearance',
      'appearance.followSystem': 'Follow System',
      'appearance.followSystemDesc': 'Automatically switch based on system settings',
      'appearance.light': 'Light Mode',
      'appearance.lightDesc': 'Always use light theme',
      'appearance.dark': 'Dark Mode',
      'appearance.darkDesc': 'Always use dark theme',
      'appearance.tip': 'Choose your preferred appearance mode.',

      // Language
      'language.title': 'Language',
      'language.tip': 'After switching, the app interface will display in the selected language.',

      // Mood types
      'mood.happy': 'Happy',
      'mood.calm': 'Calm',
      'mood.neutral': 'Neutral',
      'mood.sad': 'Sad',
      'mood.angry': 'Angry',

      // Weekdays
      'weekday.sun': 'Sun',
      'weekday.mon': 'Mon',
      'weekday.tue': 'Tue',
      'weekday.wed': 'Wed',
      'weekday.thu': 'Thu',
      'weekday.fri': 'Fri',
      'weekday.sat': 'Sat',

      // Bottom nav
      'nav.home': 'Home',
      'nav.calendar': 'Calendar',
      'nav.stats': 'Stats',
      'nav.settings': 'Settings',
    },
  };

  /// 获取翻译字符串
  static String get(String key, String language) {
    return _strings[language]?[key] ?? _strings['zh']?[key] ?? key;
  }
}

/// BuildContext 扩展 - 方便获取翻译
extension LocalizedStrings on BuildContext {
  String tr(String key) {
    // 这里需要从 Provider 获取当前语言
    // 暂时返回中文
    return AppStrings.get(key, 'zh');
  }
}

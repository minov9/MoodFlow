import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_strings.dart';

/// 当前语言 Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

/// 语言状态管理
class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('zh');

  void setLanguage(String language) {
    state = language;
  }
}

/// 便捷访问翻译字符串
class L10n {
  final String language;

  L10n(this.language);

  String get(String key) => AppStrings.get(key, language);

  // 首页
  String getGreeting(int hour) {
    if (hour < 6) return get('home.greeting.night');
    if (hour < 12) return get('home.greeting.morning');
    if (hour < 14) return get('home.greeting.noon');
    if (hour < 18) return get('home.greeting.afternoon');
    return get('home.greeting.evening');
  }

  String get homeSubtitle => get('home.subtitle');
  String get recordToday => get('home.recordToday');
  String get howDoYouFeel => get('home.howDoYouFeel');
  String get todayMood => get('home.todayMood');
  String get clickToStart => get('home.clickToStart');
  String get editRecord => get('home.editRecord');
  String get recentRecords => get('home.recentRecords');
  String get noRecords => get('home.noRecords');
  String get startFirstRecord => get('home.startFirstRecord');
  String get weeklyStats => get('home.weeklyStats');
  String get viewTrend => get('home.viewTrend');
  String get calendar => get('home.calendar');
  String get reviewDays => get('home.reviewDays');

  // 记录页
  String get cancel => get('record.cancel');
  String get save => get('record.save');
  String get recordHowDoYouFeel => get('record.howDoYouFeel');
  String get wantToSay => get('record.wantToSay');
  String get placeholder => get('record.placeholder');
  String get saved => get('record.saved');
  String get recordTodayMood => get('record.todayMood');
  String get ok => get('record.ok');
  String get saveFailed => get('record.saveFailed');
  String get tryLater => get('record.tryLater');

  // 日历页
  String get calendarTitle => get('calendar.title');

  // 统计页
  String get statsTitle => get('stats.title');
  String get statsSubtitle => get('stats.subtitle');
  String get recordDays => get('stats.recordDays');
  String get streak => get('stats.streak');
  String get average => get('stats.average');
  String get weeklyTrend => get('stats.weeklyTrend');
  String get noWeeklyData => get('stats.noWeeklyData');
  String get recordToSeeTrend => get('stats.recordToSeeTrend');
  String get distribution => get('stats.distribution');
  String get noDistData => get('stats.noDistData');

  // 设置页
  String get settingsTitle => get('settings.title');
  String get reminder => get('settings.reminder');
  String get appearance => get('settings.appearance');
  String get language => get('settings.language');
  String get exportData => get('settings.export');
  String get sync => get('settings.sync');
  String get notEnabled => get('settings.notEnabled');
  String get privacy => get('settings.privacy');
  String get about => get('settings.about');
  String get rate => get('settings.rate');
  String get share => get('settings.share');
  String get madeWith => get('settings.madeWith');
  String get off => get('settings.off');

  // 提醒设置
  String get reminderTitle => get('reminder.title');
  String get dailyReminder => get('reminder.daily');
  String get enabled => get('reminder.enabled');
  String get disabled => get('reminder.disabled');
  String get reminderTime => get('reminder.time');
  String get reminderTip => get('reminder.tip');
  String get confirmAction => get('reminder.confirm');

  // 外观设置
  String get appearanceTitle => get('appearance.title');
  String get followSystem => get('appearance.followSystem');
  String get followSystemDesc => get('appearance.followSystemDesc');
  String get lightMode => get('appearance.light');
  String get lightModeDesc => get('appearance.lightDesc');
  String get darkMode => get('appearance.dark');
  String get darkModeDesc => get('appearance.darkDesc');
  String get appearanceTip => get('appearance.tip');

  // 语言设置
  String get languageTitle => get('language.title');
  String get languageTip => get('language.tip');

  // 情绪类型
  String getMoodLabel(String moodKey) => get('mood.$moodKey');
  String get moodHappy => get('mood.happy');
  String get moodCalm => get('mood.calm');
  String get moodNeutral => get('mood.neutral');
  String get moodSad => get('mood.sad');
  String get moodAngry => get('mood.angry');

  // 星期
  List<String> get weekdays => [
    get('weekday.sun'),
    get('weekday.mon'),
    get('weekday.tue'),
    get('weekday.wed'),
    get('weekday.thu'),
    get('weekday.fri'),
    get('weekday.sat'),
  ];

  // 底部导航
  String get navHome => get('nav.home');
  String get navCalendar => get('nav.calendar');
  String get navStats => get('nav.stats');
  String get navSettings => get('nav.settings');
}

/// 语言 Provider - 返回 L10n 对象便于使用
final l10nProvider = Provider<L10n>((ref) {
  final language = ref.watch(languageProvider);
  return L10n(language);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用设置状态
class AppSettings {
  final ThemeMode themeMode;
  final String language;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;
  final bool appLockEnabled;
  final bool biometricEnabled;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.language = 'zh',
    this.reminderEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 21, minute: 0),
    this.appLockEnabled = false,
    this.biometricEnabled = false,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? language,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    bool? appLockEnabled,
    bool? biometricEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

/// 设置 Notifier
class SettingsNotifier extends Notifier<AppSettings> {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLanguage = 'language';
  static const _keyReminderEnabled = 'reminder_enabled';
  static const _keyReminderHour = 'reminder_hour';
  static const _keyReminderMinute = 'reminder_minute';
  static const _keyAppLock = 'app_lock';
  static const _keyBiometric = 'biometric';

  @override
  AppSettings build() {
    _loadFromPrefs();
    return const AppSettings();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeIndex = prefs.getInt(_keyThemeMode) ?? 0;
    final language = prefs.getString(_keyLanguage) ?? 'zh';
    final reminderEnabled = prefs.getBool(_keyReminderEnabled) ?? true;
    final reminderHour = prefs.getInt(_keyReminderHour) ?? 21;
    final reminderMinute = prefs.getInt(_keyReminderMinute) ?? 0;
    final appLock = prefs.getBool(_keyAppLock) ?? false;
    final biometric = prefs.getBool(_keyBiometric) ?? false;

    state = AppSettings(
      themeMode: ThemeMode.values[themeModeIndex],
      language: language,
      reminderEnabled: reminderEnabled,
      reminderTime: TimeOfDay(hour: reminderHour, minute: reminderMinute),
      appLockEnabled: appLock,
      biometricEnabled: biometric,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> setLanguage(String lang) async {
    state = state.copyWith(language: lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
  }

  Future<void> setReminderEnabled(bool enabled) async {
    state = state.copyWith(reminderEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReminderEnabled, enabled);
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    state = state.copyWith(reminderTime: time);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyReminderHour, time.hour);
    await prefs.setInt(_keyReminderMinute, time.minute);
  }

  Future<void> setAppLock(bool enabled) async {
    state = state.copyWith(appLockEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppLock, enabled);
  }

  Future<void> setBiometric(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometric, enabled);
  }
}

/// 全局设置 Provider
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(() {
  return SettingsNotifier();
});

/// 主题模式名称
extension ThemeModeExtension on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色模式';
      case ThemeMode.dark:
        return '深色模式';
    }
  }

  String get labelEn {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 应用颜色 - 珊瑚暖色系（去 AI 味）
class AppColors {
  // 主色调 - 珊瑚粉
  static const Color primary = Color(0xFFFF7B6B);      // 珊瑚红
  static const Color accent = Color(0xFFFFAA85);       // 暖杏色

  // 渐变
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF7B6B), Color(0xFFFFAA85)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 暖色系渐变
  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFB347), Color(0xFFFFCC33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 青绿渐变（辅助）
  static const LinearGradient calmGradient = LinearGradient(
    colors: [Color(0xFF56C5B0), Color(0xFF7BC5AE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 蓝灰渐变（中性）
  static const LinearGradient neutralGradient = LinearGradient(
    colors: [Color(0xFF8FA4B3), Color(0xFFB5C4CF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 浅色模式背景色
  static const Color background = Color(0xFFFFFBF7);   // 暖白
  static const Color cardBackground = Colors.white;

  // 深色模式背景色
  static const Color backgroundDark = Color(0xFF1C1C1E);
  static const Color cardBackgroundDark = Color(0xFF2C2C2E);

  // 文字颜色 - 浅色模式
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textTertiary = Color(0xFFB2BEC3);

  // 文字颜色 - 深色模式
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFABABAB);
  static const Color textTertiaryDark = Color(0xFF6B6B6B);

  // 分割线
  static const Color divider = Color(0xFFEEE8E2);
  static const Color dividerDark = Color(0xFF3A3A3C);

  // 情绪颜色 - 自然柔和
  static const Color moodHappy = Color(0xFF56C5B0);
  static const Color moodCalm = Color(0xFF7BC5AE);
  static const Color moodNeutral = Color(0xFFFFCC33);
  static const Color moodSad = Color(0xFF8FA4B3);
  static const Color moodAngry = Color(0xFFFF7B6B);
}

/// 阴影样式
class AppShadows {
  static List<BoxShadow> get small => [
    BoxShadow(
      color: Color(0xFF2D3436).withValues(alpha: 0.06),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Color(0xFF2D3436).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> colored(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.25),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}

/// 应用主题
class AppTheme {
  // 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackground,
        error: AppColors.moodAngry,
      ),
      fontFamily: '.SF Pro Text',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.cardBackground,
      ),
      textTheme: _buildTextTheme(false),
      elevatedButtonTheme: _buildButtonTheme(),
      inputDecorationTheme: _buildInputTheme(false),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );
  }

  // 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardBackgroundDark,
        error: AppColors.moodAngry,
      ),
      fontFamily: '.SF Pro Text',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.cardBackgroundDark,
      ),
      textTheme: _buildTextTheme(true),
      elevatedButtonTheme: _buildButtonTheme(),
      inputDecorationTheme: _buildInputTheme(true),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 0.5,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
    );
  }

  static TextTheme _buildTextTheme(bool isDark) {
    final primary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    );
  }

  static InputDecorationTheme _buildInputTheme(bool isDark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}

/// 根据亮度获取正确的颜色
extension ContextColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor => isDark ? AppColors.backgroundDark : AppColors.background;
  Color get cardColor => isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
  Color get textPrimary => isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textTertiary => isDark ? AppColors.textTertiaryDark : AppColors.textTertiary;
  Color get dividerColor => isDark ? AppColors.dividerDark : AppColors.divider;
}

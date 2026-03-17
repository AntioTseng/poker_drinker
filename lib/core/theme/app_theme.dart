import 'package:flutter/material.dart';

class AppTheme {
  static const String _bodyFontFamily = 'Noto Sans TC';
  static const String _titleFontFamily = 'GenSenRounded';

  static const Color pageBackground = Color(0xFFF4EBDD);
  static const Color pageBackgroundSoft = Color(0xFFEADBC8);
  static const Color panel = Color(0xFFFFF8F1);
  static const Color primaryAccent = Color(0xFF7A2131);
  static const Color secondaryAccent = Color(0xFFB57462);
  static const Color ink = Color(0xFF34241C);
  static const Color subtleInk = Color(0xFF6B5648);

  static const List<String> _cjkFallback = <String>[
    'Noto Sans TC',
    'Noto Sans CJK TC',
    'PingFang TC',
    'Heiti TC',
    'Microsoft JhengHei',
    'Microsoft YaHei',
    'Arial Unicode MS',
  ];

  static final ThemeData lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final colorScheme = const ColorScheme.light(
      primary: primaryAccent,
      onPrimary: Colors.white,
      secondary: secondaryAccent,
      onSecondary: Colors.white,
      error: Color(0xFFB64032),
      onError: Colors.white,
      surface: panel,
      onSurface: ink,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: pageBackground,
      canvasColor: pageBackground,
      fontFamily: _bodyFontFamily,
      fontFamilyFallback: _cjkFallback,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );

    double scaledFontSize(double? current, double factor, double fallback) {
      return (current ?? fallback) * factor;
    }

    const titleScale = 1.08;

    final titleTextTheme = base.textTheme.copyWith(
      bodyLarge: base.textTheme.bodyLarge?.copyWith(
        color: ink,
        height: 1.42,
        letterSpacing: 0.1,
      ),
      bodyMedium: base.textTheme.bodyMedium?.copyWith(
        color: ink,
        height: 1.5,
        letterSpacing: 0.1,
      ),
      bodySmall: base.textTheme.bodySmall?.copyWith(
        color: subtleInk,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelLarge: base.textTheme.labelLarge?.copyWith(
        color: primaryAccent,
        fontFamily: _bodyFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      displayLarge: base.textTheme.displayLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontSize: scaledFontSize(
          base.textTheme.headlineLarge?.fontSize,
          titleScale,
          32,
        ),
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontSize: scaledFontSize(
          base.textTheme.headlineMedium?.fontSize,
          titleScale,
          28,
        ),
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontSize: scaledFontSize(
          base.textTheme.headlineSmall?.fontSize,
          titleScale,
          24,
        ),
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        fontSize: scaledFontSize(
          base.textTheme.titleLarge?.fontSize,
          titleScale,
          22,
        ),
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontFamily: _bodyFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        fontSize: scaledFontSize(base.textTheme.titleMedium?.fontSize, 1.0, 18),
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(
        fontFamily: _bodyFontFamily,
        fontFamilyFallback: _cjkFallback,
        color: ink,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
        fontSize: scaledFontSize(base.textTheme.titleSmall?.fontSize, 1.0, 16),
      ),
    );

    return base.copyWith(
      textTheme: titleTextTheme,
      splashColor: primaryAccent.withValues(alpha: 0.08),
      highlightColor: secondaryAccent.withValues(alpha: 0.08),
      dividerColor: secondaryAccent.withValues(alpha: 0.18),
      cardColor: panel,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: pageBackground,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: titleTextTheme.headlineSmall?.copyWith(
          fontFamily: _titleFontFamily,
          fontFamilyFallback: _cjkFallback,
          color: ink,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
      ),
      iconTheme: const IconThemeData(color: ink),
      listTileTheme: const ListTileThemeData(
        iconColor: primaryAccent,
        textColor: ink,
      ),
      cardTheme: CardThemeData(
        color: panel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: secondaryAccent.withValues(alpha: 0.18)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: panel,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: titleTextTheme.titleLarge,
        contentTextStyle: titleTextTheme.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: secondaryAccent.withValues(alpha: 0.24),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: titleTextTheme.titleMedium?.copyWith(
            fontFamily: _bodyFontFamily,
            fontFamilyFallback: _cjkFallback,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryAccent,
          textStyle: titleTextTheme.titleMedium?.copyWith(
            fontFamily: _bodyFontFamily,
            fontFamilyFallback: _cjkFallback,
            color: primaryAccent,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryAccent,
          side: BorderSide(color: primaryAccent.withValues(alpha: 0.35)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: titleTextTheme.titleMedium?.copyWith(
            fontFamily: _bodyFontFamily,
            fontFamilyFallback: _cjkFallback,
            color: primaryAccent,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: panel,
        hintStyle: titleTextTheme.bodyMedium?.copyWith(color: subtleInk),
        labelStyle: titleTextTheme.bodyMedium?.copyWith(color: subtleInk),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: secondaryAccent.withValues(alpha: 0.22),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: secondaryAccent.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primaryAccent, width: 1.4),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryAccent,
      ),
    );
  }
}

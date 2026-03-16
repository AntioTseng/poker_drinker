import 'package:flutter/material.dart';

class AppTheme {
  static const String _bodyFontFamily = 'Noto Sans TC';
  static const String _titleFontFamily = 'GenSenRounded';

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
    final base = ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.grey[100],
      fontFamily: _bodyFontFamily,
      fontFamilyFallback: _cjkFallback,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );

    double scaledFontSize(double? current, double factor, double fallback) {
      return (current ?? fallback) * factor;
    }

    const titleScale = 1.2;

    final titleTextTheme = base.textTheme.copyWith(
      displayLarge: base.textTheme.displayLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
      ),
      displayMedium: base.textTheme.displayMedium?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
      ),
      displaySmall: base.textTheme.displaySmall?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
      ),
      headlineLarge: base.textTheme.headlineLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.headlineLarge?.fontSize,
          titleScale,
          32,
        ),
      ),
      headlineMedium: base.textTheme.headlineMedium?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.headlineMedium?.fontSize,
          titleScale,
          28,
        ),
      ),
      headlineSmall: base.textTheme.headlineSmall?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.headlineSmall?.fontSize,
          titleScale,
          24,
        ),
      ),
      titleLarge: base.textTheme.titleLarge?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.titleLarge?.fontSize,
          titleScale,
          22,
        ),
      ),
      titleMedium: base.textTheme.titleMedium?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.titleMedium?.fontSize,
          titleScale,
          18,
        ),
      ),
      titleSmall: base.textTheme.titleSmall?.copyWith(
        fontFamily: _titleFontFamily,
        fontFamilyFallback: _cjkFallback,
        fontSize: scaledFontSize(
          base.textTheme.titleSmall?.fontSize,
          titleScale,
          16,
        ),
      ),
    );

    return base.copyWith(
      textTheme: titleTextTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: titleTextTheme.titleLarge,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light and dark themes. English text uses Noto Sans; Assamese letters
/// automatically fall back to Noto Sans Bengali, which includes ৰ and ৱ.
class AppTheme {
  AppTheme._();

  static const _fontFamily = 'NotoSans';
  static const _fallback = ['NotoSansBengali'];

  static ThemeData light() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.teaGreen,
          primary: AppColors.teaGreen,
          secondary: AppColors.brahmaputraBlue,
          tertiary: AppColors.mugaGold,
          error: AppColors.gamosaRed,
          surface: AppColors.cream,
        ),
      );

  static ThemeData dark() => _build(
        ColorScheme.fromSeed(
          seedColor: AppColors.teaGreen,
          brightness: Brightness.dark,
          primary: const Color(0xFF8FD3A6),
          secondary: const Color(0xFF8EC3EA),
          tertiary: AppColors.mugaGold,
          surface: AppColors.nightGreen,
        ),
      );

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fallback,
      scaffoldBackgroundColor: scheme.surface,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: _fontFamily,
        fontFamilyFallback: _fallback,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

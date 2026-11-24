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

  /// The theme for one section of the app (Exams, Jobs, Practice and so on),
  /// built around that section's colour from the Home tiles.
  static ThemeData section(Color color, Brightness brightness) => _build(
    brightness == Brightness.light
        ? ColorScheme.fromSeed(
            seedColor: color,
            primary: color,
            tertiary: AppColors.mugaGold,
            error: AppColors.gamosaRed,
            surface: AppColors.cream,
          )
        : ColorScheme.fromSeed(seedColor: color, brightness: Brightness.dark, tertiary: AppColors.mugaGold, surface: AppColors.nightGreen),
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
      textTheme: base.textTheme.apply(fontFamily: _fontFamily, fontFamilyFallback: _fallback),
      // Coloured top bars, like the Home screen.
      appBarTheme: AppBarTheme(backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary, elevation: 0, centerTitle: false),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onPrimary,
        unselectedLabelColor: scheme.onPrimary.withValues(alpha: 0.72),
        indicatorColor: scheme.onPrimary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
      // Raised "3D" buttons that sink when pressed.
      filledButtonTheme: FilledButtonThemeData(style: _raised(scheme)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _raised(scheme)
            .copyWith(backgroundColor: WidgetStatePropertyAll(scheme.primary), foregroundColor: WidgetStatePropertyAll(scheme.onPrimary)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _raised(scheme).copyWith(
          elevation: _pressable(2),
          backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerLowest),
          side: WidgetStatePropertyAll(BorderSide(color: scheme.primary.withValues(alpha: 0.5), width: 1.5)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static WidgetStateProperty<double> _pressable(double up) => WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.pressed) ? 0.5 : (states.contains(WidgetState.disabled) ? 0 : up),
  );

  static ButtonStyle _raised(ColorScheme scheme) => ButtonStyle(
    elevation: _pressable(5),
    shadowColor: WidgetStatePropertyAll(Color.lerp(scheme.primary, Colors.black, 0.55)),
    minimumSize: const WidgetStatePropertyAll(Size(64, 48)),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 22, vertical: 12)),
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
    textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
  );
}

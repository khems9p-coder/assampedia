import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Light and dark themes. English text uses Noto Sans; Assamese letters
/// automatically fall back to Noto Sans Bengali, which includes ৰ and ৱ.
///
/// The look is simple: black ink on warm off-white paper, white cards with a
/// thin border, flat black main buttons. Green and gold are small accents only.
class AppTheme {
  AppTheme._();

  static const _fontFamily = 'NotoSans';
  static const _fallback = ['NotoSansBengali'];

  static ThemeData light() => _build(
    ColorScheme.fromSeed(seedColor: AppColors.teaGreen).copyWith(
      primary: AppColors.ink,
      onPrimary: Colors.white,
      primaryContainer: AppColors.tint,
      onPrimaryContainer: AppColors.ink,
      secondary: AppColors.teaGreen,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.tint,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.mugaGold,
      tertiaryContainer: AppColors.premiumTint,
      onTertiaryContainer: const Color(0xFF5A4300),
      error: AppColors.gamosaRed,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.sub,
      surfaceContainerLowest: AppColors.card,
      surfaceContainerLow: AppColors.card,
      surfaceContainer: AppColors.tint,
      surfaceContainerHigh: AppColors.tint,
      surfaceContainerHighest: const Color(0xFFE9E3D6),
      outline: const Color(0xFFBDB7AA),
      outlineVariant: AppColors.line,
      inverseSurface: AppColors.ink,
      onInverseSurface: Colors.white,
      surfaceTint: Colors.transparent,
    ),
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(seedColor: AppColors.teaGreen, brightness: Brightness.dark).copyWith(
      primary: AppColors.snow,
      onPrimary: AppColors.ink,
      primaryContainer: AppColors.nightTint,
      onPrimaryContainer: AppColors.snow,
      secondary: const Color(0xFF8FD3A6),
      onSecondary: AppColors.ink,
      secondaryContainer: AppColors.nightTint,
      onSecondaryContainer: AppColors.snow,
      tertiary: AppColors.mugaGold,
      tertiaryContainer: const Color(0xFF3A3018),
      onTertiaryContainer: const Color(0xFFF3E0A8),
      surface: AppColors.night,
      onSurface: AppColors.snow,
      onSurfaceVariant: const Color(0xFFA8A49C),
      surfaceContainerLowest: AppColors.nightCard,
      surfaceContainerLow: AppColors.nightCard,
      surfaceContainer: AppColors.nightTint,
      surfaceContainerHigh: AppColors.nightTint,
      surfaceContainerHighest: const Color(0xFF302D29),
      outline: const Color(0xFF5C5852),
      outlineVariant: AppColors.nightLine,
      inverseSurface: AppColors.snow,
      onInverseSurface: AppColors.ink,
      surfaceTint: Colors.transparent,
    ),
  );

  /// Every section now shares the same simple look. Kept so older code that
  /// asks for a section theme still works.
  static ThemeData section(Color color, Brightness brightness) => brightness == Brightness.dark ? dark() : light();

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fallback,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
    );
    final radius12 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    const buttonText = TextStyle(fontWeight: FontWeight.w700, fontSize: 15);
    const buttonSize = Size(64, 48);
    const buttonPad = EdgeInsets.symmetric(horizontal: 22, vertical: 12);
    return base.copyWith(
      textTheme: base.textTheme
          .apply(fontFamily: _fontFamily, fontFamilyFallback: _fallback, bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
          .copyWith(
            titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            titleMedium: base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
      // Plain top bars in the page colour, with dark text.
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontFamilyFallback: _fallback,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        shape: Border(bottom: BorderSide(color: scheme.outlineVariant)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
      // Flat buttons: solid black for the main action, outlined for the rest.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: buttonSize, padding: buttonPad, shape: radius12, textStyle: buttonText, elevation: 0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: buttonSize,
          padding: buttonPad,
          shape: radius12,
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          backgroundColor: scheme.surfaceContainerLowest,
          side: BorderSide(color: scheme.onSurface, width: 1.5),
          minimumSize: buttonSize,
          padding: buttonPad,
          shape: radius12,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: scheme.onSurface, textStyle: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // White cards with a thin border.
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: scheme.outlineVariant)),
      ),
      listTileTheme: ListTileThemeData(iconColor: scheme.onSurface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        secondaryLabelStyle: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (st) => st.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerLowest,
          ),
          foregroundColor: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurface),
          side: WidgetStatePropertyAll(BorderSide(color: scheme.outlineVariant)),
          textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.outlineVariant)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.outlineVariant)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: scheme.primary, width: 1.5)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        linearTrackColor: scheme.outlineVariant,
        circularTrackColor: scheme.outlineVariant,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: scheme.surface, surfaceTintColor: Colors.transparent),
      dialogTheme: DialogThemeData(backgroundColor: scheme.surface, surfaceTintColor: Colors.transparent),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: scheme.surface, surfaceTintColor: Colors.transparent),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

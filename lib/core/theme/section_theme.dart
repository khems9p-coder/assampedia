import 'package:flutter/material.dart';

import 'app_theme.dart';

/// The colour of each part of the app, matching its tile on Home.
abstract final class SectionColors {
  static const learn = Color(0xFF1E7A46);
  static const exams = Color(0xFF1F6FB2);
  static const courses = Color(0xFF0E6E86);
  static const practice = Color(0xFFB3266B);
  static const jobs = Color(0xFF00796B);
  static const news = Color(0xFFB85C00);
  static const careers = Color(0xFF6A3FB5);
  static const dictionary = Color(0xFF3949AB);
  static const saved = Color(0xFF6D4C41);
  static const premium = Color(0xFF8A5300);
}

/// Paints [child] (its top bar, tabs and buttons) in a section's colour.
class SectionTheme extends StatelessWidget {
  const SectionTheme({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => Theme(data: AppTheme.section(color, Theme.of(context).brightness), child: child);
}

/// Opens a screen in the same colours as the screen it was opened from, so a
/// chapter opened from Exams stays blue.
class SectionRoute<T> extends MaterialPageRoute<T> {
  SectionRoute(BuildContext from, {required super.builder, super.settings}) : _theme = Theme.of(from);
  final ThemeData _theme;

  @override
  Widget buildContent(BuildContext context) => Theme(data: _theme, child: super.buildContent(context));
}

import 'package:flutter/material.dart';

/// ASSAMPEDIA brand colours, inspired by Assam.
class AppColors {
  AppColors._();

  // Brand palette
  static const teaGreen = Color(0xFF1E6B3C); // tea gardens
  static const brahmaputraBlue = Color(0xFF1B5E8C); // the river
  static const mugaGold = Color(0xFFD4A62A); // Muga silk
  static const gamosaRed = Color(0xFFB3261E); // Gamosa border
  static const cream = Color(0xFFFBF6EA); // Gamosa white
  static const earth = Color(0xFF6B4F35); // natural earthy shade
  static const nightGreen = Color(0xFF0F1D16); // dark-mode background

  // The simple look: ink on warm paper.
  static const ink = Color(0xFF111111); // main buttons, headings, icons
  static const paper = Color(0xFFFAF8F3); // page background
  static const card = Color(0xFFFFFFFF); // cards
  static const line = Color(0xFFE7E3DA); // card borders and dividers
  static const tint = Color(0xFFF1ECE1); // soft fills behind icons
  static const sub = Color(0xFF6B6B6B); // secondary text
  static const premiumTint = Color(0xFFF3E7C6); // soft gold for Premium

  // Dark mode versions.
  static const night = Color(0xFF121212);
  static const nightCard = Color(0xFF1C1C1C);
  static const nightLine = Color(0xFF2E2E2E);
  static const nightTint = Color(0xFF262421);
  static const snow = Color(0xFFF2F0EA);
}

/// The meaning of each highlight colour used inside lessons.
/// Every colour has a light-mode and a dark-mode shade so text stays readable.
enum ContentColor {
  definition('Important definitions and concepts', Color(0xFF1565C0), Color(0xFF90CAF9)),
  verifiedFact('Verified facts and important information', Color(0xFF2E7D32), Color(0xFFA5D6A7)),
  event('Historical events, dates and timelines', Color(0xFFE65100), Color(0xFFFFCC80)),
  personality('Important personalities', Color(0xFF6A1B9A), Color(0xFFCE93D8)),
  examFact('Frequently asked exam facts, high priority', Color(0xFFC62828), Color(0xFFEF9A9A)),
  geography('Geography, rivers, wildlife and environment', Color(0xFF00796B), Color(0xFF80CBC4)),
  heritage('Cultural heritage and historical significance', Color(0xFF9A7400), Color(0xFFFFE082)),
  suggested('Suggested preparation tips (not official)', Color(0xFF6B4F35), Color(0xFFD7C4AE));

  const ContentColor(this.meaningEn, this.light, this.dark);

  final String meaningEn;
  final Color light;
  final Color dark;

  Color of(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? dark : light;
}

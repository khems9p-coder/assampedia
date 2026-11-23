import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/main.dart';

void main() {
  testWidgets('Welcome screen shows the brand', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = ThemeController();
    await controller.load();
    await tester.pumpWidget(AssampediaApp(themeController: controller));
    expect(find.text('Explore Assam. Learn. Prepare. Succeed.'), findsOneWidget);
    expect(find.text('অসমীয়া | English'), findsOneWidget);
  });

  testWidgets('Theme choice is remembered', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = ThemeController();
    await controller.setMode(ThemeMode.dark);
    final again = ThemeController();
    await again.load();
    expect(again.mode, ThemeMode.dark);
  });
}

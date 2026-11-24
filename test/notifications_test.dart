import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:assampedia/core/app_scope.dart';
import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/data/auth_service.dart';
import 'package:assampedia/data/demo_content_repository.dart';
import 'package:assampedia/data/notification_service.dart';
import 'package:assampedia/data/quotes.dart';
import 'package:assampedia/main.dart';

void main() {
  test('Every quote has both languages, and the quote changes each day', () {
    for (final q in quotes) {
      expect(q.textAs.trim(), isNotEmpty);
      expect(q.textEn.trim(), isNotEmpty);
      expect(q.authorAs.trim(), isNotEmpty);
      expect(q.authorEn.trim(), isNotEmpty);
    }
    final day = DateTime(2026, 11, 24);
    expect(quoteForDay(DateTime(2026, 11, 24, 23, 59)), same(quoteForDay(day)));
    expect(quoteForDay(day.add(const Duration(days: 1))), isNot(same(quoteForDay(day))));
  });

  test('Morning notifications are set for the next 14 days at 7 AM India time', () {
    tzdata.initializeTimeZones();
    final kolkata = tz.getLocation('Asia/Kolkata');
    final evening = tz.TZDateTime(kolkata, 2026, 11, 30, 20);
    final times = NotificationService.morningsFrom(evening);
    expect(times, hasLength(14));
    expect(times.first, tz.TZDateTime(kolkata, 2026, 12, 1, 7));
    expect(times.last, tz.TZDateTime(kolkata, 2026, 12, 14, 7));

    // Before 7 AM, today's morning is still to come.
    final early = tz.TZDateTime(kolkata, 2026, 11, 30, 6, 30);
    expect(NotificationService.morningsFrom(early).first, tz.TZDateTime(kolkata, 2026, 11, 30, 7));
  });

  testWidgets('The bell counts new vacancies; the Notifications screen shows the quote and marks them NEW once', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'app_lang': 'en'});
    final theme = ThemeController();
    final language = LanguageController();
    final notes = NotificationService(onDevice: false);
    await Future.wait([theme.load(), language.load(), notes.load()]);
    final services = AppServices(
      language: language,
      theme: theme,
      content: DemoContentRepository(),
      auth: AuthService(null),
      notifications: notes,
    );

    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    // The demo has two open vacancies (and one closed).
    expect(notes.newJobCount, 2);
    expect(find.descendant(of: find.byType(Badge), matching: find.text('2')), findsOneWidget);

    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await tester.pumpAndSettle();
    final quote = quoteForDay(DateTime.now());
    expect(find.text('“${quote.textEn}”'), findsOneWidget);
    expect(find.text('— ${quote.authorEn}'), findsOneWidget);
    expect(find.text('Sample vacancy A (layout test)'), findsOneWidget);
    expect(find.text('Sample vacancy C (layout test)'), findsNothing);
    expect(find.text('NEW'), findsNWidgets(2));
    expect(notes.newJobCount, 0);

    // The morning quote can be switched off, and stays off.
    expect(notes.dailyOn, isTrue);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(notes.dailyOn, isFalse);
    final reloaded = NotificationService(onDevice: false);
    await reloaded.load();
    expect(reloaded.dailyOn, isFalse);

    // Coming back: the vacancies are no longer new.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(Badge), matching: find.text('2')), findsNothing);
    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await tester.pumpAndSettle();
    expect(find.text('NEW'), findsNothing);
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:assampedia/core/app_scope.dart';
import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/data/auth_service.dart';
import 'package:assampedia/data/demo_content_repository.dart';
import 'package:assampedia/data/mock_models.dart';
import 'package:assampedia/data/practice_models.dart';
import 'package:assampedia/features/mock/mock_test_screen.dart';
import 'package:assampedia/main.dart';

Question _q(int correct, {String? topic}) => Question(
  setId: 's',
  correctIndex: correct,
  text: {'question_en': 'Q', 'topic_en': ?topic},
  optionsEn: const ['a', 'b', 'c', 'd'],
);

void main() {
  group('Mock test result', () {
    final set = QuestionSet(id: 's', kind: QuizKind.mock, timeLimitMinutes: 10, marksPerQuestion: 2, negativeMarks: 0.5, questionCount: 5);
    final qs = [
      _q(0, topic: 'History'),
      _q(1, topic: 'History'),
      _q(2, topic: 'Polity'),
      _q(3, topic: 'Polity'),
      _q(0),
    ];

    test('counts right, wrong and skipped, with negative marking', () {
      // Q1 right, Q2 wrong, Q3 right, Q4 skipped, Q5 wrong.
      final r = MockResult.compute(set: set, questions: qs, answers: {0: 0, 1: 0, 2: 2, 4: 1}, secondsTaken: 200);
      expect(r.correct, 2);
      expect(r.wrong, 2);
      expect(r.skipped, 1);
      expect(r.attempted, 4);
      expect(r.maxMarks, 10);
      expect(r.marks, 2 * 2 - 2 * 0.5);
      expect(r.marksLost, 1);
      expect(r.accuracy, 0.5);
      expect(r.percent, 0.3);
      expect(r.secondsAllowed, 600);
      expect(r.secondsPerAnswer, 50);
      expect(r.outcomes, [MockOutcome.correct, MockOutcome.wrong, MockOutcome.correct, MockOutcome.skipped, MockOutcome.wrong]);
    });

    test('groups questions by topic, in the order they appear', () {
      final r = MockResult.compute(set: set, questions: qs, answers: {0: 0, 1: 0, 2: 2, 4: 1});
      expect(r.topics.map((t) => t.name(AppLang.english, 'General')), ['History', 'Polity', 'General']);
      final history = r.topics.first;
      expect([history.correct, history.wrong, history.skipped], [1, 1, 0]);
      final polity = r.topics[1];
      expect([polity.correct, polity.wrong, polity.skipped], [1, 0, 1]);
    });

    test('marks can go below zero, but the percentage stops at 0', () {
      final r = MockResult.compute(set: set, questions: qs, answers: {0: 3, 1: 3});
      expect(r.marks, -1);
      expect(r.percent, 0);
      expect(r.accuracy, 0);
    });

    test('a saved attempt keeps the marks', () {
      final r = MockResult.compute(set: set, questions: qs, answers: {0: 0});
      final a = QuizAttempt.fromJson(r.toAttempt(DateTime(2026)).toJson());
      expect(a.marks, 2);
      expect(a.maxMarks, 10);
      expect(a.score, 1);
    });

    test('marks and clock are shown neatly', () {
      expect(formatMarks(2), '2');
      expect(formatMarks(0.25), '0.25');
      expect(formatMarks(0.5), '0.5');
      expect(formatMarks(-1.5), '-1.5');
      expect(formatClock(125), '02:05');
      expect(formatClock(3725), '1:02:05');
      expect(formatClock(-3), '00:00');
    });

    test('mock settings and topics are read from and written to the database', () {
      final s = QuestionSet.fromJson({
        'id': 's',
        'kind': 'mock',
        'title_en': 'Mock',
        'instructions_en': 'Line one\n- Line two\n\n',
        'marks_per_question': 2,
        'negative_marks': 0.5,
        'slug': 'mock-1',
      });
      expect(s.isMockTest, isTrue);
      expect(s.instructions(AppLang.english), ['Line one', 'Line two']);
      expect(s.instructions(AppLang.assamese), ['Line one', 'Line two']);
      expect(s.toRow()['negative_marks'], 0.5);
      expect(s.toRow()['slug'], 'mock-1');
      final q = Question.fromJson({'set_id': 's', 'correct_index': 0, 'question_en': 'Q', 'topic_as': 'ইতিহাস', 'options_en': ['a', 'b']});
      expect(q.topic(AppLang.english), 'ইতিহাস');
      expect(q.toJson()['topic_as'], 'ইতিহাস');
      expect(QuestionSet(kind: QuizKind.topic).isMockTest, isFalse);
      expect(QuestionSet(kind: QuizKind.topic, timeLimitMinutes: 5).isMockTest, isTrue);
    });
  });

  test('ready-made mock tests are complete and bilingual', () {
    final dir = Directory('supabase/content/mock');
    final index = jsonDecode(File('${dir.path}/index.json').readAsStringSync()) as Map<String, dynamic>;
    final tests = index['tests'] as List;
    expect(tests, isNotEmpty);
    for (final t in tests) {
      final data = jsonDecode(File('${dir.path}/${t['file']}').readAsStringSync()) as Map<String, dynamic>;
      final set = QuestionSet.fromJson({...data['set'] as Map<String, dynamic>, 'slug': data['slug']});
      expect(set.kind, QuizKind.mock);
      expect(set.timeLimitMinutes, isNotNull);
      expect(set.title(AppLang.assamese), isNot(set.title(AppLang.english)));
      final qs = data['questions'] as List;
      expect(qs.length, t['questions']);
      for (final raw in qs) {
        final q = Question.fromJson({...raw as Map<String, dynamic>, 'set_id': 'x'});
        for (final f in ['question', 'explanation', 'topic']) {
          expect(q.text['${f}_en'], isNotEmpty, reason: '$f in English');
          expect(q.text['${f}_as'], isNotEmpty, reason: '$f in Assamese');
        }
        expect(q.optionsAs!.length, q.optionsEn!.length);
        expect(q.correctIndex, lessThan(q.optionsEn!.length));
      }
    }
  });

  testWidgets('Take a mock test: instructions, palette, mark for review, submit and analysis', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'app_lang': 'en'});
    final theme = ThemeController();
    final language = LanguageController();
    await theme.load();
    await language.load();
    final services = AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: AuthService(null));
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mock Tests'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sample mock test (layout test)'));
    await tester.pumpAndSettle();

    // Instructions page.
    expect(find.text('General instructions'), findsOneWidget);
    expect(find.text('Total marks'), findsOneWidget);
    expect(find.text('6'), findsOneWidget); // 3 questions × 2 marks
    expect(find.text('−0.5'), findsOneWidget);
    final start = find.widgetWithText(FilledButton, 'Start test');
    expect(tester.widget<FilledButton>(start).onPressed, isNull);
    await tester.tap(find.text('I have read and understood the instructions.'));
    await tester.pump();
    await tester.tap(start);
    await tester.pumpAndSettle();

    // The test.
    expect(find.text('Question 1 of 3'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    await tester.tap(find.text('Option A')); // right
    await tester.tap(find.text('Save & next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Option A')); // wrong
    await tester.tap(find.text('Mark for review'));
    await tester.pumpAndSettle();
    expect(find.text('Question 3 of 3'), findsOneWidget);

    // Jump back with the palette, then submit from the last question.
    await tester.tap(find.byTooltip('Question palette'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();
    expect(find.text('Question 2 of 3'), findsOneWidget);
    expect(find.text('Remove mark'), findsOneWidget);
    await tester.tap(find.text('Save & next'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Submit test'));
    await tester.pumpAndSettle();
    expect(find.text('Submit the test?'), findsOneWidget);
    await tester.tap(find.text('Go back'));
    await tester.pumpAndSettle();
    expect(find.text('Question 3 of 3'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Submit test'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Submit'));
    await tester.pumpAndSettle();

    // Analysis: 1 right (+2), 1 wrong (−0.5), 1 skipped.
    expect(find.text('Result analysis'), findsOneWidget);
    expect(find.text('1.5'), findsOneWidget);
    expect(find.text('out of 6'), findsOneWidget);
    expect(find.text('0.5 marks were taken away for wrong answers.'), findsOneWidget);
    expect(find.text('Topic-wise analysis'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Review answers'), 300);
    expect(find.text('Geography'), findsOneWidget);
    expect(services.progress.quizzesTaken, 1);
    expect(services.progress.last('qm')!.marks, 1.5);
  });

  testWidgets('A mock test submits by itself when time runs out', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'app_lang': 'en'});
    final theme = ThemeController();
    final language = LanguageController();
    await theme.load();
    await language.load();
    final services = AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: AuthService(null));
    final set = (await services.content!.questionSets()).firstWhere((s) => s.id == 'qm');
    final qs = await services.content!.questions('qm');
    var now = DateTime(2026, 11, 25, 10);
    await tester.pumpWidget(
      AppScope(
        services: services,
        child: LanguageScope(
          controller: language,
          child: MaterialApp(home: MockTestScreen(set: set, questions: qs, now: () => now)),
        ),
      ),
    );
    await tester.pump();
    // Wide screen: the palette is always shown beside the question.
    expect(find.text('Question palette'), findsOneWidget);
    expect(find.text('10:00'), findsOneWidget);
    await tester.tap(find.text('Option A')); // right
    await tester.pump();

    now = now.add(const Duration(minutes: 5, seconds: 30));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('04:30'), findsOneWidget);
    expect(find.text('Only 5 minutes left!'), findsNothing); // a 10-minute test warns only at 1 minute

    now = now.add(const Duration(minutes: 4));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Only 1 minute left!'), findsOneWidget);

    now = now.add(const Duration(minutes: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Result analysis'), findsOneWidget);
    expect(find.text('Time ran out, so the test was submitted by itself.'), findsOneWidget);
    expect(find.text('2'), findsWidgets); // 1 right × 2 marks
    expect(services.progress.last('qm')!.seconds, 600);
  });
}

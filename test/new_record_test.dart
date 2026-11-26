import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/i18n/strings.dart';
import 'package:assampedia/data/practice_models.dart';

QuizAttempt _a(int score, {String set = 'q1'}) => QuizAttempt(setId: set, score: score, total: 10, at: DateTime(2026));

void main() {
  test('A new record only when a later try beats the best so far', () async {
    SharedPreferences.setMockInitialValues({});
    final p = PracticeProgressStore();
    expect(p.isNewRecord(_a(5)), isFalse, reason: 'first try is not a record');
    await p.add(_a(5));
    expect(p.isNewRecord(_a(5)), isFalse, reason: 'equal score is not a record');
    expect(p.isNewRecord(_a(4)), isFalse);
    expect(p.isNewRecord(_a(7)), isTrue);
    expect(p.isNewRecord(_a(9, set: 'other')), isFalse, reason: 'other sets do not count');
  });

  test('Assamese label is নতুন অভিলেখ', () {
    expect(S(AppLang.assamese).newRecord, 'নতুন অভিলেখ');
    expect(S(AppLang.english).newRecord, 'New record');
  });
}

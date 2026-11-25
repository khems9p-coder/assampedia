import '../core/i18n/app_lang.dart';
import 'practice_models.dart';

/// How one question went in a mock test.
enum MockOutcome { correct, wrong, skipped }

/// Right, wrong and skipped counts for one topic.
class TopicStat {
  TopicStat(this.nameAs, this.nameEn);

  /// Topic names in each language (empty when the question has no topic).
  final String nameAs;
  final String nameEn;
  int correct = 0;
  int wrong = 0;
  int skipped = 0;

  int get total => correct + wrong + skipped;
  int get attempted => correct + wrong;

  /// Right answers out of all questions of this topic.
  double get score => total == 0 ? 0 : correct / total;

  String name(AppLang l, String fallback) {
    final own = l == AppLang.assamese ? nameAs : nameEn;
    final other = l == AppLang.assamese ? nameEn : nameAs;
    return own.isNotEmpty ? own : (other.isNotEmpty ? other : fallback);
  }
}

/// The result and analysis of one finished mock test.
class MockResult {
  MockResult._({
    required this.set,
    required this.questions,
    required this.answers,
    required this.marked,
    required this.secondsTaken,
    required this.secondsPerQuestion,
    required this.timeUp,
    required this.outcomes,
    required this.topics,
  });

  /// Works out the result from the reader's answers.
  ///
  /// [answers] maps a question's place in [questions] to the option chosen.
  factory MockResult.compute({
    required QuestionSet set,
    required List<Question> questions,
    required Map<int, int> answers,
    Set<int> marked = const {},
    int secondsTaken = 0,
    Map<int, int> secondsPerQuestion = const {},
    bool timeUp = false,
  }) {
    final outcomes = <MockOutcome>[];
    final topics = <String, TopicStat>{};
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      final chosen = answers[i];
      final o = chosen == null
          ? MockOutcome.skipped
          : chosen == q.correctIndex
          ? MockOutcome.correct
          : MockOutcome.wrong;
      outcomes.add(o);
      final en = q.text['topic_en']?.trim() ?? '';
      final as = q.text['topic_as']?.trim() ?? '';
      // Group by the English name when there is one, so a topic written in
      // both languages counts once.
      final key = (en.isNotEmpty ? en : as).toLowerCase();
      final t = topics.putIfAbsent(key, () => TopicStat(as, en));
      switch (o) {
        case MockOutcome.correct:
          t.correct++;
        case MockOutcome.wrong:
          t.wrong++;
        case MockOutcome.skipped:
          t.skipped++;
      }
    }
    return MockResult._(
      set: set,
      questions: questions,
      answers: Map.unmodifiable(answers),
      marked: Set.unmodifiable(marked),
      secondsTaken: secondsTaken,
      secondsPerQuestion: Map.unmodifiable(secondsPerQuestion),
      timeUp: timeUp,
      outcomes: List.unmodifiable(outcomes),
      topics: List.unmodifiable(topics.values),
    );
  }

  final QuestionSet set;
  final List<Question> questions;
  final Map<int, int> answers;
  final Set<int> marked;
  final int secondsTaken;
  final Map<int, int> secondsPerQuestion;

  /// True when the timer ran out and the test was submitted by itself.
  final bool timeUp;
  final List<MockOutcome> outcomes;

  /// In the order topics first appear in the test.
  final List<TopicStat> topics;

  int _count(MockOutcome o) => outcomes.where((x) => x == o).length;

  int get total => questions.length;
  int get correct => _count(MockOutcome.correct);
  int get wrong => _count(MockOutcome.wrong);
  int get skipped => _count(MockOutcome.skipped);
  int get attempted => correct + wrong;

  double get maxMarks => total * set.marksPerQuestion;
  double get marksGained => correct * set.marksPerQuestion;
  double get marksLost => wrong * set.negativeMarks;

  /// Final marks after negative marking (can go below zero, as in real exams).
  double get marks => marksGained - marksLost;

  /// Right answers out of the questions answered.
  double get accuracy => attempted == 0 ? 0 : correct / attempted;

  /// Marks as a share of the maximum (0 when below zero).
  double get percent => maxMarks == 0 ? 0 : (marks / maxMarks).clamp(0, 1).toDouble();

  int? get secondsAllowed => set.timeLimitMinutes == null ? null : set.timeLimitMinutes! * 60;

  /// Average time spent on each answered question, in seconds.
  int get secondsPerAnswer => attempted == 0 ? 0 : (secondsTaken / attempted).round();

  QuizAttempt toAttempt(DateTime at) => QuizAttempt(
    setId: set.id ?? '',
    score: correct,
    total: total,
    at: at,
    seconds: secondsTaken,
    marks: marks,
    maxMarks: maxMarks,
  );
}

/// Shows marks without a needless ".0" (2 → "2", 0.25 → "0.25", 0.5 → "0.5").
String formatMarks(double m) {
  if (m == m.roundToDouble()) return m.toInt().toString();
  var s = m.toStringAsFixed(2);
  if (s.endsWith('0')) s = s.substring(0, s.length - 1);
  return s;
}

/// 125 → "02:05"; 3725 → "1:02:05".
String formatClock(int secs) {
  if (secs < 0) secs = 0;
  final h = secs ~/ 3600;
  final m = (secs % 3600) ~/ 60;
  final s = secs % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

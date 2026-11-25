import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/i18n/app_lang.dart';

/// The kinds of practice sets (master plan, Part 10).
enum QuizKind {
  daily('daily', 'দৈনিক প্ৰশ্ন', 'Daily GK challenge'),
  chapter('chapter', 'অধ্যায়ভিত্তিক প্ৰশ্ন', 'Chapter-wise MCQs'),
  topic('topic', 'বিষয়ভিত্তিক কুইজ', 'Topic-wise quizzes'),
  district('district', 'জিলাভিত্তিক কুইজ', 'District-wise quizzes'),
  assamGk('assam_gk', 'অসমৰ সাধাৰণ জ্ঞান পৰীক্ষা', 'Assam GK tests'),
  history('history', 'ইতিহাস পৰীক্ষা', 'History tests'),
  geography('geography', 'ভূগোল পৰীক্ষা', 'Geography tests'),
  currentAffairs('current_affairs', 'সাম্প্ৰতিক ঘটনাৰ পৰীক্ষা', 'Current affairs tests'),
  pyq('pyq', 'পূৰ্বৰ বছৰৰ প্ৰশ্ন', 'Previous-year questions'),
  mock('mock', 'আদৰ্শ পৰীক্ষা', 'Mock examinations'),
  revision('revision', 'দ্ৰুত পুনৰীক্ষণ', 'Quick revision tests');

  const QuizKind(this.code, this.nameAs, this.nameEn);
  final String code;
  final String nameAs;
  final String nameEn;

  String name(AppLang l) => l == AppLang.assamese ? nameAs : nameEn;

  static QuizKind from(String? code) => values.firstWhere((k) => k.code == code, orElse: () => topic);
}

enum QuizLevel {
  beginner('beginner', 'আৰম্ভণি', 'Beginner'),
  intermediate('intermediate', 'মধ্যম', 'Intermediate'),
  advanced('advanced', 'উচ্চ', 'Advanced'),
  competitive('competitive', 'প্ৰতিযোগিতামূলক পৰীক্ষাৰ স্তৰ', 'Competitive exam level');

  const QuizLevel(this.code, this.nameAs, this.nameEn);
  final String code;
  final String nameAs;
  final String nameEn;

  String name(AppLang l) => l == AppLang.assamese ? nameAs : nameEn;

  static QuizLevel from(String? code) => values.firstWhere((k) => k.code == code, orElse: () => beginner);
}

String? _pick(Map<String, String> text, String field, AppLang l) {
  String? get(AppLang x) {
    final v = text['${field}_${x.code}'];
    return (v == null || v.trim().isEmpty) ? null : v;
  }

  return get(l) ?? get(l.other);
}

/// A quiz: a group of questions with one level and kind.
class QuestionSet {
  QuestionSet({
    this.id,
    this.kind = QuizKind.topic,
    this.level = QuizLevel.beginner,
    this.text = const {},
    this.contentId,
    this.timeLimitMinutes,
    this.position = 0,
    this.isPublished = false,
    this.questionCount = 0,
    this.marksPerQuestion = 1,
    this.negativeMarks = 0,
    this.slug,
  });

  static const textFields = ['title', 'description', 'instructions'];

  final String? id;
  final QuizKind kind;
  final QuizLevel level;

  /// `title_as`, `title_en`, `description_as`, `description_en`.
  final Map<String, String> text;
  final String? contentId;

  /// Set for timed mock tests; empty for practice quizzes.
  final int? timeLimitMinutes;
  final int position;
  final bool isPublished;
  final int questionCount;

  /// Marks for each right answer (mock tests).
  final double marksPerQuestion;

  /// Marks taken away for each wrong answer; 0 means no negative marking.
  final double negativeMarks;

  /// A short fixed name for ready-made tests (so courses can point to them).
  final String? slug;

  bool get isTimed => timeLimitMinutes != null;

  /// Taken like a real exam: instructions first, then a timer, a question
  /// palette and the analysis at the end.
  bool get isMockTest => kind == QuizKind.mock || isTimed;

  double get totalMarks => questionCount * marksPerQuestion;

  String title(AppLang l) => _pick(text, 'title', l) ?? '';
  String? description(AppLang l) => _pick(text, 'description', l);

  /// The admin's own instructions, one per line.
  List<String> instructions(AppLang l) => [
    for (final line in (_pick(text, 'instructions', l) ?? '').split('\n'))
      if (line.trim().isNotEmpty) line.trim().replaceFirst(RegExp(r'^[-•*]\s*'), ''),
  ];

  factory QuestionSet.fromJson(Map<String, dynamic> j) {
    final counted = j['questions'];
    return QuestionSet(
      id: j['id'] as String?,
      kind: QuizKind.from(j['kind'] as String?),
      level: QuizLevel.from(j['level'] as String?),
      text: {
        for (final f in textFields)
          for (final l in AppLang.values)
            if (j['${f}_${l.code}'] != null) '${f}_${l.code}': j['${f}_${l.code}'] as String,
      },
      contentId: j['content_id'] as String?,
      timeLimitMinutes: (j['time_limit_minutes'] as num?)?.toInt(),
      position: (j['position'] as num?)?.toInt() ?? 0,
      isPublished: j['is_published'] as bool? ?? false,
      // From select('*, questions(count)'), or saved offline as a number.
      questionCount: counted is List && counted.isNotEmpty
          ? ((counted.first as Map)['count'] as num).toInt()
          : (j['question_count'] as num?)?.toInt() ?? 0,
      marksPerQuestion: (j['marks_per_question'] as num?)?.toDouble() ?? 1,
      negativeMarks: (j['negative_marks'] as num?)?.toDouble() ?? 0,
      slug: j['slug'] as String?,
    );
  }

  /// Columns saved to the database.
  Map<String, dynamic> toRow() => {
    'id': ?id,
    'kind': kind.code,
    'level': level.code,
    for (final f in textFields)
      for (final l in AppLang.values) '${f}_${l.code}': text['${f}_${l.code}'],
    'content_id': contentId,
    'time_limit_minutes': timeLimitMinutes,
    'position': position,
    'is_published': isPublished,
    'marks_per_question': marksPerQuestion,
    'negative_marks': negativeMarks,
    'slug': slug,
  };

  Map<String, dynamic> toJson() => {...toRow(), 'question_count': questionCount};
}

/// One multiple-choice question in both languages.
class Question {
  Question({
    this.id,
    required this.setId,
    this.position = 0,
    this.text = const {},
    this.optionsAs,
    this.optionsEn,
    required this.correctIndex,
    this.source,
  });

  static const textFields = ['question', 'explanation', 'background', 'relevance', 'topic'];

  final String? id;
  final String setId;
  final int position;

  /// `question_as`, `explanation_en`, `background_as`, `relevance_en` and so on.
  final Map<String, String> text;
  final List<String>? optionsAs;
  final List<String>? optionsEn;
  final int correctIndex;
  final String? source;

  String? get(String field, AppLang l) => _pick(text, field, l);

  String question(AppLang l) => get('question', l) ?? '';

  /// The topic (e.g. History), for the topic-wise analysis of mock tests.
  String? topic(AppLang l) => get('topic', l);

  /// The options in [l]. Falls back to the other language together with the
  /// question, so a question and its options are always in the same language.
  List<String> options(AppLang l) {
    final hasOwn = text['question_${l.code}']?.trim().isNotEmpty ?? false;
    final own = l == AppLang.assamese ? optionsAs : optionsEn;
    final other = l == AppLang.assamese ? optionsEn : optionsAs;
    return (hasOwn ? own : other) ?? own ?? other ?? const [];
  }

  static List<String>? _list(Object? v) => v == null ? null : [for (final x in v as List) x as String];

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    id: j['id'] as String?,
    setId: j['set_id'] as String,
    position: (j['position'] as num?)?.toInt() ?? 0,
    text: {
      for (final f in textFields)
        for (final l in AppLang.values)
          if (j['${f}_${l.code}'] != null) '${f}_${l.code}': j['${f}_${l.code}'] as String,
    },
    optionsAs: _list(j['options_as']),
    optionsEn: _list(j['options_en']),
    correctIndex: (j['correct_index'] as num).toInt(),
    source: j['source'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': ?id,
    'set_id': setId,
    'position': position,
    for (final f in textFields)
      for (final l in AppLang.values) '${f}_${l.code}': text['${f}_${l.code}'],
    'options_as': optionsAs,
    'options_en': optionsEn,
    'correct_index': correctIndex,
    'source': source,
  };
}

DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Which question to show as the daily challenge: a new one each day, going
/// round the list in order.
int dailyIndex(DateTime today, int count) {
  if (count <= 0) return -1;
  final days = _day(today).difference(DateTime.utc(2026)).inDays;
  return days % count;
}

/// One finished quiz, kept on the phone.
class QuizAttempt {
  QuizAttempt({
    required this.setId,
    required this.score,
    required this.total,
    required this.at,
    this.seconds = 0,
    this.marks,
    this.maxMarks,
  });

  final String setId;

  /// Number of right answers.
  final int score;
  final int total;
  final DateTime at;
  final int seconds;

  /// Mock tests only: marks after negative marking, out of [maxMarks].
  final double? marks;
  final double? maxMarks;

  double get accuracy => total == 0 ? 0 : score / total;

  factory QuizAttempt.fromJson(Map<String, dynamic> j) => QuizAttempt(
    setId: j['set_id'] as String,
    score: (j['score'] as num).toInt(),
    total: (j['total'] as num).toInt(),
    at: DateTime.parse(j['at'] as String),
    seconds: (j['seconds'] as num?)?.toInt() ?? 0,
    marks: (j['marks'] as num?)?.toDouble(),
    maxMarks: (j['max_marks'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'set_id': setId,
    'score': score,
    'total': total,
    'at': at.toIso8601String(),
    'seconds': seconds,
    'marks': ?marks,
    'max_marks': ?maxMarks,
  };
}

/// Scores and accuracy, stored on this phone only (no account needed).
class PracticeProgressStore extends ChangeNotifier {
  static const _key = 'quiz_attempts';
  static const _max = 300;
  final List<QuizAttempt> _items = [];

  List<QuizAttempt> get attempts => List.unmodifiable(_items);

  Future<void> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);
    _items.clear();
    if (raw != null) {
      try {
        _items.addAll([for (final j in jsonDecode(raw) as List) QuizAttempt.fromJson(j as Map<String, dynamic>)]);
      } catch (_) {
        // Ignore a damaged list rather than crash.
      }
    }
    notifyListeners();
  }

  Future<void> add(QuizAttempt a) async {
    _items.insert(0, a);
    if (_items.length > _max) _items.removeRange(_max, _items.length);
    notifyListeners();
    await (await SharedPreferences.getInstance()).setString(_key, jsonEncode([for (final x in _items) x.toJson()]));
  }

  int get quizzesTaken => _items.length;
  int get questionsAnswered => _items.fold(0, (s, a) => s + a.total);
  int get correctAnswers => _items.fold(0, (s, a) => s + a.score);
  double get accuracy => questionsAnswered == 0 ? 0 : correctAnswers / questionsAnswered;

  /// The most recent attempt at a set, or null if it was never taken.
  QuizAttempt? last(String? setId) {
    for (final a in _items) {
      if (a.setId == setId) return a;
    }
    return null;
  }

  /// How many times a set was taken.
  int timesTaken(String? setId) => _items.where((a) => a.setId == setId).length;

  /// Best score for a set, or null if it was never taken.
  QuizAttempt? best(String? setId) {
    QuizAttempt? b;
    for (final a in _items) {
      if (a.setId == setId && (b == null || a.accuracy > b.accuracy)) b = a;
    }
    return b;
  }
}

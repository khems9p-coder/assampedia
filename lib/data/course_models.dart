import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/i18n/app_lang.dart';

String? _pick(String? as, String? en, AppLang l) {
  String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v;
  final mine = l == AppLang.assamese ? clean(as) : clean(en);
  return mine ?? (l == AppLang.assamese ? clean(en) : clean(as));
}

/// A course: an ordered study path for one exam, made of pages and quizzes
/// that are already in the app.
class Course {
  Course({
    this.id,
    required this.slug,
    this.titleAs,
    this.titleEn,
    this.descriptionAs,
    this.descriptionEn,
    this.icon,
    this.position = 0,
    this.isPublished = false,
    this.lessonCount = 0,
  });

  final String? id;
  final String slug;
  final String? titleAs;
  final String? titleEn;
  final String? descriptionAs;
  final String? descriptionEn;
  final String? icon;
  final int position;
  final bool isPublished;

  /// How many lessons the course has (counted by the database).
  final int lessonCount;

  String title(AppLang l) => _pick(titleAs, titleEn, l) ?? slug;
  String? description(AppLang l) => _pick(descriptionAs, descriptionEn, l);

  factory Course.fromJson(Map<String, dynamic> j) {
    final counted = j['course_items'];
    return Course(
      id: j['id'] as String?,
      slug: j['slug'] as String,
      titleAs: j['title_as'] as String?,
      titleEn: j['title_en'] as String?,
      descriptionAs: j['description_as'] as String?,
      descriptionEn: j['description_en'] as String?,
      icon: j['icon'] as String?,
      position: (j['position'] as num?)?.toInt() ?? 0,
      isPublished: j['is_published'] as bool? ?? false,
      // From select('*, course_items(count)'), or saved offline as a number.
      lessonCount: counted is List && counted.isNotEmpty
          ? ((counted.first as Map)['count'] as num).toInt()
          : (j['lesson_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// Columns saved to the database.
  Map<String, dynamic> toRow() => {
    'id': ?id,
    'slug': slug,
    'title_as': titleAs,
    'title_en': titleEn,
    'description_as': descriptionAs,
    'description_en': descriptionEn,
    'icon': icon,
    'position': position,
    'is_published': isPublished,
  };

  Map<String, dynamic> toJson() => {...toRow(), 'lesson_count': lessonCount};
}

/// What a lesson opens.
enum LessonKind { chapter, exam, career, news, quiz }

LessonKind lessonKindFrom(String? s) => switch (s) {
  'quiz' => LessonKind.quiz,
  'exam' => LessonKind.exam,
  'job_profile' => LessonKind.career,
  'current_affairs' => LessonKind.news,
  _ => LessonKind.chapter,
};

String lessonKindCode(LessonKind k) => switch (k) {
  LessonKind.quiz => 'quiz',
  LessonKind.exam => 'exam',
  LessonKind.career => 'job_profile',
  LessonKind.news => 'current_affairs',
  LessonKind.chapter => 'gk_chapter',
};

/// One lesson of a course, as readers see it.
class CourseLesson {
  CourseLesson({
    required this.id,
    required this.number,
    this.contentId,
    this.setId,
    this.kind = LessonKind.chapter,
    this.titleAs,
    this.titleEn,
    this.isFree = false,
  });

  final String id;

  /// 1, 2, 3 ... in the order readers see.
  final int number;
  final String? contentId;
  final String? setId;
  final LessonKind kind;
  final String? titleAs;
  final String? titleEn;

  /// Free lessons open without Premium (the database decides this).
  final bool isFree;

  String title(AppLang l) => _pick(titleAs, titleEn, l) ?? '';

  /// True when the title exists only in the other language.
  bool missingIn(AppLang l) => (l == AppLang.assamese ? titleAs : titleEn)?.trim().isNotEmpty != true;

  factory CourseLesson.fromJson(Map<String, dynamic> j) => CourseLesson(
    id: j['id'] as String,
    number: (j['lesson_no'] as num).toInt(),
    contentId: j['content_id'] as String?,
    setId: j['set_id'] as String?,
    kind: lessonKindFrom(j['kind'] as String?),
    titleAs: j['title_as'] as String?,
    titleEn: j['title_en'] as String?,
    isFree: j['is_free'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lesson_no': number,
    'content_id': contentId,
    'set_id': setId,
    'kind': lessonKindCode(kind),
    'title_as': titleAs,
    'title_en': titleEn,
    'is_free': isFree,
  };
}

/// A lesson row in the admin editor (drafts included).
class CourseItem {
  CourseItem({this.id, required this.courseId, this.position = 0, this.contentId, this.setId, this.label = ''});

  final String? id;
  final String courseId;
  final int position;
  final String? contentId;
  final String? setId;

  /// What the admin sees: the page or quiz title.
  final String label;

  bool get isQuiz => setId != null;

  factory CourseItem.fromJson(Map<String, dynamic> j) {
    String label = '';
    final content = j['content'] as Map<String, dynamic>?;
    final set = j['question_sets'] as Map<String, dynamic>?;
    if (content != null) {
      final versions = [for (final v in content['content_versions'] as List? ?? const []) v as Map<String, dynamic>];
      String? t(String lang) => versions.where((v) => v['lang'] == lang).map((v) => v['title'] as String?).firstOrNull;
      label = t('en') ?? t('as') ?? content['slug'] as String? ?? '';
    } else if (set != null) {
      label = (set['title_en'] as String?) ?? (set['title_as'] as String?) ?? '';
    }
    return CourseItem(
      id: j['id'] as String?,
      courseId: j['course_id'] as String,
      position: (j['position'] as num?)?.toInt() ?? 0,
      contentId: j['content_id'] as String?,
      setId: j['set_id'] as String?,
      label: label,
    );
  }
}

/// Which lessons this reader has finished, kept on this phone.
class CourseProgressStore extends ChangeNotifier {
  static const _key = 'course_done';
  Set<String>? _done;

  Future<Set<String>> _load() async {
    if (_done != null) return _done!;
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      _done = raw == null ? <String>{} : {for (final x in jsonDecode(raw) as List) x as String};
    } catch (_) {
      _done = <String>{};
    }
    return _done!;
  }

  /// Loads the saved list once; screens call this before showing ticks.
  Future<void> ready() async {
    await _load();
    notifyListeners();
  }

  bool isDone(String lessonId) => _done?.contains(lessonId) ?? false;

  int doneCount(Iterable<String> lessonIds) => lessonIds.where(isDone).length;

  Future<void> setDone(String lessonId, bool done) async {
    final set = await _load();
    if (done ? !set.add(lessonId) : !set.remove(lessonId)) return;
    notifyListeners();
    try {
      await (await SharedPreferences.getInstance()).setString(_key, jsonEncode(set.toList()));
    } catch (_) {}
  }
}

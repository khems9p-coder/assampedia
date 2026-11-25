import 'content_repository.dart';
import 'course_models.dart';
import 'jobs_models.dart';
import 'models.dart';
import 'offline_cache.dart';
import 'practice_models.dart';
import 'study_models.dart';

/// Wraps the online repository: every successful download is saved, and when
/// the phone is offline the saved copy is shown instead.
class CachedContentRepository implements ContentRepository {
  CachedContentRepository(this.remote, this.cache);
  final ContentRepository remote;
  final OfflineCache cache;

  /// True when the last answer came from the saved copy.
  bool lastWasOffline = false;

  Future<T> _try<T>(String key, Future<T> Function() fetch, Object Function(T) toJson, T Function(dynamic) fromJson) async {
    try {
      final value = await fetch();
      lastWasOffline = false;
      await cache.write(key, toJson(value));
      return value;
    } catch (e) {
      final saved = await cache.read(key);
      if (saved == null) rethrow;
      lastWasOffline = true;
      return fromJson(saved);
    }
  }

  @override
  Future<List<Category>> categories({String section = 'gk'}) => _try(
    section == 'gk' ? 'categories' : 'categories_$section',
    () => remote.categories(section: section),
    (v) => [for (final c in v) c.toJson()],
    (j) => [for (final c in j as List) Category.fromJson(c as Map<String, dynamic>)],
  );

  @override
  Future<List<ChapterSummary>> chapters(String categoryId) => _try(
    'chapters_$categoryId',
    () => remote.chapters(categoryId),
    (v) => [for (final c in v) c.toJson()],
    (j) => [for (final c in j as List) ChapterSummary.fromJson(c as Map<String, dynamic>)],
  );

  @override
  Future<Chapter> chapter(String contentId) =>
      _try('chapter_$contentId', () => remote.chapter(contentId), (v) => v.toJson(), (j) => Chapter.fromJson(j as Map<String, dynamic>));

  @override
  Future<List<Term>> terms() => _try(
    'terms',
    remote.terms,
    (v) => [for (final t in v) t.toJson()],
    (j) => [for (final t in j as List) Term.fromJson(t as Map<String, dynamic>)],
  );

  /// Searches online; without internet, searches the chapters saved on this phone.
  @override
  Future<SearchResults> search(String query) async {
    try {
      final r = await remote.search(query);
      lastWasOffline = false;
      return r;
    } catch (_) {
      final saved = await cache.readAll('chapter_');
      final chapters = [for (final j in saved) Chapter.fromJson(j as Map<String, dynamic>)];
      final savedTerms = await cache.read('terms');
      final terms = savedTerms == null ? <Term>[] : [for (final t in savedTerms as List) Term.fromJson(t as Map<String, dynamic>)];
      lastWasOffline = true;
      return searchLocally(chapters, terms, query, offline: true);
    }
  }

  @override
  Future<List<Vacancy>> vacancies() => _try(
    'vacancies',
    remote.vacancies,
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) Vacancy.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<NewsItem>> currentAffairs() => _try(
    'current_affairs',
    remote.currentAffairs,
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) NewsItem.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<QuestionSet>> questionSets() => _try(
    'question_sets',
    remote.questionSets,
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) QuestionSet.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<Question>> questions(String setId) => _try(
    'questions_$setId',
    () => remote.questions(setId),
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) Question.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<Course>> courses() => _try(
    'courses',
    remote.courses,
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) Course.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<CourseLesson>> courseLessons(String courseId) => _try(
    'course_lessons_$courseId',
    () => remote.courseLessons(courseId),
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) CourseLesson.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<StudySection>> studySections() => _try(
    'study_sections',
    remote.studySections,
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) StudySection.fromJson(x as Map<String, dynamic>)],
  );

  @override
  Future<List<StudyItem>> studyItems(String sectionId) => _try(
    'study_items_$sectionId',
    () => remote.studyItems(sectionId),
    (v) => [for (final x in v) x.toJson()],
    (j) => [for (final x in j as List) StudyItem.fromJson(x as Map<String, dynamic>)],
  );

  /// Files need the internet (the address is checked and expires).
  @override
  Future<String> studyFileUrl(String path) => remote.studyFileUrl(path);
}

import 'course_models.dart';
import 'jobs_models.dart';
import 'models.dart';
import 'practice_models.dart';
import 'study_models.dart';

/// Where the app gets its content from.
abstract class ContentRepository {
  /// [section]: 'gk' (encyclopedia), 'exam' or 'job'.
  Future<List<Category>> categories({String section = 'gk'});
  Future<List<ChapterSummary>> chapters(String categoryId);
  Future<Chapter> chapter(String contentId);
  Future<List<Term>> terms();
  Future<SearchResults> search(String query);

  /// Published job vacancies (open and closed; the app decides how to show them).
  Future<List<Vacancy>> vacancies();

  /// Published current-affairs items, newest first.
  Future<List<NewsItem>> currentAffairs();

  /// Published practice sets, with how many questions each has.
  Future<List<QuestionSet>> questionSets();

  /// The questions of one set, in order.
  Future<List<Question>> questions(String setId);

  /// Published courses (study paths), in order.
  Future<List<Course>> courses();

  /// The lessons of one course, in order, with which ones are free.
  Future<List<CourseLesson>> courseLessons(String courseId);

  /// Every published study section and sub-section (the app builds the tree).
  Future<List<StudySection>> studySections();

  /// The items of one section, in order, with which ones are free.
  Future<List<StudyItem>> studyItems(String sectionId);

  /// A short-lived web address for a study file (PDF or picture). The
  /// database only gives one when the reader may open the file.
  Future<String> studyFileUrl(String path);
}

extension DailyQuestion on ContentRepository {
  /// Today's question from the "Daily GK challenge" sets, or null if there are none.
  Future<Question?> dailyQuestion(DateTime today) async {
    final sets = [
      for (final s in await questionSets())
        if (s.kind == QuizKind.daily && s.id != null) s,
    ];
    final all = [for (final s in sets) ...await questions(s.id!)];
    final i = dailyIndex(today, all.length);
    return i < 0 ? null : all[i];
  }
}

class NotConnectedException implements Exception {}

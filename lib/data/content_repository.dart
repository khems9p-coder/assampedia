import 'jobs_models.dart';
import 'models.dart';

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
}

class NotConnectedException implements Exception {}

import 'models.dart';

/// Where the app gets its content from.
abstract class ContentRepository {
  Future<List<Category>> categories();
  Future<List<ChapterSummary>> chapters(String categoryId);
  Future<Chapter> chapter(String contentId);
  Future<List<Term>> terms();
  Future<SearchResults> search(String query);
}

class NotConnectedException implements Exception {}

import 'models.dart';

/// Where the app gets its content from.
abstract class ContentRepository {
  Future<List<Category>> categories();
  Future<List<ChapterSummary>> chapters(String categoryId);
  Future<Chapter> chapter(String contentId);
}

class NotConnectedException implements Exception {}

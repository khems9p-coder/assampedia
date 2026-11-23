import 'content_repository.dart';
import 'models.dart';
import 'offline_cache.dart';

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
  Future<List<Category>> categories() => _try(
        'categories',
        remote.categories,
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
  Future<Chapter> chapter(String contentId) => _try(
        'chapter_$contentId',
        () => remote.chapter(contentId),
        (v) => v.toJson(),
        (j) => Chapter.fromJson(j as Map<String, dynamic>),
      );
}

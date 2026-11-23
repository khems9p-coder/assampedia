import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../core/i18n/app_lang.dart';
import 'content_repository.dart';
import 'models.dart';

/// Reads content from Supabase. The database's security rules make sure
/// readers only receive published language versions.
class SupabaseContentRepository implements ContentRepository {
  SupabaseContentRepository(this.client);
  final SupabaseClient client;

  @override
  Future<List<Category>> categories() async {
    final rows = await client
        .from('categories')
        .select('id, slug, position, icon, name_as, name_en, is_published')
        .isFilter('parent_id', null)
        .order('position');
    return [for (final r in rows) Category.fromJson(r)];
  }

  @override
  Future<List<ChapterSummary>> chapters(String categoryId) async {
    final rows = await client
        .from('content')
        .select('id, slug, position, content_versions(lang, title, status)')
        .eq('category_id', categoryId)
        .order('position');
    return [
      for (final r in rows)
        if ((r['content_versions'] as List).isNotEmpty) ChapterSummary.fromJson(r),
    ];
  }

  @override
  Future<Chapter> chapter(String contentId) async {
    final content = await client.from('content').select('id, slug, category_id').eq('id', contentId).single();
    final versions = await client
        .from('content_versions')
        .select('lang, title, summary, sources, last_checked, status')
        .eq('content_id', contentId);
    final blocks = await client
        .from('content_blocks')
        .select('lang, block_key, position, block_type, style, body, image_url')
        .eq('content_id', contentId)
        .order('position');
    final map = <AppLang, ChapterVersion>{};
    for (final v in versions) {
      final l = AppLang.fromCode(v['lang'] as String?);
      if (l == null) continue;
      map[l] = ChapterVersion(
        title: v['title'] as String,
        summary: v['summary'] as String?,
        sources: v['sources'] as String?,
        lastChecked: v['last_checked'] as String?,
        status: v['status'] as String? ?? 'published',
        blocks: [
          for (final b in blocks)
            if (b['lang'] == l.code) Block.fromJson(b),
        ],
      );
    }
    return Chapter(
      id: content['id'] as String,
      slug: content['slug'] as String,
      categoryId: content['category_id'] as String?,
      versions: map,
    );
  }
}

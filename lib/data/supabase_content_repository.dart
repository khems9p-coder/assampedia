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

  @override
  Future<List<Term>> terms() async {
    final rows = await client.from('terms').select('id, slug, term_as, term_en, meaning_as, meaning_en, is_published').order('slug');
    return [for (final r in rows) Term.fromJson(r)];
  }

  @override
  Future<SearchResults> search(String query) async {
    final q = cleanQuery(query);
    if (q.isEmpty) return SearchResults();
    final pattern = '%$q%';
    final titlesFound = client.from('content_versions').select('content_id, lang, title, summary').ilike('title', pattern).limit(20);
    final blocksFound = client.from('content_blocks').select('content_id, lang, block_key, body').ilike('body', pattern).limit(40);
    final termsFound = terms();
    final titleRows = await titlesFound;
    final blockRows = await blocksFound;
    final allTerms = await termsFound;

    // Chapter titles in both languages for every chapter found.
    final ids = {
      for (final r in [...titleRows, ...blockRows]) r['content_id'] as String,
    };
    final titles = <String, Map<AppLang, String>>{};
    if (ids.isNotEmpty) {
      final rows = await client.from('content_versions').select('content_id, lang, title').inFilter('content_id', ids.toList());
      for (final r in rows) {
        final l = AppLang.fromCode(r['lang'] as String?);
        if (l != null) (titles[r['content_id'] as String] ??= {})[l] = r['title'] as String;
      }
    }

    final hits = <SearchHit>[];
    for (final r in titleRows) {
      final l = AppLang.fromCode(r['lang'] as String?);
      final id = r['content_id'] as String;
      if (l == null || titles[id] == null) continue;
      hits.add(SearchHit(contentId: id, titles: titles[id]!, lang: l, snippet: (r['summary'] as String?) ?? (r['title'] as String)));
    }
    final termMap = {for (final t in allTerms) t.slug: t};
    for (final r in blockRows) {
      final l = AppLang.fromCode(r['lang'] as String?);
      final id = r['content_id'] as String;
      if (l == null || titles[id] == null) continue;
      final text = plainText(r['body'] as String? ?? '', termMap, l);
      // Skip matches that were only inside a term marker like {{term:...}}.
      if (!text.toLowerCase().contains(q.toLowerCase())) continue;
      hits.add(
        SearchHit(contentId: id, titles: titles[id]!, blockKey: r['block_key'] as String?, lang: l, snippet: snippetAround(text, q)),
      );
    }
    return SearchResults(
      chapters: hits,
      terms: [
        for (final t in allTerms)
          if (termMatches(t, q)) t,
      ],
    );
  }
}

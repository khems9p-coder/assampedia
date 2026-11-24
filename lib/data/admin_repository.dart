import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/i18n/app_lang.dart';
import 'models.dart';

/// Everything the admin screens can change. The database only accepts these
/// changes from accounts marked as admin.
class AdminRepository {
  AdminRepository(this.client);
  final SupabaseClient client;

  Future<List<Category>> categories() async {
    final rows = await client
        .from('categories')
        .select('id, slug, position, icon, name_as, name_en, is_published')
        .order('position');
    return [for (final r in rows) Category.fromJson(r)];
  }

  Future<List<ChapterSummary>> chapters(String categoryId) async {
    final rows = await client
        .from('content')
        .select('id, slug, position, content_versions(lang, title, status)')
        .eq('category_id', categoryId)
        .order('position');
    return [for (final r in rows) ChapterSummary.fromJson(r)];
  }

  Future<Map<String, dynamic>> loadForEdit(String contentId) async {
    final content = await client.from('content').select().eq('id', contentId).single();
    final versions = await client.from('content_versions').select().eq('content_id', contentId);
    final blocks = await client.from('content_blocks').select().eq('content_id', contentId).order('position');
    return {'content': content, 'versions': versions, 'blocks': blocks};
  }

  /// Saves a chapter. Blocks are replaced as a whole so their order and keys
  /// always match what the editor shows.
  Future<String> save({
    String? id,
    required String slug,
    required String categoryId,
    required int position,
    required Map<AppLang, ChapterVersion> versions,
  }) async {
    final row = await client
        .from('content')
        .upsert({
          'id': ?id,
          'slug': slug,
          'category_id': categoryId,
          'position': position,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .select('id')
        .single();
    final contentId = row['id'] as String;

    for (final l in AppLang.values) {
      final v = versions[l];
      if (v == null) {
        await client.from('content_versions').delete().eq('content_id', contentId).eq('lang', l.code);
        continue;
      }
      await client.from('content_versions').upsert({
        'content_id': contentId,
        'lang': l.code,
        'title': v.title,
        'summary': v.summary,
        'sources': v.sources,
        'last_checked': v.lastChecked,
        'status': v.status,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      });
    }

    await client.from('content_blocks').delete().eq('content_id', contentId);
    final rows = [
      for (final e in versions.entries)
        for (final b in e.value.blocks) {...b.toJson(), 'content_id': contentId, 'lang': e.key.code},
    ];
    if (rows.isNotEmpty) await client.from('content_blocks').insert(rows);
    return contentId;
  }

  Future<void> delete(String contentId) => client.from('content').delete().eq('id', contentId);

  /// All dictionary terms, including hidden ones.
  Future<List<Term>> terms() async {
    final rows = await client.from('terms').select().order('slug');
    return [for (final r in rows) Term.fromJson(r)];
  }

  Future<void> saveTerm(Term t) =>
      client.from('terms').upsert({...t.toJson(), 'updated_at': DateTime.now().toUtc().toIso8601String()}, onConflict: 'slug');

  Future<void> deleteTerm(String slug) => client.from('terms').delete().eq('slug', slug);
}

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/i18n/app_lang.dart';
import 'jobs_models.dart';
import 'models.dart';
import 'practice_models.dart';

/// Everything the admin screens can change. The database only accepts these
/// changes from accounts marked as admin.
class AdminRepository {
  AdminRepository(this.client);
  final SupabaseClient client;

  /// Every category in all three sections (GK, exams, careers).
  Future<List<Category>> categories() async {
    final rows = await client.from('categories').select().order('position', ascending: true);
    return [for (final r in rows) Category.fromJson(r)];
  }

  Future<List<ChapterSummary>> chapters(String categoryId) async {
    final rows = await client
        .from('content')
        .select('id, slug, position, content_versions(lang, title, status)')
        .eq('category_id', categoryId)
        .order('position', ascending: true);
    return [for (final r in rows) ChapterSummary.fromJson(r)];
  }

  Future<Map<String, dynamic>> loadForEdit(String contentId) async {
    final content = await client.from('content').select().eq('id', contentId).single();
    final versions = await client.from('content_versions').select().eq('content_id', contentId);
    final blocks = await client
        .from('content_blocks')
        .select()
        .eq('content_id', contentId)
        .order('position', ascending: true);
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
    String section = 'gk',
    String? officialUrl,
    String? notificationUrl,
    String? appliesTo,
    DateTime? eventDate,
  }) async {
    final row = await client
        .from('content')
        .upsert({
          'id': ?id,
          'slug': slug,
          'category_id': categoryId,
          'position': position,
          'kind': switch (section) {
            'exam' => 'exam',
            'job' => 'job_profile',
            'ca' => 'current_affairs',
            _ => 'gk_chapter',
          },
          // Only exam and career pages use these (added in Phase 4).
          if (section == 'exam' || section == 'job') ...{
            'official_url': officialUrl,
            'notification_url': notificationUrl,
            'applies_to': appliesTo,
          },
          // Current-affairs articles carry the date of the event (Phase 5).
          if (section == 'ca') 'event_date': eventDate?.toIso8601String().substring(0, 10),
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

  /// Adds one group of ready-made chapters (from the content JSON files) as
  /// drafts. Chapters and dictionary words that already exist are left alone,
  /// so importing the same group twice is safe.
  Future<ImportResult> importGroup(Map<String, dynamic> group) async {
    final terms = [
      for (final t in group['terms'] as List)
        {
          'slug': t['slug'],
          'term_en': t['term_en'],
          'term_as': t['term_as'],
          'meaning_en': t['meaning_en'],
          'meaning_as': t['meaning_as'],
        },
    ];
    if (terms.isNotEmpty) {
      await client.from('terms').upsert(terms, onConflict: 'slug', ignoreDuplicates: true);
    }

    final cat = await client.from('categories').select('id').eq('slug', group['category_slug'] as String).maybeSingle();
    if (cat == null) throw StateError('The group "${group['category_name']}" was not found in the database.');
    final categoryId = cat['id'] as String;

    var added = 0;
    var skipped = 0;
    var pictures = 0;
    for (final ch in group['chapters'] as List) {
      final slug = ch['slug'] as String;
      final existing = await client.from('content').select('id').eq('slug', slug).maybeSingle();
      if (existing != null) {
        skipped++;
        pictures += await _addPictures(existing['id'] as String, ch['blocks'] as Map<String, dynamic>);
        continue;
      }
      final row = await client
          .from('content')
          .insert({'slug': slug, 'kind': 'gk_chapter', 'category_id': categoryId, 'position': ch['position']})
          .select('id')
          .single();
      final contentId = row['id'] as String;
      try {
        final versions = ch['versions'] as Map<String, dynamic>;
        await client.from('content_versions').insert([
          for (final e in versions.entries)
            {
              'content_id': contentId,
              'lang': e.key,
              'title': e.value['title'],
              'summary': e.value['summary'],
              'status': 'draft',
              'sources': ch['sources'],
              'last_checked': group['last_checked'],
            },
        ]);
        final blocks = ch['blocks'] as Map<String, dynamic>;
        await client.from('content_blocks').insert([
          for (final e in blocks.entries)
            for (final (i, b) in (e.value as List).indexed)
              {
                'content_id': contentId,
                'lang': e.key,
                'block_key': b['block_key'],
                'position': i + 1,
                'block_type': b['block_type'],
                'style': b['style'],
                'body': b['body'],
                'image_url': ?b['image_url'],
              },
        ]);
      } catch (_) {
        // Don't leave a half-made chapter behind; the next import will retry it.
        await client.from('content').delete().eq('id', contentId);
        rethrow;
      }
      added++;
    }
    return ImportResult(added: added, skipped: skipped, terms: terms.length, pictures: pictures);
  }

  /// For a chapter that is already in the database: adds any new picture blocks
  /// (and nothing else, so your own edits stay), then puts the blocks back in
  /// the order of the ready-made chapter. Returns how many pictures were added.
  Future<int> _addPictures(String contentId, Map<String, dynamic> blocks) async {
    final rows = await client.from('content_blocks').select('lang, block_key').eq('content_id', contentId);
    final have = {for (final r in rows) '${r['lang']}/${r['block_key']}'};
    var added = 0;
    for (final e in blocks.entries) {
      final list = e.value as List;
      final missing = [
        for (final b in list)
          if (b['block_type'] == 'image' && !have.contains('${e.key}/${b['block_key']}')) b,
      ];
      if (missing.isEmpty) continue;
      await client.from('content_blocks').insert([
        for (final b in missing)
          {
            'content_id': contentId,
            'lang': e.key,
            'block_key': b['block_key'],
            'position': list.indexOf(b) + 1,
            'block_type': 'image',
            'style': b['style'],
            'body': b['body'],
            'image_url': b['image_url'],
          },
      ]);
      added += missing.length;
      for (final (i, b) in list.indexed) {
        if (missing.contains(b) || !have.contains('${e.key}/${b['block_key']}')) continue;
        await client
            .from('content_blocks')
            .update({'position': i + 1})
            .eq('content_id', contentId)
            .eq('lang', e.key)
            .eq('block_key', b['block_key'] as String);
      }
    }
    return added;
  }

  /// All dictionary terms, including hidden ones.
  Future<List<Term>> terms() async {
    final rows = await client.from('terms').select().order('slug', ascending: true);
    return [for (final r in rows) Term.fromJson(r)];
  }

  Future<void> saveTerm(Term t) => client.from('terms').upsert({
    ...t.toJson(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  }, onConflict: 'slug');

  Future<void> deleteTerm(String slug) => client.from('terms').delete().eq('slug', slug);

  /// Every vacancy, including drafts, soonest deadline first.
  Future<List<Vacancy>> vacancies() async {
    final rows = await client.from('vacancies').select().order('closing_date', ascending: true);
    return [for (final r in rows) Vacancy.fromJson(r)];
  }

  Future<void> saveVacancy(Vacancy v) =>
      client.from('vacancies').upsert({...v.toJson(), 'updated_at': DateTime.now().toUtc().toIso8601String()});

  Future<void> deleteVacancy(String id) => client.from('vacancies').delete().eq('id', id);

  /// Every practice set, including drafts.
  Future<List<QuestionSet>> questionSets() async {
    final rows = await client
        .from('question_sets')
        .select()
        .order('position', ascending: true)
        .order('id', ascending: true);
    return [for (final r in rows) QuestionSet.fromJson(r)];
  }

  Future<QuestionSet> saveSet(QuestionSet set) async {
    final row = await client
        .from('question_sets')
        .upsert({...set.toRow(), 'updated_at': DateTime.now().toUtc().toIso8601String()})
        .select()
        .single();
    return QuestionSet.fromJson(row);
  }

  /// Deletes a set and all its questions.
  Future<void> deleteSet(String id) => client.from('question_sets').delete().eq('id', id);

  Future<List<Question>> questions(String setId) async {
    final rows = await client.from('questions').select().eq('set_id', setId).order('position', ascending: true);
    return [for (final r in rows) Question.fromJson(r)];
  }

  Future<void> saveQuestion(Question q) =>
      client.from('questions').upsert({...q.toJson(), 'updated_at': DateTime.now().toUtc().toIso8601String()});

  Future<void> deleteQuestion(String id) => client.from('questions').delete().eq('id', id);
}

/// What one group import did.
class ImportResult {
  const ImportResult({required this.added, required this.skipped, required this.terms, this.pictures = 0});
  final int added;
  final int skipped;
  final int terms;

  /// Pictures added to chapters that were already there.
  final int pictures;
}

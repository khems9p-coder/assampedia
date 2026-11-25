import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/i18n/app_lang.dart';
import 'course_models.dart';
import 'jobs_models.dart';
import 'models.dart';
import 'practice_models.dart';
import 'study_models.dart';

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
          .insert({
            'slug': slug,
            // GK groups leave 'kind' out; exam syllabus groups set it to 'exam'.
            'kind': group['kind'] ?? 'gk_chapter',
            'category_id': categoryId,
            'position': ch['position'],
            // Exam pages carry their official links and the year they apply to.
            'official_url': ?ch['official_url'],
            'notification_url': ?ch['notification_url'],
            'applies_to': ?ch['applies_to'],
          })
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

  /// Adds a ready-made mock test (from the app's GitHub files) as a hidden
  /// draft. Returns false if a test with the same slug is already there.
  Future<bool> importMockTest(Map<String, dynamic> test) async {
    final slug = test['slug'] as String;
    final existing = await client.from('question_sets').select('id').eq('slug', slug).maybeSingle();
    if (existing != null) return false;
    final last = await client.from('question_sets').select('position').order('position', ascending: false).limit(1);
    final set = QuestionSet.fromJson({...test['set'] as Map<String, dynamic>, 'slug': slug});
    final row = await client
        .from('question_sets')
        .insert({
          ...set.toRow(),
          'position': last.isEmpty ? 1 : (last.first['position'] as int) + 1,
          // Hidden until the admin has checked every question.
          'is_published': false,
        })
        .select('id')
        .single();
    final setId = row['id'] as String;
    try {
      await client.from('questions').insert([
        for (final (i, q) in (test['questions'] as List).indexed)
          {...Question.fromJson({...q as Map<String, dynamic>, 'set_id': setId}).toJson(), 'position': i + 1},
      ]);
    } catch (_) {
      // Don't leave a half-made test behind; the next import will retry it.
      await client.from('question_sets').delete().eq('id', setId);
      rethrow;
    }
    return true;
  }
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

/// Pictures for chapters and current affairs, kept in the public 'media'
/// storage bucket (only admins can upload).
extension AdminImages on AdminRepository {
  /// Uploads a picture and returns its public web address.
  Future<String> uploadImage(Uint8List bytes, String fileName) async {
    final safe = fileName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9.]+'), '-');
    final ext = safe.contains('.') ? safe.split('.').last : 'jpg';
    final type = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      _ => 'image/jpeg',
    };
    final path = 'images/${DateTime.now().millisecondsSinceEpoch}-$safe';
    await client.storage.from('media').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: type, upsert: false));
    return client.storage.from('media').getPublicUrl(path);
  }
}

/// Courses (study paths) and their lessons.
extension AdminCourses on AdminRepository {
  /// Every course, including drafts.
  Future<List<Course>> courses() async {
    final rows = await client
        .from('courses')
        .select('*, course_items(count)')
        .order('position', ascending: true)
        .order('id', ascending: true);
    return [for (final r in rows) Course.fromJson(r)];
  }

  Future<Course> saveCourse(Course c) async {
    final row = await client
        .from('courses')
        .upsert({...c.toRow(), 'updated_at': DateTime.now().toUtc().toIso8601String()})
        .select()
        .single();
    return Course.fromJson(row);
  }

  /// Deletes a course and its lessons (the pages and quizzes stay).
  Future<void> deleteCourse(String id) => client.from('courses').delete().eq('id', id);

  /// A course's lessons with page and quiz titles, drafts included.
  Future<List<CourseItem>> courseItems(String courseId) async {
    final rows = await client
        .from('course_items')
        .select('*, content(slug, content_versions(lang, title)), question_sets(title_en, title_as)')
        .eq('course_id', courseId)
        .order('position', ascending: true)
        .order('id', ascending: true);
    return [for (final r in rows) CourseItem.fromJson(r)];
  }

  /// Adds a page ([contentId]) or a quiz ([setId]) at the end of a course.
  Future<void> addCourseItem(String courseId, {String? contentId, String? setId, required int position}) =>
      client.from('course_items').insert({'course_id': courseId, 'position': position, 'content_id': contentId, 'set_id': setId});

  Future<void> deleteCourseItem(String id) => client.from('course_items').delete().eq('id', id);

  /// Saves a new order: lesson 1 gets position 10, lesson 2 gets 20, and so on.
  Future<void> reorderCourseItems(List<CourseItem> items) async {
    for (final (i, it) in items.indexed) {
      if (it.id == null || it.position == (i + 1) * 10) continue;
      await client.from('course_items').update({'position': (i + 1) * 10}).eq('id', it.id!);
    }
  }
}

/// Study Material: sections, sub-sections and their items and files.
extension AdminStudy on AdminRepository {
  /// Every section and sub-section, drafts included.
  Future<List<StudySection>> studySections() async {
    final rows = await client.from('study_sections').select().order('position', ascending: true).order('id', ascending: true);
    return [for (final r in rows) StudySection.fromJson(r)];
  }

  Future<StudySection> saveStudySection(StudySection s) async {
    final row = await client
        .from('study_sections')
        .upsert({...s.toJson(), 'updated_at': DateTime.now().toUtc().toIso8601String()})
        .select()
        .single();
    return StudySection.fromJson(row);
  }

  /// Deletes a section with everything inside it, and their files.
  Future<void> deleteStudySection(String id, List<StudySection> all) async {
    final ids = <String>{id};
    var grew = true;
    while (grew) {
      grew = false;
      for (final s in all) {
        if (s.parentId != null && ids.contains(s.parentId) && s.id != null && ids.add(s.id!)) grew = true;
      }
    }
    final files = await client.from('study_items').select('file_path').inFilter('section_id', ids.toList());
    final paths = [for (final f in files) if (f['file_path'] != null) f['file_path'] as String];
    await client.from('study_sections').delete().eq('id', id);
    if (paths.isNotEmpty) await client.storage.from('study').remove(paths);
  }

  /// The top section of a course's own content; made the first time it is needed.
  Future<StudySection> courseSection(Course course) async {
    final row = await client.from('study_sections').select().eq('course_id', course.id!).isFilter('parent_id', null).maybeSingle();
    if (row != null) return StudySection.fromJson(row);
    return saveStudySection(
      StudySection(
        courseId: course.id,
        tier: StudyTier.premium,
        titleEn: course.titleEn,
        titleAs: course.titleAs,
        icon: course.icon,
        isPublished: true,
      ),
    );
  }

  /// A section's items, drafts included.
  Future<List<StudyItem>> studyItems(String sectionId) async {
    final rows = await client
        .from('study_items')
        .select('*, content(content_versions(lang, title)), question_sets(title_en, title_as)')
        .eq('section_id', sectionId)
        .order('position', ascending: true)
        .order('id', ascending: true);
    return [
      for (final r in rows)
        () {
          final item = StudyItem.fromRow(r);
          if (item.titleEn != null || item.titleAs != null) return item;
          // Pages and quizzes without their own name show the page or quiz title.
          String? en, as;
          final c = r['content'] as Map<String, dynamic>?;
          for (final v in (c?['content_versions'] as List? ?? const [])) {
            if (v['lang'] == 'en') en = v['title'] as String?;
            if (v['lang'] == 'as') as = v['title'] as String?;
          }
          final q = r['question_sets'] as Map<String, dynamic>?;
          return StudyItem.fromRow({...r, 'title_en': en ?? q?['title_en'], 'title_as': as ?? q?['title_as']});
        }(),
    ];
  }

  Future<void> saveStudyItem(StudyItem item) =>
      client.from('study_items').upsert({...item.toRow(), 'updated_at': DateTime.now().toUtc().toIso8601String()});

  /// Pages and quizzes keep no name of their own unless the admin gives one.
  Future<void> renameStudyItem(String id, {String? titleEn, String? titleAs}) =>
      client.from('study_items').update({'title_en': titleEn, 'title_as': titleAs}).eq('id', id);

  Future<void> setStudyItemFlags(String id, {bool? free, bool? published}) => client
      .from('study_items')
      .update({'is_free': ?free, 'is_published': ?published, 'updated_at': DateTime.now().toUtc().toIso8601String()})
      .eq('id', id);

  Future<void> deleteStudyItem(StudyItem item) async {
    await client.from('study_items').delete().eq('id', item.id!);
    if (item.filePath != null) await client.storage.from('study').remove([item.filePath!]);
  }

  /// Saves a new order: item 1 gets position 10, item 2 gets 20, and so on.
  Future<void> reorderStudyItems(List<StudyItem> items) async {
    for (final (i, it) in items.indexed) {
      if (it.id == null || it.position == (i + 1) * 10) continue;
      await client.from('study_items').update({'position': (i + 1) * 10}).eq('id', it.id!);
    }
  }

  /// Uploads a PDF or picture to the private 'study' folder; returns its path.
  Future<String> uploadStudyFile(Uint8List bytes, String fileName) async {
    final safe = fileName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9.]+'), '-');
    final ext = safe.contains('.') ? safe.split('.').last : 'pdf';
    final type = switch (ext) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final path = '${ext == 'pdf' ? 'pdf' : 'images'}/${DateTime.now().millisecondsSinceEpoch}-$safe';
    await client.storage.from('study').uploadBinary(path, bytes, fileOptions: FileOptions(contentType: type, upsert: false));
    return path;
  }
}

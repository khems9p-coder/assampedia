import '../core/i18n/app_lang.dart';

class Category {
  Category({
    required this.id,
    required this.slug,
    required this.position,
    required this.nameAs,
    required this.nameEn,
    this.icon,
    this.isPublished = true,
  });

  final String id;
  final String slug;
  final int position;
  final String nameAs;
  final String nameEn;
  final String? icon;
  final bool isPublished;

  String name(AppLang l) => l == AppLang.assamese ? nameAs : nameEn;

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    id: j['id'] as String,
    slug: j['slug'] as String,
    position: (j['position'] as num?)?.toInt() ?? 0,
    nameAs: j['name_as'] as String,
    nameEn: j['name_en'] as String,
    icon: j['icon'] as String?,
    isPublished: j['is_published'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'position': position,
    'name_as': nameAs,
    'name_en': nameEn,
    'icon': icon,
    'is_published': isPublished,
  };
}

/// A chapter in a list: its titles in whichever languages are available.
class ChapterSummary {
  ChapterSummary({required this.id, required this.slug, required this.position, required this.titles, this.statuses = const {}});

  final String id;
  final String slug;
  final int position;
  final Map<AppLang, String> titles;

  /// Only filled for admins: 'draft' or 'published' per language.
  final Map<AppLang, String> statuses;

  /// Title in [l], or in the other language when [l] is missing.
  String title(AppLang l) => titles[l] ?? titles[l.other] ?? slug;

  factory ChapterSummary.fromJson(Map<String, dynamic> j) {
    final titles = <AppLang, String>{};
    final statuses = <AppLang, String>{};
    for (final v in (j['content_versions'] as List? ?? const [])) {
      final m = v as Map<String, dynamic>;
      final l = AppLang.fromCode(m['lang'] as String?);
      if (l == null) continue;
      titles[l] = m['title'] as String;
      if (m['status'] != null) statuses[l] = m['status'] as String;
    }
    return ChapterSummary(
      id: j['id'] as String,
      slug: j['slug'] as String,
      position: (j['position'] as num?)?.toInt() ?? 0,
      titles: titles,
      statuses: statuses,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'position': position,
    'content_versions': [
      for (final e in titles.entries) {'lang': e.key.code, 'title': e.value, 'status': statuses[e.key]},
    ],
  };
}

enum BlockType { heading, paragraph, factBox, list, image }

enum BlockStyle { normal, definition, verifiedFact, event, personality, examFact, geography, heritage }

BlockType blockTypeFrom(String? s) => switch (s) {
  'heading' => BlockType.heading,
  'fact_box' => BlockType.factBox,
  'list' => BlockType.list,
  'image' => BlockType.image,
  _ => BlockType.paragraph,
};

String blockTypeCode(BlockType t) => switch (t) {
  BlockType.heading => 'heading',
  BlockType.paragraph => 'paragraph',
  BlockType.factBox => 'fact_box',
  BlockType.list => 'list',
  BlockType.image => 'image',
};

BlockStyle blockStyleFrom(String? s) => switch (s) {
  'definition' => BlockStyle.definition,
  'verified_fact' => BlockStyle.verifiedFact,
  'event' => BlockStyle.event,
  'personality' => BlockStyle.personality,
  'exam_fact' => BlockStyle.examFact,
  'geography' => BlockStyle.geography,
  'heritage' => BlockStyle.heritage,
  _ => BlockStyle.normal,
};

String blockStyleCode(BlockStyle s) => switch (s) {
  BlockStyle.normal => 'normal',
  BlockStyle.definition => 'definition',
  BlockStyle.verifiedFact => 'verified_fact',
  BlockStyle.event => 'event',
  BlockStyle.personality => 'personality',
  BlockStyle.examFact => 'exam_fact',
  BlockStyle.geography => 'geography',
  BlockStyle.heritage => 'heritage',
};

/// One paragraph, heading or box. [key] is shared by both languages.
class Block {
  Block({
    required this.key,
    required this.position,
    this.type = BlockType.paragraph,
    this.style = BlockStyle.normal,
    required this.body,
    this.imageUrl,
  });

  final String key;
  final int position;
  final BlockType type;
  final BlockStyle style;
  final String body;
  final String? imageUrl;

  factory Block.fromJson(Map<String, dynamic> j) => Block(
    key: j['block_key'] as String,
    position: (j['position'] as num).toInt(),
    type: blockTypeFrom(j['block_type'] as String?),
    style: blockStyleFrom(j['style'] as String?),
    body: j['body'] as String? ?? '',
    imageUrl: j['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'block_key': key,
    'position': position,
    'block_type': blockTypeCode(type),
    'style': blockStyleCode(style),
    'body': body,
    'image_url': imageUrl,
  };
}

class ChapterVersion {
  ChapterVersion({required this.title, this.summary, this.sources, this.lastChecked, this.status = 'published', required this.blocks});

  final String title;
  final String? summary;
  final String? sources;
  final String? lastChecked;
  final String status;
  final List<Block> blocks;

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'sources': sources,
    'last_checked': lastChecked,
    'status': status,
    'blocks': [for (final b in blocks) b.toJson()],
  };

  factory ChapterVersion.fromJson(Map<String, dynamic> j) => ChapterVersion(
    title: j['title'] as String,
    summary: j['summary'] as String?,
    sources: j['sources'] as String?,
    lastChecked: j['last_checked'] as String?,
    status: j['status'] as String? ?? 'published',
    blocks: [for (final b in (j['blocks'] as List? ?? const [])) Block.fromJson(b as Map<String, dynamic>)],
  );
}

/// A whole chapter with every language version the reader may see.
class Chapter {
  Chapter({required this.id, required this.slug, this.categoryId, required this.versions});

  final String id;
  final String slug;
  final String? categoryId;
  final Map<AppLang, ChapterVersion> versions;

  bool has(AppLang l) => versions.containsKey(l);

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'category_id': categoryId,
    'versions': {for (final e in versions.entries) e.key.code: e.value.toJson()},
  };

  factory Chapter.fromJson(Map<String, dynamic> j) {
    final versions = <AppLang, ChapterVersion>{};
    (j['versions'] as Map<String, dynamic>? ?? const {}).forEach((code, v) {
      final l = AppLang.fromCode(code);
      if (l != null) versions[l] = ChapterVersion.fromJson(v as Map<String, dynamic>);
    });
    return Chapter(id: j['id'] as String, slug: j['slug'] as String, categoryId: j['category_id'] as String?, versions: versions);
  }
}

/// When switching language, find the block in [to] that matches the block
/// the reader was looking at in [from]: same key first, otherwise the block
/// at the same relative place in the chapter.
int matchingBlockIndex(List<Block> from, int fromIndex, List<Block> to) {
  if (to.isEmpty) return 0;
  if (fromIndex < 0 || fromIndex >= from.length) return 0;
  final key = from[fromIndex].key;
  final same = to.indexWhere((b) => b.key == key);
  if (same >= 0) return same;
  final ratio = from.length <= 1 ? 0.0 : fromIndex / (from.length - 1);
  return (ratio * (to.length - 1)).round().clamp(0, to.length - 1);
}

/// A dictionary word that readers can tap inside a chapter.
class Term {
  Term({this.id, required this.slug, this.termAs, this.termEn, this.meaningAs, this.meaningEn, this.isPublished = true});

  final String? id;
  final String slug;
  final String? termAs;
  final String? termEn;
  final String? meaningAs;
  final String? meaningEn;
  final bool isPublished;

  String? _pick(AppLang l, String? as, String? en) {
    final v = l == AppLang.assamese ? as : en;
    return (v == null || v.trim().isEmpty) ? null : v;
  }

  /// The word in [l] if written, else whatever exists.
  String name(AppLang l) => _pick(l, termAs, termEn) ?? _pick(l.other, termAs, termEn) ?? slug;
  String? nameIn(AppLang l) => _pick(l, termAs, termEn);
  String? meaningIn(AppLang l) => _pick(l, meaningAs, meaningEn);

  factory Term.fromJson(Map<String, dynamic> j) => Term(
    id: j['id'] as String?,
    slug: j['slug'] as String,
    termAs: j['term_as'] as String?,
    termEn: j['term_en'] as String?,
    meaningAs: j['meaning_as'] as String?,
    meaningEn: j['meaning_en'] as String?,
    isPublished: j['is_published'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': ?id,
    'slug': slug,
    'term_as': termAs,
    'term_en': termEn,
    'meaning_as': meaningAs,
    'meaning_en': meaningEn,
    'is_published': isPublished,
  };
}

/// A piece of paragraph text: plain words, or a tappable dictionary term.
class InlinePart {
  const InlinePart.text(this.text) : termSlug = null;
  const InlinePart.term(this.termSlug, this.text);

  final String? termSlug;

  /// For a term: the words written in the paragraph, or null to show the
  /// dictionary word itself.
  final String? text;

  bool get isTerm => termSlug != null;
}

final _termPattern = RegExp(r'\{\{term:([a-z0-9-]+)(?:\|([^}]*))?\}\}');

/// Splits text written like `the {{term:ahom-kingdom|Ahom kings}} ruled`
/// into plain text and terms.
List<InlinePart> parseInline(String body) {
  final parts = <InlinePart>[];
  var at = 0;
  for (final m in _termPattern.allMatches(body)) {
    if (m.start > at) parts.add(InlinePart.text(body.substring(at, m.start)));
    final label = m.group(2)?.trim();
    parts.add(InlinePart.term(m.group(1), (label == null || label.isEmpty) ? null : label));
    at = m.end;
  }
  if (at < body.length) parts.add(InlinePart.text(body.substring(at)));
  return parts;
}

/// The text a reader sees, with term markers replaced by words.
String plainText(String body, [Map<String, Term> terms = const {}, AppLang lang = AppLang.english]) =>
    parseInline(body).map((p) => p.isTerm ? (p.text ?? terms[p.termSlug]?.name(lang) ?? p.termSlug!.replaceAll('-', ' ')) : p.text!).join();

/// One place in a chapter that matches a search.
class SearchHit {
  SearchHit({required this.contentId, required this.titles, this.blockKey, required this.lang, required this.snippet});

  final String contentId;
  final Map<AppLang, String> titles;
  final String? blockKey;
  final AppLang lang;
  final String snippet;

  String title(AppLang l) => titles[l] ?? titles[l.other] ?? '';
}

class SearchResults {
  SearchResults({this.chapters = const [], this.terms = const [], this.offline = false});
  final List<SearchHit> chapters;
  final List<Term> terms;

  /// True when only chapters saved on the phone were searched.
  final bool offline;
}

/// Cleans what the person typed so it is safe inside a database "contains" filter.
String cleanQuery(String q) => q.replaceAll(RegExp(r'[%_\\,()*"]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

/// A short piece of [text] around the first place [q] appears.
String snippetAround(String text, String q, {int radius = 60}) {
  final i = text.toLowerCase().indexOf(q.toLowerCase());
  if (i < 0) return text.length <= radius * 2 ? text : '${text.substring(0, radius * 2)}…';
  final start = (i - radius).clamp(0, text.length);
  final end = (i + q.length + radius).clamp(0, text.length);
  return '${start > 0 ? '…' : ''}${text.substring(start, end)}${end < text.length ? '…' : ''}';
}

bool termMatches(Term t, String q) {
  final n = q.toLowerCase();
  return [t.termAs, t.termEn, t.meaningAs, t.meaningEn, t.slug].any((v) => v != null && v.toLowerCase().contains(n));
}

/// Searches chapters already on the phone (used offline and in the demo).
SearchResults searchLocally(List<Chapter> chapters, List<Term> terms, String query, {bool offline = false}) {
  final q = cleanQuery(query);
  if (q.isEmpty) return SearchResults(offline: offline);
  final n = q.toLowerCase();
  final termMap = {for (final t in terms) t.slug: t};
  final hits = <SearchHit>[];
  for (final ch in chapters) {
    final titles = {for (final e in ch.versions.entries) e.key: e.value.title};
    for (final e in ch.versions.entries) {
      if (e.value.title.toLowerCase().contains(n)) {
        hits.add(SearchHit(contentId: ch.id, titles: titles, lang: e.key, snippet: e.value.summary ?? e.value.title));
      }
      for (final b in e.value.blocks) {
        final text = plainText(b.body, termMap, e.key);
        if (text.toLowerCase().contains(n)) {
          hits.add(SearchHit(contentId: ch.id, titles: titles, blockKey: b.key, lang: e.key, snippet: snippetAround(text, q)));
        }
      }
    }
  }
  return SearchResults(
    chapters: hits,
    terms: [
      for (final t in terms)
        if (termMatches(t, q)) t,
    ],
    offline: offline,
  );
}

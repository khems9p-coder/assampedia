import '../core/i18n/app_lang.dart';

String? _pick(String? as, String? en, AppLang l) {
  String? clean(String? v) => (v == null || v.trim().isEmpty) ? null : v;
  final mine = l == AppLang.assamese ? clean(as) : clean(en);
  return mine ?? (l == AppLang.assamese ? clean(en) : clean(as));
}

/// Free sections show under Study > Free, premium ones under Study > Premium.
enum StudyTier { free, premium }

/// A section or sub-section of study material. Sub-sections point to their
/// parent; top-level sections have no parent.
class StudySection {
  StudySection({
    this.id,
    this.parentId,
    this.tier = StudyTier.free,
    this.slug,
    this.titleAs,
    this.titleEn,
    this.descriptionAs,
    this.descriptionEn,
    this.icon,
    this.position = 0,
    this.isPublished = false,
    this.courseId,
  });

  final String? id;
  final String? parentId;

  /// Set on the top section of a course's own content (shown inside the course).
  final String? courseId;
  final StudyTier tier;
  final String? slug;
  final String? titleAs;
  final String? titleEn;
  final String? descriptionAs;
  final String? descriptionEn;
  final String? icon;
  final int position;
  final bool isPublished;

  bool get isPremium => tier == StudyTier.premium;
  String title(AppLang l) => _pick(titleAs, titleEn, l) ?? '';
  String? description(AppLang l) => _pick(descriptionAs, descriptionEn, l);

  factory StudySection.fromJson(Map<String, dynamic> j) => StudySection(
    id: j['id'] as String?,
    parentId: j['parent_id'] as String?,
    tier: j['tier'] == 'premium' ? StudyTier.premium : StudyTier.free,
    slug: j['slug'] as String?,
    titleAs: j['title_as'] as String?,
    titleEn: j['title_en'] as String?,
    descriptionAs: j['description_as'] as String?,
    descriptionEn: j['description_en'] as String?,
    icon: j['icon'] as String?,
    position: (j['position'] as num?)?.toInt() ?? 0,
    isPublished: j['is_published'] as bool? ?? false,
    courseId: j['course_id'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': ?id,
    'parent_id': parentId,
    // Only sent when set, so databases without 0013_course_content.sql keep working.
    'course_id': ?courseId,
    'tier': tier.name,
    'slug': slug,
    'title_as': titleAs,
    'title_en': titleEn,
    'description_as': descriptionAs,
    'description_en': descriptionEn,
    'icon': icon,
    'position': position,
    'is_published': isPublished,
  };

  StudySection copyWith({String? id, String? parentId, StudyTier? tier, int? position, bool? isPublished}) => StudySection(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    tier: tier ?? this.tier,
    slug: slug,
    titleAs: titleAs,
    titleEn: titleEn,
    descriptionAs: descriptionAs,
    descriptionEn: descriptionEn,
    icon: icon,
    position: position ?? this.position,
    isPublished: isPublished ?? this.isPublished,
    courseId: courseId,
  );
}

/// The top section of a course's own content, if it has one.
StudySection? courseRootSection(List<StudySection> all, String courseId) =>
    all.where((s) => s.courseId == courseId && s.parentId == null).firstOrNull;

/// The sections directly inside [parentId] (null = top level, without course
/// content, which shows inside its course), in order.
List<StudySection> childSections(List<StudySection> all, String? parentId) =>
    [for (final s in all) if (s.parentId == parentId && (parentId != null || s.courseId == null)) s]..sort((a, b) {
      final p = a.position.compareTo(b.position);
      return p != 0 ? p : (a.id ?? '').compareTo(b.id ?? '');
    });

enum StudyItemType { pdf, image, video, page, quiz }

StudyItemType studyItemTypeFrom(String? s) =>
    StudyItemType.values.firstWhere((t) => t.name == s, orElse: () => StudyItemType.pdf);

/// One thing inside a section: a PDF, a picture, a video link, a note page or a quiz.
class StudyItem {
  StudyItem({
    this.id,
    required this.sectionId,
    this.position = 0,
    required this.type,
    this.titleAs,
    this.titleEn,
    this.descriptionAs,
    this.descriptionEn,
    this.filePath,
    this.fileSize,
    this.videoUrl,
    this.contentId,
    this.setId,
    this.isFree = false,
    this.markedFree = false,
    this.isPublished = true,
  });

  final String? id;
  final String sectionId;
  final int position;
  final StudyItemType type;
  final String? titleAs;
  final String? titleEn;
  final String? descriptionAs;
  final String? descriptionEn;
  final String? filePath;
  final int? fileSize;

  /// Empty for a locked video (the database only sends it to those who may watch).
  final String? videoUrl;
  final String? contentId;
  final String? setId;

  /// Whether it opens without Premium (worked out by the database).
  final bool isFree;

  /// The admin's own "Free" switch.
  final bool markedFree;
  final bool isPublished;

  String title(AppLang l) => _pick(titleAs, titleEn, l) ?? '';
  String? description(AppLang l) => _pick(descriptionAs, descriptionEn, l);

  /// For readers: a row from the study_section_items() function.
  factory StudyItem.fromJson(Map<String, dynamic> j, {String? sectionId}) => StudyItem(
    id: j['id'] as String?,
    sectionId: (j['section_id'] as String?) ?? sectionId ?? '',
    position: ((j['item_position'] ?? j['position']) as num?)?.toInt() ?? 0,
    type: studyItemTypeFrom(j['item_type'] as String?),
    titleAs: j['title_as'] as String?,
    titleEn: j['title_en'] as String?,
    descriptionAs: j['description_as'] as String?,
    descriptionEn: j['description_en'] as String?,
    filePath: j['file_path'] as String?,
    fileSize: (j['file_size'] as num?)?.toInt(),
    videoUrl: j['video_url'] as String?,
    contentId: j['content_id'] as String?,
    setId: j['set_id'] as String?,
    isFree: j['is_free'] as bool? ?? false,
    markedFree: j['marked_free'] as bool? ?? false,
    isPublished: j['is_published'] as bool? ?? true,
  );

  /// Saved offline (reader view).
  Map<String, dynamic> toJson() => {
    'id': id,
    'section_id': sectionId,
    'item_position': position,
    'item_type': type.name,
    'title_as': titleAs,
    'title_en': titleEn,
    'description_as': descriptionAs,
    'description_en': descriptionEn,
    'file_path': filePath,
    'file_size': fileSize,
    'video_url': videoUrl,
    'content_id': contentId,
    'set_id': setId,
    'is_free': isFree,
  };

  /// Columns written by the admin screens.
  Map<String, dynamic> toRow() => {
    'id': ?id,
    'section_id': sectionId,
    'position': position,
    'item_type': type.name,
    'title_as': titleAs,
    'title_en': titleEn,
    'description_as': descriptionAs,
    'description_en': descriptionEn,
    'file_path': filePath,
    'file_size': fileSize,
    'video_url': videoUrl,
    'content_id': contentId,
    'set_id': setId,
    'is_free': markedFree,
    'is_published': isPublished,
  };

  /// For the admin: a plain row of the study_items table.
  factory StudyItem.fromRow(Map<String, dynamic> j) {
    final item = StudyItem.fromJson(j);
    return StudyItem(
      id: item.id,
      sectionId: item.sectionId,
      position: item.position,
      type: item.type,
      titleAs: item.titleAs,
      titleEn: item.titleEn,
      descriptionAs: item.descriptionAs,
      descriptionEn: item.descriptionEn,
      filePath: item.filePath,
      fileSize: item.fileSize,
      videoUrl: item.videoUrl,
      contentId: item.contentId,
      setId: item.setId,
      markedFree: j['is_free'] as bool? ?? false,
      isPublished: j['is_published'] as bool? ?? true,
    );
  }
}

/// "2.4 MB", "820 KB".
String fileSizeLabel(int bytes) =>
    bytes >= 1024 * 1024 ? '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB' : '${(bytes / 1024).ceil()} KB';

/// A YouTube link's video id, or null for other links.
String? youTubeId(String url) {
  final u = Uri.tryParse(url.trim());
  if (u == null) return null;
  final host = u.host.replaceFirst('www.', '').replaceFirst('m.', '');
  if (host == 'youtu.be') return u.pathSegments.isEmpty ? null : u.pathSegments.first;
  if (host == 'youtube.com' || host == 'music.youtube.com') {
    if (u.queryParameters['v'] != null) return u.queryParameters['v'];
    final seg = u.pathSegments;
    if (seg.length >= 2 && (seg.first == 'shorts' || seg.first == 'embed' || seg.first == 'live')) return seg[1];
  }
  return null;
}

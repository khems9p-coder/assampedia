import '../core/i18n/app_lang.dart';

/// Job categories from the master plan (Part 9.1).
enum JobCategory {
  assam('assam', 'অসম চৰকাৰৰ চাকৰি', 'Assam Government Jobs'),
  northeast('northeast', 'উত্তৰ-পূৰ্বাঞ্চলৰ চাকৰি', 'Northeast Government Jobs'),
  otherState('other_state', 'অন্যান্য ৰাজ্যৰ চাকৰি', 'Other State Government Jobs'),
  central('central', 'কেন্দ্ৰীয় চৰকাৰৰ চাকৰি', 'Central Government Jobs'),
  policeDefence('police_defence', 'আৰক্ষী আৰু প্ৰতিৰক্ষা', 'Police and Defence'),
  teaching('teaching', 'শিক্ষকতা', 'Teaching'),
  banking('banking', 'বেংকিং', 'Banking'),
  railways('railways', 'ৰেলৱে', 'Railways'),
  engineering('engineering', 'অভিযান্ত্ৰিক', 'Engineering'),
  medical('medical', 'চিকিৎসা আৰু স্বাস্থ্য', 'Medical and Health'),
  administrative('administrative', 'প্ৰশাসনিক সেৱা', 'Administrative Services'),
  other('other', 'অন্যান্য বিভাগীয় চাকৰি', 'Other departmental jobs');

  const JobCategory(this.code, this.nameAs, this.nameEn);
  final String code;
  final String nameAs;
  final String nameEn;

  String name(AppLang l) => l == AppLang.assamese ? nameAs : nameEn;

  static JobCategory from(String? code) => values.firstWhere((c) => c.code == code, orElse: () => JobCategory.other);
}

/// Recruitment status labels (Part 9.3).
enum VacancyStatus {
  newNotification('নতুন জাননী', 'New Notification'),
  open('আবেদন চলি আছে', 'Applications Open'),
  closingSoon('সোনকালে বন্ধ হ’ব', 'Closing Soon'),
  closed('আবেদন বন্ধ', 'Application Closed'),
  admitCard('প্ৰৱেশ পত্ৰ প্ৰকাশিত', 'Admit Card Released'),
  examScheduled('পৰীক্ষাৰ তাৰিখ নিৰ্ধাৰিত', 'Examination Scheduled'),
  result('ফলাফল ঘোষিত', 'Result Declared');

  const VacancyStatus(this.labelAs, this.labelEn);
  final String labelAs;
  final String labelEn;

  String label(AppLang l) => l == AppLang.assamese ? labelAs : labelEn;

  /// Only these may be shown as opportunities someone can still apply for.
  bool get canApply => this == newNotification || this == open || this == closingSoon;
}

/// Later recruitment stages the admin sets by hand.
const vacancyStages = ['notification', 'admit_card', 'exam_scheduled', 'result'];

/// How many days before the closing date a vacancy counts as "closing soon".
const closingSoonDays = 7;

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// Works out the status from the dates, so an expired vacancy can never
/// appear as open, even if nobody updates it.
VacancyStatus vacancyStatus({required String stage, DateTime? startDate, required DateTime closingDate, required DateTime today}) {
  switch (stage) {
    case 'admit_card':
      return VacancyStatus.admitCard;
    case 'exam_scheduled':
      return VacancyStatus.examScheduled;
    case 'result':
      return VacancyStatus.result;
  }
  final t = _day(today);
  final close = _day(closingDate);
  if (t.isAfter(close)) return VacancyStatus.closed;
  if (startDate != null && t.isBefore(_day(startDate))) return VacancyStatus.newNotification;
  if (close.difference(t).inDays <= closingSoonDays) return VacancyStatus.closingSoon;
  return VacancyStatus.open;
}

DateTime? _date(Object? v) => v == null ? null : DateTime.tryParse(v as String);
String? _iso(DateTime? d) => d?.toIso8601String().substring(0, 10);

/// One government recruitment notice. Text fields come in both languages.
class Vacancy {
  Vacancy({
    this.id,
    this.category = JobCategory.assam,
    this.text = const {},
    this.state,
    this.location,
    this.count,
    this.startDate,
    required this.closingDate,
    this.stage = 'notification',
    required this.notificationUrl,
    this.applyUrl,
    this.syllabusContentId,
    required this.lastVerified,
    this.isPublished = false,
  });

  /// The bilingual text fields, stored as `<field>_as` / `<field>_en` columns.
  static const textFields = ['post', 'organisation', 'department', 'qualification', 'age_limit', 'pay', 'fee', 'selection', 'notes'];

  final String? id;
  final JobCategory category;

  /// Text keyed by field and language code, for example `post_en` or `post_as`.
  final Map<String, String> text;
  final String? state;
  final String? location;
  final int? count;
  final DateTime? startDate;
  final DateTime closingDate;
  final String stage;
  final String notificationUrl;
  final String? applyUrl;
  final String? syllabusContentId;
  final DateTime lastVerified;
  final bool isPublished;

  /// A field in [l], falling back to the other language.
  String? get(String field, AppLang l) {
    String? pick(AppLang x) {
      final v = text['${field}_${x.code}'];
      return (v == null || v.trim().isEmpty) ? null : v;
    }

    return pick(l) ?? pick(l.other);
  }

  String post(AppLang l) => get('post', l) ?? '';

  VacancyStatus status([DateTime? today]) =>
      vacancyStatus(stage: stage, startDate: startDate, closingDate: closingDate, today: today ?? DateTime.now());

  int daysLeft([DateTime? today]) => _day(closingDate).difference(_day(today ?? DateTime.now())).inDays;

  factory Vacancy.fromJson(Map<String, dynamic> j) => Vacancy(
    id: j['id'] as String?,
    category: JobCategory.from(j['category'] as String?),
    text: {
      for (final f in textFields)
        for (final l in AppLang.values)
          if (j['${f}_${l.code}'] != null) '${f}_${l.code}': j['${f}_${l.code}'] as String,
    },
    state: j['state'] as String?,
    location: j['location'] as String?,
    count: (j['vacancies_count'] as num?)?.toInt(),
    startDate: _date(j['start_date']),
    closingDate: _date(j['closing_date'])!,
    stage: j['stage'] as String? ?? 'notification',
    notificationUrl: j['notification_url'] as String,
    applyUrl: j['apply_url'] as String?,
    syllabusContentId: j['syllabus_content_id'] as String?,
    lastVerified: _date(j['last_verified'])!,
    isPublished: j['is_published'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': ?id,
    'category': category.code,
    for (final f in textFields)
      for (final l in AppLang.values) '${f}_${l.code}': text['${f}_${l.code}'],
    'state': state,
    'location': location,
    'vacancies_count': count,
    'start_date': _iso(startDate),
    'closing_date': _iso(closingDate),
    'stage': stage,
    'notification_url': notificationUrl,
    'apply_url': applyUrl,
    'syllabus_content_id': syllabusContentId,
    'last_verified': _iso(lastVerified),
    'is_published': isPublished,
  };

  bool matches(String q) {
    final n = q.toLowerCase();
    return [...text.values, state, location, category.nameEn, category.nameAs].any((v) => v != null && v.toLowerCase().contains(n));
  }
}

/// A current-affairs item in a list.
class NewsItem {
  NewsItem({required this.id, required this.titles, this.date, this.categoryId});

  final String id;
  final Map<AppLang, String> titles;
  final DateTime? date;
  final String? categoryId;

  String title(AppLang l) => titles[l] ?? titles[l.other] ?? '';

  factory NewsItem.fromJson(Map<String, dynamic> j) {
    final titles = <AppLang, String>{};
    for (final v in (j['content_versions'] as List? ?? const [])) {
      final l = AppLang.fromCode((v as Map<String, dynamic>)['lang'] as String?);
      if (l != null) titles[l] = v['title'] as String;
    }
    return NewsItem(id: j['id'] as String, titles: titles, date: _date(j['event_date']), categoryId: j['category_id'] as String?);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_date': _iso(date),
    'category_id': categoryId,
    'content_versions': [for (final e in titles.entries) {'lang': e.key.code, 'title': e.value}],
  };
}

/// Daily / weekly / monthly / all views of current affairs.
enum NewsPeriod { today, week, month, all }

bool inPeriod(DateTime? date, NewsPeriod p, DateTime today) {
  if (p == NewsPeriod.all) return true;
  if (date == null) return false;
  final d = _day(date);
  final t = _day(today);
  return switch (p) {
    NewsPeriod.today => d == t,
    NewsPeriod.week => !d.isAfter(t) && t.difference(d).inDays < 7,
    NewsPeriod.month => d.year == t.year && d.month == t.month,
    NewsPeriod.all => true,
  };
}

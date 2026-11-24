import '../core/i18n/app_lang.dart';

/// Highest education, as stored in profiles.education.
enum Education {
  class10('class10', 'দশম শ্ৰেণী', 'Class 10'),
  class12('class12', 'দ্বাদশ শ্ৰেণী', 'Class 12'),
  graduate('graduate', 'স্নাতক', 'Graduate'),
  postgraduate('postgraduate', 'স্নাতকোত্তৰ', 'Post-graduate'),
  other('other', 'অন্য', 'Other');

  const Education(this.code, this.as, this.en);
  final String code;
  final String as;
  final String en;
  String name(AppLang l) => l == AppLang.assamese ? as : en;

  static Education? fromCode(String? c) {
    for (final e in values) {
      if (e.code == c) return e;
    }
    return null;
  }
}

/// Exams a student can say they are preparing for (profiles.exams).
enum ExamTarget {
  apsc('apsc', 'APSC (CCE)', 'APSC (CCE)'),
  adre('adre', 'ADRE / গ্ৰেড III আৰু IV', 'ADRE / Grade III & IV'),
  police('police', 'অসম আৰক্ষী', 'Assam Police'),
  tet('tet', 'TET (শিক্ষক)', 'TET (teachers)'),
  ssc('ssc', 'SSC', 'SSC'),
  bank('bank', 'বেংক', 'Banking'),
  railway('railway', 'ৰেলৱে', 'Railways'),
  upsc('upsc', 'UPSC', 'UPSC'),
  board('board', 'HSLC / HS বৰ্ড পৰীক্ষা', 'HSLC / HS board exams'),
  other('other', 'অন্য', 'Other');

  const ExamTarget(this.code, this.as, this.en);
  final String code;
  final String as;
  final String en;
  String name(AppLang l) => l == AppLang.assamese ? as : en;

  static ExamTarget? fromCode(String? c) {
    for (final e in values) {
      if (e.code == c) return e;
    }
    return null;
  }
}

/// What a student tells us about themselves.
class StudentProfile {
  const StudentProfile({this.fullName, this.education, this.exams = const {}, this.district});

  final String? fullName;
  final Education? education;
  final Set<ExamTarget> exams;
  final String? district;

  /// The profile is set up once a name has been saved.
  bool get isComplete => (fullName ?? '').trim().isNotEmpty;

  factory StudentProfile.fromRow(Map<String, dynamic> r) => StudentProfile(
    fullName: r['full_name'] as String?,
    education: Education.fromCode(r['education'] as String?),
    exams: {for (final c in (r['exams'] as List? ?? const [])) ?ExamTarget.fromCode(c as String?)},
    district: r['district'] as String?,
  );

  Map<String, dynamic> toRow() => {
    'full_name': fullName?.trim(),
    'education': education?.code,
    'exams': [for (final e in exams) e.code],
    'district': (district ?? '').trim().isEmpty ? null : district!.trim(),
    'updated_at': DateTime.now().toUtc().toIso8601String(),
  };
}

/// Security questions a student can choose (security_answers.question).
enum SecurityQuestion {
  school('school', 'আপোনাৰ প্ৰথম বিদ্যালয়ৰ নাম কি?', 'What was the name of your first school?'),
  teacher('teacher', 'আপোনাৰ প্ৰিয় শিক্ষকৰ নাম কি?', "What is your favourite teacher's name?"),
  friend('friend', 'আপোনাৰ শৈশৱৰ প্ৰিয় বন্ধুৰ নাম কি?', "What is your childhood best friend's name?"),
  birthplace('birthplace', 'আপোনাৰ মাতৃৰ জন্মস্থান (গাঁও বা চহৰ) কি?', 'In which village or town was your mother born?'),
  food('food', 'আপোনাৰ প্ৰিয় খাদ্য কি?', 'What is your favourite food?');

  const SecurityQuestion(this.code, this.as, this.en);
  final String code;
  final String as;
  final String en;
  String text(AppLang l) => l == AppLang.assamese ? as : en;

  static SecurityQuestion? fromCode(String? c) {
    for (final q in values) {
      if (q.code == c) return q;
    }
    return null;
  }
}

import '../core/i18n/app_lang.dart';
import 'content_repository.dart';
import 'course_models.dart';
import 'jobs_models.dart';
import 'models.dart';
import 'practice_models.dart';

/// Layout-testing content only. Every text says it is sample text, so it can
/// never be mistaken for real Assam GK.
class DemoContentRepository implements ContentRepository {
  final _cats = [
    Category(id: 'c1', slug: 'history', position: 1, icon: 'history', nameEn: 'History of Assam', nameAs: 'অসমৰ ইতিহাস'),
    Category(id: 'c2', slug: 'geography', position: 2, icon: 'terrain', nameEn: 'Geography of Assam', nameAs: 'অসমৰ ভূগোল'),
    Category(
      id: 'c3',
      slug: 'culture',
      position: 3,
      icon: 'theater',
      nameEn: 'Art, Culture and Heritage',
      nameAs: 'কলা, সংস্কৃতি আৰু ঐতিহ্য',
    ),
    Category(id: 'c4', slug: 'wildlife', position: 4, icon: 'pets', nameEn: 'Wildlife and Environment', nameAs: 'বন্যপ্ৰাণী আৰু পৰিৱেশ'),
    Category(
      id: 'e1',
      slug: 'exams-sample',
      position: 1,
      icon: 'flag',
      section: 'exam',
      nameEn: 'Sample exam group',
      nameAs: 'নমুনা পৰীক্ষাৰ গোট',
    ),
    Category(
      id: 'n1',
      slug: 'ca-sample',
      position: 1,
      icon: 'flag',
      section: 'ca',
      nameEn: 'Sample news group',
      nameAs: 'নমুনা বাতৰিৰ গোট',
    ),
    Category(
      id: 'j1',
      slug: 'careers-sample',
      position: 1,
      icon: 'gavel',
      section: 'job',
      nameEn: 'Sample career group',
      nameAs: 'নমুনা কেৰিয়াৰৰ গোট',
    ),
  ];

  @override
  Future<List<Category>> categories({String section = 'gk'}) async => [
    for (final c in _cats)
      if (c.section == section) c,
  ];

  @override
  Future<List<ChapterSummary>> chapters(String categoryId) async => [
    ChapterSummary(
      id: 'demo',
      slug: 'sample',
      position: 1,
      titles: {AppLang.english: 'Sample chapter (layout test)', AppLang.assamese: 'নমুনা অধ্যায় (পৰীক্ষা)'},
    ),
  ];

  @override
  Future<Chapter> chapter(String contentId) async {
    List<Block> blocks(String label, String para) => [
      Block(key: 'h1', position: 1, type: BlockType.heading, body: '$label 1'),
      for (var i = 1; i <= 8; i++) Block(key: 'p$i', position: i + 1, body: '$para ($i)'),
      Block(key: 'f1', position: 20, type: BlockType.factBox, style: BlockStyle.examFact, body: '$label: exam fact box'),
      Block(key: 'f2', position: 21, type: BlockType.factBox, style: BlockStyle.definition, body: '$label: definition box'),
      Block(key: 's1', position: 22, type: BlockType.factBox, style: BlockStyle.suggested, body: '$label: suggested tip box'),
    ];
    return Chapter(
      id: 'demo',
      slug: 'sample',
      appliesTo: 'Sample version (layout test)',
      officialUrl: 'https://example.org/',
      versions: {
        AppLang.english: ChapterVersion(
          title: 'Sample chapter (layout test)',
          blocks: blocks(
            'Sample heading',
            'This is sample text with a {{term:sample-term}} used only to test the reading screen. It is not real information.',
          ),
        ),
        AppLang.assamese: ChapterVersion(
          title: 'নমুনা অধ্যায় (পৰীক্ষা)',
          blocks: blocks(
            'নমুনা শিৰোনাম',
            'এইটো {{term:sample-term}} থকা কেৱল পঢ়া পৃষ্ঠাটো পৰীক্ষা কৰিবলৈ নমুনা লিখনি। ই প্ৰকৃত তথ্য নহয়।',
          ),
        ),
      },
    );
  }

  final _terms = [
    Term(
      slug: 'sample-term',
      termEn: 'Sample term',
      termAs: 'নমুনা শব্দ',
      meaningEn: 'A sample dictionary entry used only to test tapping on words. Not real information.',
      meaningAs: 'শব্দত টিপা পৰীক্ষা কৰিবলৈ এটা নমুনা। ই প্ৰকৃত তথ্য নহয়।',
    ),
  ];

  @override
  Future<List<Term>> terms() async => _terms;

  @override
  Future<SearchResults> search(String query) async => searchLocally([await chapter('demo')], _terms, query);

  @override
  Future<List<Vacancy>> vacancies() async {
    final now = DateTime.now();
    Vacancy sample(String id, int closesInDays, {String stage = 'notification'}) => Vacancy(
      id: id,
      category: JobCategory.assam,
      text: {
        'post_en': 'Sample vacancy $id (layout test)',
        'post_as': 'নমুনা খালী পদ $id (পৰীক্ষা)',
        'organisation_en': 'Sample organisation (not real)',
        'organisation_as': 'নমুনা প্ৰতিষ্ঠান (প্ৰকৃত নহয়)',
        'qualification_en': 'Sample qualification text',
        'qualification_as': 'নমুনা অৰ্হতা',
      },
      state: 'Assam',
      count: 10,
      startDate: now.subtract(const Duration(days: 5)),
      closingDate: now.add(Duration(days: closesInDays)),
      stage: stage,
      notificationUrl: 'https://example.org/',
      lastVerified: now,
      isPublished: true,
    );
    return [sample('A', 20), sample('B', 3), sample('C', -2)];
  }

  @override
  Future<List<NewsItem>> currentAffairs() async => [
    NewsItem(
      id: 'demo',
      categoryId: 'n1',
      date: DateTime.now(),
      titles: {AppLang.english: 'Sample chapter (layout test)', AppLang.assamese: 'নমুনা অধ্যায় (পৰীক্ষা)'},
    ),
  ];

  @override
  Future<List<QuestionSet>> questionSets() async => [
    QuestionSet(
      id: 'q1',
      kind: QuizKind.topic,
      text: {'title_en': 'Sample quiz (layout test)', 'title_as': 'নমুনা কুইজ (পৰীক্ষা)'},
      isPublished: true,
      questionCount: 2,
    ),
    QuestionSet(
      id: 'qm',
      kind: QuizKind.mock,
      level: QuizLevel.competitive,
      text: {'title_en': 'Sample mock test (layout test)', 'title_as': 'নমুনা আদৰ্শ পৰীক্ষা (পৰীক্ষা)'},
      timeLimitMinutes: 10,
      marksPerQuestion: 2,
      negativeMarks: 0.5,
      isPublished: true,
      questionCount: 3,
    ),
    QuestionSet(
      id: 'qd',
      kind: QuizKind.daily,
      text: {'title_en': 'Sample daily question', 'title_as': 'নমুনা দৈনিক প্ৰশ্ন'},
      isPublished: true,
      questionCount: 1,
    ),
  ];

  Question _sample(String set, int n, int correct) => Question(
    id: '$set-$n',
    setId: set,
    position: n,
    text: {
      'question_en': 'Sample question $n (layout test)',
      'question_as': 'নমুনা প্ৰশ্ন $n (পৰীক্ষা)',
      'explanation_en': 'Sample explanation (not real information).',
      'explanation_as': 'নমুনা ব্যাখ্যা (প্ৰকৃত তথ্য নহয়)।',
    },
    optionsEn: ['Option A', 'Option B', 'Option C', 'Option D'],
    optionsAs: ['বিকল্প ক', 'বিকল্প খ', 'বিকল্প গ', 'বিকল্প ঘ'],
    correctIndex: correct,
  );

  @override
  Future<List<Question>> questions(String setId) async => switch (setId) {
    'q1' => [_sample('q1', 1, 1), _sample('q1', 2, 3)],
    'qd' => [_sample('qd', 1, 0)],
    'qm' => [
      for (final (n, correct, topic) in [(1, 0, 'History'), (2, 1, 'History'), (3, 2, 'Geography')])
        Question(
          id: 'qm-$n',
          setId: 'qm',
          position: n,
          text: {..._sample('qm', n, correct).text, 'topic_en': topic},
          optionsEn: _sample('qm', n, correct).optionsEn,
          optionsAs: _sample('qm', n, correct).optionsAs,
          correctIndex: correct,
        ),
    ],
    _ => const [],
  };

  @override
  Future<List<Course>> courses() async => [
    Course(
      id: 'k1',
      slug: 'sample-course',
      titleEn: 'Sample course (layout test)',
      titleAs: 'নমুনা পাঠ্যক্ৰম (পৰীক্ষা)',
      descriptionEn: 'Sample text for testing the layout.',
      descriptionAs: 'বিন্যাস পৰীক্ষাৰ বাবে নমুনা লেখা।',
      icon: 'flag',
      isPublished: true,
      lessonCount: 4,
    ),
  ];

  @override
  Future<List<CourseLesson>> courseLessons(String courseId) async => [
    CourseLesson(id: 'l1', number: 1, contentId: 'demo', titleEn: 'Sample chapter (layout test)', titleAs: 'নমুনা অধ্যায় (পৰীক্ষা)', isFree: true),
    CourseLesson(id: 'l2', number: 2, setId: 'q1', kind: LessonKind.quiz, titleEn: 'Sample quiz (layout test)', titleAs: 'নমুনা কুইজ (পৰীক্ষা)', isFree: true),
    CourseLesson(id: 'l3', number: 3, contentId: 'demo', kind: LessonKind.exam, titleEn: 'Sample exam page', titleAs: 'নমুনা পৰীক্ষাৰ পৃষ্ঠা', isFree: true),
    CourseLesson(id: 'l4', number: 4, contentId: 'demo', titleEn: 'Sample locked chapter', titleAs: 'নমুনা বন্ধ অধ্যায়'),
  ];
}

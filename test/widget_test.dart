import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:assampedia/data/course_models.dart';
import 'package:assampedia/data/study_models.dart';
import 'package:assampedia/core/app_scope.dart';
import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/data/auth_service.dart';
import 'package:assampedia/data/bookmark_store.dart';
import 'package:assampedia/data/cached_content_repository.dart';
import 'package:assampedia/data/content_repository.dart';
import 'package:assampedia/data/demo_content_repository.dart';
import 'package:assampedia/data/jobs_models.dart';
import 'package:assampedia/data/models.dart';
import 'package:assampedia/data/offline_cache.dart';
import 'package:assampedia/data/practice_models.dart';
import 'package:assampedia/data/premium_service.dart';
import 'package:assampedia/data/student_profile.dart';
import 'package:assampedia/core/i18n/strings.dart';
import 'package:assampedia/features/account/auth_form.dart';
import 'package:assampedia/features/admin/section_templates.dart';
import 'package:assampedia/features/reader/reader_screen.dart';
import 'package:assampedia/main.dart';

Future<AppServices> _services({String? lang}) async {
  SharedPreferences.setMockInitialValues({'app_lang': ?lang});
  final theme = ThemeController();
  final language = LanguageController();
  await theme.load();
  await language.load();
  return AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: AuthService(null));
}

/// A server is set up but nobody has signed in yet.
class _SignedOutAuth extends AuthService {
  _SignedOutAuth() : super(null);
  @override
  bool get available => true;
}

/// Signed in for the first time, with an empty profile.
class _NewStudentAuth extends AuthService {
  _NewStudentAuth() : super(null);
  StudentProfile? saved;
  @override
  bool get available => true;
  @override
  bool get isSignedIn => true;
  @override
  bool get checking => false;
  @override
  StudentProfile? get profile => saved ?? const StudentProfile();
  @override
  bool get needsProfile => !(profile?.isComplete ?? false);
  @override
  Future<void> saveProfile(StudentProfile p) async {
    saved = p;
    notifyListeners();
  }

  SecurityQuestion? question;
  String? answer;
  @override
  SecurityQuestion? get securityQuestion => question;
  @override
  bool get needsSecurityQuestion => question == null;
  @override
  Future<void> setSecurityQuestion(SecurityQuestion q, String a) async {
    question = q;
    answer = a;
    notifyListeners();
  }
}

class _MemoryCache extends OfflineCache {
  final store = <String, Object>{};
  @override
  Future<void> write(String key, Object json) async => store[key] = json;
  @override
  Future<dynamic> read(String key) async => store[key];
  @override
  Future<List<dynamic>> readAll(String prefix) async => [
    for (final e in store.entries)
      if (e.key.startsWith(prefix)) e.value,
  ];
}

class _Switchable implements ContentRepository {
  _Switchable(this.inner);
  final ContentRepository inner;
  bool online = true;
  Future<T> _go<T>(Future<T> Function() f) => online ? f() : Future.error(Exception('offline'));
  @override
  Future<List<Category>> categories({String section = 'gk'}) => _go(() => inner.categories(section: section));
  @override
  Future<List<ChapterSummary>> chapters(String id) => _go(() => inner.chapters(id));
  @override
  Future<Chapter> chapter(String id) => _go(() => inner.chapter(id));
  @override
  Future<List<Term>> terms() => _go(inner.terms);
  @override
  Future<SearchResults> search(String q) => _go(() => inner.search(q));
  @override
  Future<List<Vacancy>> vacancies() => _go(inner.vacancies);
  @override
  Future<List<NewsItem>> currentAffairs() => _go(inner.currentAffairs);
  @override
  Future<List<QuestionSet>> questionSets() => _go(inner.questionSets);
  @override
  Future<List<Question>> questions(String id) => _go(() => inner.questions(id));
  @override
  Future<List<Course>> courses() => _go(inner.courses);
  @override
  Future<List<CourseLesson>> courseLessons(String id) => _go(() => inner.courseLessons(id));
  @override
  Future<List<StudySection>> studySections() => _go(inner.studySections);
  @override
  Future<List<StudyItem>> studyItems(String id) => _go(() => inner.studyItems(id));
  @override
  Future<String> studyFileUrl(String path) => _go(() => inner.studyFileUrl(path));
}

void main() {
  test('Chapters read once can be opened offline', () async {
    final remote = _Switchable(DemoContentRepository());
    final repo = CachedContentRepository(remote, _MemoryCache());
    final first = await repo.chapter('demo');
    expect(repo.lastWasOffline, isFalse);

    remote.online = false;
    final again = await repo.chapter('demo');
    expect(repo.lastWasOffline, isTrue);
    expect(again.versions[AppLang.assamese]!.title, first.versions[AppLang.assamese]!.title);
    expect(again.versions[AppLang.english]!.blocks.length, first.versions[AppLang.english]!.blocks.length);

    expect(() => repo.chapter('never-opened'), throwsException);
  });

  testWidgets('After installing, the app opens on the welcome and sign-in screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final theme = ThemeController();
    final language = LanguageController();
    await theme.load();
    await language.load();
    final services = AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: _SignedOutAuth());
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();

    expect(find.text('স্বাগতম'), findsOneWidget);
    expect(find.text('ASSAMPEDIA'), findsOneWidget);
    expect(find.text('ছাইন ইন কৰক'), findsWidgets);
    // The content stays behind sign-in.
    expect(find.text('Assam GK Encyclopedia'), findsNothing);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    // Signing in with empty boxes gets a clear message instead of a server error.
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();
    expect(find.text('Please enter your email and a password.'), findsOneWidget);

    // Create account: email, password, password again, with a strong-password rule.
    await tester.tap(find.widgetWithText(OutlinedButton, 'Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Re-enter password'), findsOneWidget);
    final create = find.widgetWithText(FilledButton, 'Create account');
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'reader@example.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'abcdefgh1');
    await tester.enterText(find.widgetWithText(TextField, 'Re-enter password'), 'abcdefgh1');
    await tester.tap(create);
    await tester.pump();
    // The rule shows as helper text too, so it appears twice when broken.
    expect(find.textContaining('At least 8 characters'), findsNWidgets(2));
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'abcdefg1!');
    await tester.enterText(find.widgetWithText(TextField, 'Re-enter password'), 'abcdefg1?');
    await tester.tap(create);
    await tester.pump();
    expect(find.text('The two passwords are not the same.'), findsOneWidget);
    // A security question is needed too.
    await tester.enterText(find.widgetWithText(TextField, 'Re-enter password'), 'abcdefg1!');
    await tester.tap(create);
    await tester.pump();
    expect(find.textContaining('Choose a security question and write an answer'), findsOneWidget);
  });

  test('Strong password rule', () {
    final s = S(AppLang.english);
    expect(checkNewPassword(s, 'Assam@2026', 'Assam@2026'), isNull);
    expect(checkNewPassword(s, 'assam2026', 'assam2026'), s.strongPasswordRule); // no special character
    expect(checkNewPassword(s, 'Assam@xyz', 'Assam@xyz'), s.strongPasswordRule); // no number
    expect(checkNewPassword(s, 'A@1b', 'A@1b'), s.strongPasswordRule); // too short
    expect(checkNewPassword(s, 'Assam@2026', 'Assam@2025'), s.passwordsDiffer);
  });

  testWidgets('After the first sign-in, the student sets up a profile', (tester) async {
    SharedPreferences.setMockInitialValues({'app_lang': 'en'});
    final theme = ThemeController();
    final language = LanguageController();
    await theme.load();
    await language.load();
    final auth = _NewStudentAuth();
    final services = AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: auth);
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();

    expect(find.text('Set up your profile'), findsOneWidget);
    await tester.tap(find.text('Save and continue'));
    await tester.pump();
    expect(find.text('Please enter your name.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Full name'), 'Test Student');
    await tester.tap(find.text('Graduate'));
    await tester.tap(find.text('APSC (CCE)'));
    await tester.tap(find.text('Assam Police'));
    await tester.pump();
    // Without a security question it can't be saved yet.
    await tester.tap(find.text('Save and continue'));
    await tester.pump();
    expect(find.textContaining('Choose a security question and write an answer'), findsOneWidget);
    await tester.tap(find.text('Choose a question'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('What was the name of your first school?').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Your answer'), 'Don Bosco');
    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(auth.question, SecurityQuestion.school);
    expect(auth.answer, 'Don Bosco');

    expect(auth.saved?.fullName, 'Test Student');
    expect(auth.saved?.education, Education.graduate);
    expect(auth.saved?.exams, {ExamTarget.apsc, ExamTarget.police});
    // Now the content opens.
    expect(find.text('Set up your profile'), findsNothing);
    expect(find.text('Assam GK Encyclopedia'), findsOneWidget);
  });

  testWidgets('First launch asks for a language and remembers it', (tester) async {
    final services = await _services();
    await tester.pumpWidget(AssampediaApp(services: services));
    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(services.language.lang, AppLang.english);
    expect(find.text('Assam GK Encyclopedia'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_lang'), 'en');
  });

  testWidgets('Home shows Assamese text when Assamese is chosen', (tester) async {
    final services = await _services(lang: 'as');
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    expect(find.text('অসমৰ সাধাৰণ জ্ঞান'), findsOneWidget);
    // The groups are on the Learn tab (Home no longer repeats them).
    expect(find.text('অসমৰ ইতিহাস'), findsNothing);
    await tester.tap(find.text('শিকক').last);
    await tester.pumpAndSettle();
    expect(find.text('অসমৰ ইতিহাস'), findsOneWidget);
  });

  testWidgets('Reader switches language instantly', (tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final services = await _services(lang: 'en');
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('History of Assam'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sample chapter (layout test)'));
    await tester.pumpAndSettle();
    expect(find.text('Sample chapter (layout test)'), findsOneWidget);

    await tester.tap(find.text('অসমীয়া').last);
    await tester.pumpAndSettle();
    expect(find.text('নমুনা অধ্যায় (পৰীক্ষা)'), findsOneWidget);
    expect(services.language.lang, AppLang.assamese);
  });

  test('Theme choice is remembered', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = ThemeController();
    await controller.setMode(ThemeMode.dark);
    final again = ThemeController();
    await again.load();
    expect(again.mode, ThemeMode.dark);
  });

  group('Keeping your place when switching language', () {
    List<Block> blocks(List<String> keys) => [for (var i = 0; i < keys.length; i++) Block(key: keys[i], position: i, body: keys[i])];

    test('same paragraph key is found in the other language', () {
      final en = blocks(['p1', 'p2', 'p3', 'p4']);
      final as = blocks(['p1', 'p3', 'p4']);
      expect(matchingBlockIndex(en, 2, as), 1);
    });

    test('missing key falls back to the same relative place', () {
      final en = blocks(['a', 'b', 'c', 'd', 'e']);
      final as = blocks(['x', 'y', 'z']);
      expect(matchingBlockIndex(en, 4, as), 2);
      expect(matchingBlockIndex(en, 0, as), 0);
    });

    test('empty target returns the start', () {
      expect(matchingBlockIndex(blocks(['a']), 0, const []), 0);
    });
  });

  test('Chapter survives saving for offline reading', () {
    final ch = Chapter(
      id: '1',
      slug: 's',
      versions: {
        AppLang.english: ChapterVersion(
          title: 'T',
          status: 'published',
          blocks: [Block(key: 'p1', position: 1, type: BlockType.factBox, style: BlockStyle.examFact, body: 'B')],
        ),
      },
    );
    final back = Chapter.fromJson(ch.toJson());
    final b = back.versions[AppLang.english]!.blocks.single;
    expect(back.versions[AppLang.english]!.title, 'T');
    expect(b.type, BlockType.factBox);
    expect(b.style, BlockStyle.examFact);
    expect(back.has(AppLang.assamese), isFalse);
  });

  group('Phase 3', () {
    test('term markers are split into tappable parts', () {
      final parts = parseInline('The {{term:ahom-kingdom}} and {{term:majuli|the river island}}.');
      expect(parts.length, 5);
      expect(parts[1].termSlug, 'ahom-kingdom');
      expect(parts[1].text, isNull);
      expect(parts[3].termSlug, 'majuli');
      expect(parts[3].text, 'the river island');
      final terms = {'ahom-kingdom': Term(slug: 'ahom-kingdom', termEn: 'Ahom kingdom', termAs: 'আহোম ৰাজ্য')};
      expect(plainText('The {{term:ahom-kingdom}}.', terms, AppLang.assamese), 'The আহোম ৰাজ্য.');
      expect(plainText('No terms here'), 'No terms here');
    });

    test('search finds paragraphs and terms, and cleans risky characters', () async {
      final r = await DemoContentRepository().search('sample text');
      expect(r.chapters, isNotEmpty);
      expect(r.chapters.first.blockKey, isNotNull);
      final t = await DemoContentRepository().search('sample term');
      expect(t.terms.single.slug, 'sample-term');
      expect(cleanQuery(' a,b%(c) '), 'a b c');
    });

    test('offline search looks in chapters saved on the phone', () async {
      final remote = _Switchable(DemoContentRepository());
      final repo = CachedContentRepository(remote, _MemoryCache());
      await repo.chapter('demo');
      await repo.terms();
      remote.online = false;
      final r = await repo.search('নমুনা');
      expect(r.offline, isTrue);
      expect(r.chapters, isNotEmpty);
      expect(r.terms.single.slug, 'sample-term');
    });

    test('saved chapters are remembered', () async {
      SharedPreferences.setMockInitialValues({});
      final store = BookmarkStore();
      await store.save(Bookmark(contentId: 'c1', blockKey: 'p3', titleAs: 'ক', titleEn: 'A', savedAt: DateTime(2026)));
      final again = BookmarkStore();
      await again.load();
      expect(again.find('c1')!.blockKey, 'p3');
      await again.remove('c1');
      expect(again.contains('c1'), isFalse);
    });

    test('side-by-side pairs paragraphs by key and keeps your place', () {
      Block b(String k) => Block(key: k, position: 0, body: k);
      final ch = Chapter(
        id: 'x',
        slug: 'x',
        versions: {
          AppLang.english: ChapterVersion(title: 'E', blocks: [b('p1'), b('p2'), b('p3')]),
          AppLang.assamese: ChapterVersion(title: 'A', blocks: [b('p1'), b('p3'), b('extra')]),
        },
      );
      final side = buildReaderRows(ch, AppLang.english, true);
      expect(side.map((r) => r.key), ['p1', 'p2', 'p3', 'extra']);
      expect(side[1].secondary, isNull);
      expect(side[3].primary, isNull);
      final single = buildReaderRows(ch, AppLang.assamese, false);
      // Reading p3 (list item 3) in English side-by-side, then switching to Assamese.
      expect(mapReaderIndex(side, 3, single), 2);
    });

    testWidgets('Tapping a word shows its meaning; saving a chapter works', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final services = await _services(lang: 'en');
      await tester.pumpWidget(AssampediaApp(services: services));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Learn').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('History of Assam'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample chapter (layout test)'));
      await tester.pumpAndSettle();

      await tester.tapOnText(find.textRange.ofSubstring('Sample term').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('A sample dictionary entry'), findsOneWidget);
      expect(find.text('নমুনা শব্দ'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pumpAndSettle();
      expect(services.bookmarks.contains('demo'), isTrue);

      await tester.tap(find.byIcon(Icons.vertical_split_outlined));
      await tester.pumpAndSettle();
      expect(find.text('নমুনা অধ্যায় (পৰীক্ষা)'), findsOneWidget);
      expect(find.text('Sample chapter (layout test)'), findsOneWidget);
    });
  });

  group('Phase 4', () {
    test('exam and career templates cover every required section', () {
      expect(examSections.length, 20);
      expect(jobSections.length, 21);
      expect(examSections.where((t) => t.suggested).map((t) => t.en), ['Preparation strategy', 'Recommended study resources']);
      for (final t in [...examSections, ...jobSections]) {
        expect(t.as.trim(), isNotEmpty);
        expect(t.en.trim(), isNotEmpty);
      }
    });

    test('official links and section survive saving offline', () {
      final ch = Chapter(id: '1', slug: 's', versions: {}, officialUrl: 'https://a', notificationUrl: 'https://b', appliesTo: 'v1');
      final back = Chapter.fromJson(ch.toJson());
      expect([back.officialUrl, back.notificationUrl, back.appliesTo], ['https://a', 'https://b', 'v1']);
      final c = Category.fromJson(Category(id: 'x', slug: 'x', position: 1, nameAs: 'ক', nameEn: 'A', section: 'job').toJson());
      expect(c.section, 'job');
      expect(blockStyleFrom(blockStyleCode(BlockStyle.suggested)), BlockStyle.suggested);
    });

    test('encyclopedia does not list exam or career groups', () async {
      final repo = DemoContentRepository();
      expect((await repo.categories()).every((c) => c.section == 'gk'), isTrue);
      expect((await repo.categories(section: 'exam')).single.slug, 'exams-sample');
    });

    testWidgets('Exams tab opens a page with its version and official link', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final services = await _services(lang: 'en');
      await tester.pumpWidget(AssampediaApp(services: services));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Exams'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample exam group'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample chapter (layout test)'));
      await tester.pumpAndSettle();
      expect(find.text('Applies to: Sample version (layout test)'), findsOneWidget);
      expect(find.text('Official website'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Suggestion: not official information'), 300);
      expect(find.text('Suggestion: not official information'), findsOneWidget);
    });
  });

  group('Phase 5: vacancies and current affairs', () {
    final today = DateTime(2026, 6, 15);
    VacancyStatus st(int closesIn, {int? startsIn, String stage = 'notification'}) => vacancyStatus(
      stage: stage,
      startDate: startsIn == null ? null : today.add(Duration(days: startsIn)),
      closingDate: today.add(Duration(days: closesIn)),
      today: today,
    );

    test('Status comes from the dates, so expired vacancies never show as open', () {
      expect(st(30), VacancyStatus.open);
      expect(st(7), VacancyStatus.closingSoon);
      expect(st(0), VacancyStatus.closingSoon);
      expect(st(-1), VacancyStatus.closed);
      expect(st(30, startsIn: 3), VacancyStatus.newNotification);
      expect(st(-10, stage: 'result'), VacancyStatus.result);
      expect(st(-10, stage: 'admit_card'), VacancyStatus.admitCard);
      expect(VacancyStatus.closed.canApply, isFalse);
      expect(VacancyStatus.open.canApply, isTrue);
    });

    test('News period filters', () {
      expect(inPeriod(today, NewsPeriod.today, today), isTrue);
      expect(inPeriod(today.subtract(const Duration(days: 1)), NewsPeriod.today, today), isFalse);
      expect(inPeriod(today.subtract(const Duration(days: 6)), NewsPeriod.week, today), isTrue);
      expect(inPeriod(today.subtract(const Duration(days: 7)), NewsPeriod.week, today), isFalse);
      expect(inPeriod(DateTime(2026, 6, 1), NewsPeriod.month, today), isTrue);
      expect(inPeriod(DateTime(2026, 5, 31), NewsPeriod.month, today), isFalse);
      expect(inPeriod(null, NewsPeriod.all, today), isTrue);
    });

    test('Vacancy survives saving and loading', () {
      final v = Vacancy(
        id: 'x',
        category: JobCategory.banking,
        text: {'post_en': 'Clerk', 'post_as': 'কেৰানী'},
        count: 12,
        startDate: DateTime(2026, 6, 1),
        closingDate: DateTime(2026, 6, 30),
        notificationUrl: 'https://example.org/n.pdf',
        lastVerified: DateTime(2026, 6, 2),
        isPublished: true,
      );
      final back = Vacancy.fromJson(v.toJson());
      expect(back.post(AppLang.english), 'Clerk');
      expect(back.post(AppLang.assamese), 'কেৰানী');
      expect(back.category, JobCategory.banking);
      expect(back.count, 12);
      expect(back.closingDate, DateTime(2026, 6, 30));
      expect(back.toJson()['closing_date'], '2026-06-30');
      expect(back.get('qualification', AppLang.english), isNull);
    });

    test('Current affairs pages get the nine standard sections', () {
      expect(sectionsFor('ca').length, 9);
      expect(sectionsFor('ca').last.en, 'References and source links');
    });

    testWidgets('Jobs tab lists open vacancies and current affairs', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final services = await _services(lang: 'en');
      await tester.pumpWidget(AssampediaApp(services: services));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.work_outline));
      await tester.pumpAndSettle();
      expect(find.text('Sample vacancy A (layout test)'), findsOneWidget);
      expect(find.text('Sample vacancy B (layout test)'), findsOneWidget);
      expect(find.text('Sample vacancy C (layout test)'), findsNothing);

      await tester.tap(find.text('Current Affairs'));
      await tester.pumpAndSettle();
      expect(find.text('Sample chapter (layout test)'), findsOneWidget);
    });
  });

  group('Phase 6: practice zone', () {
    test('Question survives saving, and options follow the question language', () {
      final q = Question(
        id: 'a',
        setId: 's',
        text: {'question_en': 'Q?', 'explanation_en': 'Because.'},
        optionsEn: ['x', 'y', 'z'],
        correctIndex: 2,
        source: 'Checked source',
      );
      final back = Question.fromJson(q.toJson());
      expect(back.correctIndex, 2);
      expect(back.options(AppLang.english), ['x', 'y', 'z']);
      // No Assamese version: question, options and explanation fall back together.
      expect(back.question(AppLang.assamese), 'Q?');
      expect(back.options(AppLang.assamese), ['x', 'y', 'z']);
      expect(back.get('explanation', AppLang.assamese), 'Because.');
      expect(back.source, 'Checked source');
    });

    test('Question set reads its question count from the database or offline copy', () {
      final online = QuestionSet.fromJson({
        'id': 's',
        'kind': 'mock',
        'level': 'competitive',
        'title_en': 'Mock 1',
        'time_limit_minutes': 30,
        'questions': [
          {'count': 25},
        ],
      });
      expect(online.questionCount, 25);
      expect(online.isTimed, isTrue);
      expect(online.kind, QuizKind.mock);
      expect(online.level, QuizLevel.competitive);
      final offline = QuestionSet.fromJson(online.toJson());
      expect(offline.questionCount, 25);
      expect(online.toRow().containsKey('question_count'), isFalse);
    });

    test('Daily question changes every day and goes round the list', () {
      final d = DateTime(2026, 11, 24);
      final a = dailyIndex(d, 5);
      expect(dailyIndex(d.add(const Duration(days: 1)), 5), (a + 1) % 5);
      expect(dailyIndex(d.add(const Duration(days: 5)), 5), a);
      expect(dailyIndex(d, 0), -1);
    });

    test('Progress adds up scores and keeps the best per quiz', () async {
      SharedPreferences.setMockInitialValues({});
      final p = PracticeProgressStore();
      await p.load();
      await p.add(QuizAttempt(setId: 's', score: 2, total: 4, at: DateTime(2026)));
      await p.add(QuizAttempt(setId: 's', score: 3, total: 4, at: DateTime(2026)));
      expect(p.quizzesTaken, 2);
      expect(p.accuracy, 5 / 8);
      expect(p.best('s')!.score, 3);
      expect(p.best('other'), isNull);
      final again = PracticeProgressStore();
      await again.load();
      expect(again.quizzesTaken, 2);
    });

    testWidgets('Take a quiz from Home and see the result', (tester) async {
      tester.view.physicalSize = const Size(1200, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final services = await _services(lang: 'en');
      await tester.pumpWidget(AssampediaApp(services: services));
      await tester.pumpAndSettle();
      expect(find.text('Daily Assam GK question'), findsOneWidget);

      await tester.tap(find.text('Practice Zone'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sample quiz (layout test)'));
      await tester.pumpAndSettle();
      expect(find.text('Question 1 of 2'), findsOneWidget);

      await tester.tap(find.text('Option B')); // correct
      await tester.pumpAndSettle();
      expect(find.text('Correct!'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option A')); // wrong (D is right)
      await tester.pumpAndSettle();
      expect(find.text('Not correct'), findsOneWidget);
      expect(find.text('Correct answer: Option D'), findsOneWidget);
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.text('Practise the wrong ones'), findsOneWidget);
      expect(services.progress.quizzesTaken, 1);
    });
  });

  testWidgets('Courses tab: open a course, the 4th lesson is locked, opening a lesson ticks it', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final services = await _services(lang: 'en');
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(InkWell), matching: find.text('Study')).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Premium').first);
    await tester.pumpAndSettle();
    expect(find.text('Sample course (layout test)'), findsOneWidget);
    expect(find.textContaining('4 lessons'), findsOneWidget);
    await tester.tap(find.text('Sample course (layout test)'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 4 done'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Quiz · Free'), findsOneWidget);

    await tester.tap(find.text('Start: Lesson 1'));
    await tester.pumpAndSettle();
    expect(find.text('Applies to: Sample version (layout test)'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('1 of 4 done'), findsOneWidget);
    expect(find.text('Continue: Lesson 2'), findsOneWidget);
    expect(services.courseProgress.isDone('l1'), isTrue);

    await tester.tap(find.text('Sample locked chapter'));
    await tester.pumpAndSettle();
    expect(find.text('Premium'), findsWidgets);
    expect(services.courseProgress.isDone('l4'), isFalse);
  });

  testWidgets('Study tab: free PDFs under Free; premium sections preview 3 items, then lock', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final services = await _services(lang: 'en');
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: find.byType(InkWell), matching: find.text('Study')).last);
    await tester.pumpAndSettle();
    expect(find.text('Free PDF Study Material'), findsOneWidget);
    expect(find.text('Sample premium notes'), findsNothing);
    await tester.tap(find.text('Free PDF Study Material'));
    await tester.pumpAndSettle();
    expect(find.text('Sample PDF (layout test)'), findsOneWidget);
    expect(find.text('PDF · 1.1 MB · Free'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Premium').first);
    await tester.pumpAndSettle();
    expect(find.text('Unlock everything with Premium'), findsOneWidget);
    await tester.tap(find.text('Sample premium notes'));
    await tester.pumpAndSettle();
    expect(find.text('Sample sub-section'), findsOneWidget);
    expect(find.text('Sample video class'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Unlock 1 more with Premium'), findsOneWidget);
    await tester.tap(find.text('Sample locked notes'));
    await tester.pumpAndSettle();
    expect(find.text('All notes, PDFs and videos'), findsOneWidget);
  });

  test('YouTube links give their video id; other links do not', () {
    expect(youTubeId('https://youtu.be/abc123'), 'abc123');
    expect(youTubeId('https://www.youtube.com/watch?v=xyz&t=5'), 'xyz');
    expect(youTubeId('https://m.youtube.com/shorts/s1'), 's1');
    expect(youTubeId('https://example.com/video'), isNull);
    expect(fileSizeLabel(1200000), '1.1 MB');
    expect(fileSizeLabel(2048), '2 KB');
  });

  test('Sub-sections are found under their parent, in order', () {
    final all = [
      StudySection(id: 'b', parentId: 'a', titleEn: 'B', position: 2),
      StudySection(id: 'a', titleEn: 'A'),
      StudySection(id: 'c', parentId: 'a', titleEn: 'C', position: 1),
    ];
    expect(childSections(all, null).map((s) => s.id), ['a']);
    expect(childSections(all, 'a').map((s) => s.id), ['c', 'b']);
  });

  testWidgets('Phase 6b: flashcards flip and one-liners list the answers', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final services = await _services(lang: 'en');
    await tester.pumpWidget(AssampediaApp(services: services));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practice Zone'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flashcards'));
    await tester.pumpAndSettle();
    expect(find.text('Card 1 of 2'), findsOneWidget);
    expect(find.text('Sample question 1 (layout test)'), findsOneWidget);
    await tester.tap(find.text('Tap to see the answer'));
    await tester.pumpAndSettle();
    expect(find.text('Option B'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Card 2 of 2'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('One-liners'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Option D', findRichText: true), findsOneWidget);
  });

  test('Phase 6c: the first 3 of each group are free', () {
    final p = PremiumService();
    expect([for (var i = 0; i < 5; i++) p.canOpen(indexInGroup: i)], [true, true, true, false, false]);
  });

  testWidgets('Phase 6c: the 4th quiz of a type shows a lock and opens the Premium page', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({'app_lang': 'en'});
    final services = await _services(lang: 'en');
    final withFour = AppServices(language: services.language, theme: services.theme, content: _FourQuizzes(), auth: services.auth);
    await tester.pumpWidget(AssampediaApp(services: withFour));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practice Zone'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    await tester.tap(find.text('Quiz 4'));
    await tester.pumpAndSettle();
    expect(find.text('ASSAMPEDIA Premium'), findsOneWidget);
    expect(find.text('Job vacancies always stay free'), findsOneWidget);
  });
}

class _FourQuizzes extends DemoContentRepository {
  @override
  Future<List<QuestionSet>> questionSets() async => [
    for (var i = 1; i <= 4; i++)
      QuestionSet(id: 't$i', kind: QuizKind.topic, position: i, text: {'title_en': 'Quiz $i'}, isPublished: true, questionCount: 1),
  ];
}

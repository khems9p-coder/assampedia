import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:assampedia/core/app_scope.dart';
import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/data/auth_service.dart';
import 'package:assampedia/data/cached_content_repository.dart';
import 'package:assampedia/data/content_repository.dart';
import 'package:assampedia/data/demo_content_repository.dart';
import 'package:assampedia/data/models.dart';
import 'package:assampedia/data/offline_cache.dart';
import 'package:assampedia/main.dart';

Future<AppServices> _services({String? lang}) async {
  SharedPreferences.setMockInitialValues({'app_lang': ?lang});
  final theme = ThemeController();
  final language = LanguageController();
  await theme.load();
  await language.load();
  return AppServices(language: language, theme: theme, content: DemoContentRepository(), auth: AuthService(null));
}

class _MemoryCache extends OfflineCache {
  final store = <String, Object>{};
  @override
  Future<void> write(String key, Object json) async => store[key] = json;
  @override
  Future<dynamic> read(String key) async => store[key];
}

class _Switchable implements ContentRepository {
  _Switchable(this.inner);
  final ContentRepository inner;
  bool online = true;
  Future<T> _go<T>(Future<T> Function() f) => online ? f() : Future.error(Exception('offline'));
  @override
  Future<List<Category>> categories() => _go(inner.categories);
  @override
  Future<List<ChapterSummary>> chapters(String id) => _go(() => inner.chapters(id));
  @override
  Future<Chapter> chapter(String id) => _go(() => inner.chapter(id));
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
    expect(find.text('অসমৰ ইতিহাস'), findsOneWidget);
  });

  testWidgets('Reader switches language instantly', (tester) async {
    final services = await _services(lang: 'en');
    await tester.pumpWidget(AssampediaApp(services: services));
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
    final ch = Chapter(id: '1', slug: 's', versions: {
      AppLang.english: ChapterVersion(title: 'T', status: 'published', blocks: [
        Block(key: 'p1', position: 1, type: BlockType.factBox, style: BlockStyle.examFact, body: 'B'),
      ]),
    });
    final back = Chapter.fromJson(ch.toJson());
    final b = back.versions[AppLang.english]!.blocks.single;
    expect(back.versions[AppLang.english]!.title, 'T');
    expect(b.type, BlockType.factBox);
    expect(b.style, BlockStyle.examFact);
    expect(back.has(AppLang.assamese), isFalse);
  });
}

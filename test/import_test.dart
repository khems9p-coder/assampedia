import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:assampedia/core/app_scope.dart';
import 'package:assampedia/core/i18n/app_lang.dart';
import 'package:assampedia/core/theme/theme_controller.dart';
import 'package:assampedia/data/admin_repository.dart';
import 'package:assampedia/data/auth_service.dart';
import 'package:assampedia/data/demo_content_repository.dart';
import 'package:assampedia/features/admin/admin_import_screen.dart';

/// Records imports instead of writing to a database.
class _FakeAdmin extends AdminRepository {
  _FakeAdmin()
    : super(
        SupabaseClient('http://localhost', 'test-key', authOptions: const AuthClientOptions(autoRefreshToken: false)),
      );
  final imported = <String>[];

  @override
  Future<ImportResult> importGroup(Map<String, dynamic> group) async {
    imported.add(group['group'] as String);
    return ImportResult(added: (group['chapters'] as List).length, skipped: 0, terms: (group['terms'] as List).length);
  }
}

void main() {
  final dir = Directory('supabase/content/json');

  test('content JSON files are complete and match the index', () {
    final index = jsonDecode(File('${dir.path}/index.json').readAsStringSync()) as Map<String, dynamic>;
    final groups = index['groups'] as List;
    expect(groups, isNotEmpty);
    final slugs = <String>{};
    for (final g in groups) {
      final data = jsonDecode(File('${dir.path}/${g['file']}').readAsStringSync()) as Map<String, dynamic>;
      expect((data['chapters'] as List).length, g['chapters']);
      for (final ch in data['chapters'] as List) {
        expect(slugs.add(ch['slug'] as String), isTrue, reason: 'duplicate chapter ${ch['slug']}');
        final blocks = ch['blocks'] as Map<String, dynamic>;
        expect(blocks.keys.toSet(), {'en', 'as'});
        for (final b in [...blocks['en'] as List, ...blocks['as'] as List]) {
          if (b['block_type'] != 'image') continue;
          const base = 'https://raw.githubusercontent.com/khems9p-coder/assampedia/main/supabase/content/images/';
          final url = b['image_url'] as String;
          expect(url, startsWith(base));
          expect(File('supabase/content/images/${url.substring(base.length)}').existsSync(), isTrue, reason: url);
          expect(b['body'] as String, isNotEmpty, reason: 'pictures need a caption');
        }
        expect(
          [for (final b in blocks['en'] as List) b['block_key']],
          [for (final b in blocks['as'] as List) b['block_key']],
        );
      }
    }
  });

  testWidgets('Import all downloads each group in order and reports the result', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final theme = ThemeController();
    final language = LanguageController();
    await theme.load();
    await language.load();
    final admin = _FakeAdmin();
    final services = AppServices(
      language: language,
      theme: theme,
      content: DemoContentRepository(),
      auth: AuthService(null),
      admin: admin,
    );

    final client = MockClient((req) async {
      final name = req.url.pathSegments.last;
      final f = File('${dir.path}/$name');
      if (!f.existsSync()) return http.Response('missing', 404);
      return http.Response.bytes(f.readAsBytesSync(), 200);
    });

    await tester.pumpWidget(
      AppScope(
        services: services,
        child: MaterialApp(
          home: AdminImportScreen(baseUrl: 'https://example.test/json/', httpClient: client),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();
    expect(find.text('Introduction to Assam'), findsOneWidget);

    await tester.tap(find.text('Import all groups'));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await tester.pumpAndSettle();
    expect(admin.imported.first, '01_introduction');
    expect(admin.imported, orderedEquals([...admin.imported]..sort()));
    expect(admin.imported.length, 13);
    expect(find.text('Added 8 chapters as drafts.'), findsOneWidget); // History
  });
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_scope.dart';
import 'core/config/app_config.dart';
import 'core/i18n/app_lang.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/admin_repository.dart';
import 'data/auth_service.dart';
import 'data/bookmark_store.dart';
import 'data/cached_content_repository.dart';
import 'data/content_repository.dart';
import 'data/demo_content_repository.dart';
import 'data/offline_cache.dart';
import 'data/supabase_content_repository.dart';
import 'features/onboarding/language_select_screen.dart';
import 'features/shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = ThemeController();
  final language = LanguageController();
  final bookmarks = BookmarkStore();
  await Future.wait([theme.load(), language.load(), bookmarks.load()]);

  SupabaseClient? client;
  if (AppConfig.isConfigured) {
    await Supabase.initialize(url: AppConfig.supabaseUrl, publishableKey: AppConfig.supabaseKey);
    client = Supabase.instance.client;
  }

  ContentRepository? content;
  if (AppConfig.demoMode) {
    content = DemoContentRepository();
  } else if (client != null) {
    content = CachedContentRepository(SupabaseContentRepository(client), OfflineCache());
  }

  runApp(
    AssampediaApp(
      services: AppServices(
        language: language,
        theme: theme,
        content: content,
        auth: AuthService(client),
        admin: client == null ? null : AdminRepository(client),
        bookmarks: bookmarks,
      ),
    ),
  );
}

class AssampediaApp extends StatelessWidget {
  const AssampediaApp({super.key, required this.services});

  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: services,
      child: LanguageScope(
        controller: services.language,
        child: ListenableBuilder(
          listenable: Listenable.merge([services.theme, services.language]),
          builder: (context, _) => MaterialApp(
            title: 'ASSAMPEDIA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: services.theme.mode,
            home: services.language.hasChosen ? const MainShell() : const LanguageSelectScreen(),
          ),
        ),
      ),
    );
  }
}

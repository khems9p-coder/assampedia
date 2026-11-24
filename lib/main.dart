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
import 'data/saved_jobs_store.dart';
import 'data/cached_content_repository.dart';
import 'data/content_repository.dart';
import 'data/demo_content_repository.dart';
import 'data/offline_cache.dart';
import 'data/practice_models.dart';
import 'data/premium_service.dart';
import 'data/supabase_content_repository.dart';
import 'features/account/profile_screen.dart';
import 'features/onboarding/language_select_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/shell/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = ThemeController();
  final language = LanguageController();
  final bookmarks = BookmarkStore();
  final savedJobs = SavedJobsStore();
  final progress = PracticeProgressStore();
  await Future.wait([theme.load(), language.load(), bookmarks.load(), savedJobs.load(), progress.load()]);

  SupabaseClient? client;
  if (AppConfig.isConfigured) {
    await Supabase.initialize(url: AppConfig.supabaseUrl, publishableKey: AppConfig.supabaseKey);
    client = Supabase.instance.client;
  }

  final premium = PremiumService(client);
  // Not awaited: the app opens straight away and locks update when ready.
  premium.start();

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
        savedJobs: savedJobs,
        progress: progress,
        premium: premium,
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
          listenable: Listenable.merge([services.theme, services.language, services.auth]),
          builder: (context, _) => MaterialApp(
            title: 'ASSAMPEDIA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: services.theme.mode,
            home: _startScreen(),
          ),
        ),
      ),
    );
  }

  /// After installing, readers sign in first; then they reach the content.
  /// (Without a server, as in the demo, the language picker comes first instead.)
  /// Then, the first time, they fill in their profile.
  Widget _startScreen() {
    final auth = services.auth;
    if (auth.available) {
      if (!auth.isSignedIn) return const WelcomeScreen();
      if (auth.checking) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      if (auth.needsProfile || auth.needsSecurityQuestion) return const ProfileScreen(firstTime: true);
      return const MainShell();
    }
    return services.language.hasChosen ? const MainShell() : const LanguageSelectScreen();
  }
}

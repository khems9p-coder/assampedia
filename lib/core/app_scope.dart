import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/admin_repository.dart';
import '../data/auth_service.dart';
import '../data/bookmark_store.dart';
import '../data/content_repository.dart';
import '../data/models.dart';
import '../data/notification_service.dart';
import '../data/practice_models.dart';
import '../data/premium_service.dart';
import '../data/saved_jobs_store.dart';
import 'i18n/app_lang.dart';
import 'i18n/strings.dart';
import 'theme/theme_controller.dart';

/// Gives every screen access to the shared app services.
class AppServices {
  AppServices({
    required this.language,
    required this.theme,
    required this.content,
    required this.auth,
    this.admin,
    BookmarkStore? bookmarks,
    SavedJobsStore? savedJobs,
    PracticeProgressStore? progress,
    PremiumService? premium,
    NotificationService? notifications,
  }) : bookmarks = bookmarks ?? BookmarkStore(),
       savedJobs = savedJobs ?? SavedJobsStore(),
       progress = progress ?? PracticeProgressStore(),
       premium = premium ?? PremiumService(),
       notifications = notifications ?? NotificationService(onDevice: false);

  final LanguageController language;
  final ThemeController theme;
  final ContentRepository? content;
  final AuthService auth;
  final AdminRepository? admin;
  final BookmarkStore bookmarks;
  final SavedJobsStore savedJobs;

  /// Quiz scores, kept on this phone.
  final PracticeProgressStore progress;

  /// Premium subscription status and purchase.
  final PremiumService premium;

  /// The morning quote notification and new-vacancy count.
  final NotificationService notifications;

  Future<List<Term>>? _terms;

  /// Dictionary terms, downloaded once per app start.
  Future<List<Term>> terms() {
    final repo = content;
    if (repo == null) return Future.value(const []);
    return _terms ??= repo.terms().catchError((Object e) {
      _terms = null;
      throw e;
    });
  }

  /// Call after an admin changes the dictionary.
  void refreshTerms() => _terms = null;

  static const _sideBySideKey = 'side_by_side';

  Future<bool> sideBySide() async => (await SharedPreferences.getInstance()).getBool(_sideBySideKey) ?? false;

  Future<void> setSideBySide(bool on) async => (await SharedPreferences.getInstance()).setBool(_sideBySideKey, on);

  static const _lastChapterKey = 'last_chapter';

  Future<void> rememberChapter(String id, String titleAs, String titleEn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_lastChapterKey, [id, titleAs, titleEn]);
  }

  Future<List<String>?> lastChapter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_lastChapterKey);
  }
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.services, required super.child});
  final AppServices services;

  static AppServices of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.services;

  @override
  bool updateShouldNotify(AppScope oldWidget) => services != oldWidget.services;
}

/// Rebuilds every screen that shows text when the language changes.
class LanguageScope extends InheritedNotifier<LanguageController> {
  const LanguageScope({super.key, required LanguageController controller, required super.child}) : super(notifier: controller);

  static LanguageController of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<LanguageScope>()!.notifier!;
}

extension AppContext on BuildContext {
  AppServices get services => AppScope.of(this);
  AppLang get lang => LanguageScope.of(this).lang;
  S get s => S(lang);
}

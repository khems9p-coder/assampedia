import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The two languages of ASSAMPEDIA. [code] matches the database ('as' / 'en').
enum AppLang {
  assamese('as', 'অসমীয়া'),
  english('en', 'English');

  const AppLang(this.code, this.label);
  final String code;
  final String label;

  AppLang get other => this == assamese ? english : assamese;

  static AppLang? fromCode(String? code) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return null;
  }
}

/// Remembers the reader's language. It is null until they choose one
/// on first launch.
class LanguageController extends ChangeNotifier {
  static const _key = 'app_lang';
  AppLang? _lang;

  AppLang? get chosen => _lang;
  AppLang get lang => _lang ?? AppLang.assamese;
  bool get hasChosen => _lang != null;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = AppLang.fromCode(prefs.getString(_key));
    notifyListeners();
  }

  Future<void> set(AppLang lang) async {
    if (_lang == lang) return;
    _lang = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, lang.code);
  }
}

/// Connection details for the Supabase project.
/// The URL and publishable (anon) key are safe to ship inside the app:
/// the database's security rules decide what each user may read or change.
class AppConfig {
  AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const supabaseKey = String.fromEnvironment('SUPABASE_KEY', defaultValue: '');

  /// Demo mode shows clearly labelled sample text, used only for testing layouts.
  static const demoMode = bool.fromEnvironment('DEMO', defaultValue: false);

  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}

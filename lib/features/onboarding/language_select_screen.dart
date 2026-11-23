import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';

/// First launch: the reader picks Assamese or English. Saved for next time.
class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  AppLang _picked = AppLang.assamese;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(24),
              children: [
                Center(child: Image.asset('assets/brand/logo.png', width: 120, height: 120)),
                const SizedBox(height: 16),
                Text('ASSAMPEDIA',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary, letterSpacing: 1.5)),
                const SizedBox(height: 24),
                Text('আপোনাৰ ভাষা বাছনি কৰক', textAlign: TextAlign.center, style: theme.textTheme.titleLarge),
                Text('Choose your language', textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                const SizedBox(height: 20),
                for (final l in AppLang.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LangOption(lang: l, selected: _picked == l, onTap: () => setState(() => _picked = l)),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: () => context.services.language.set(_picked),
                  child: Text(_picked == AppLang.assamese ? 'আগবাঢ়ক' : 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({required this.lang, required this.selected, required this.onTap});
  final AppLang lang;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: selected ? scheme.primary : scheme.outlineVariant, width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(children: [
            Expanded(child: Text(lang.label, style: Theme.of(context).textTheme.titleLarge)),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: scheme.primary),
          ]),
        ),
      ),
    );
  }
}

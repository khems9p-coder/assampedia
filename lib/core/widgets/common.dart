import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../i18n/app_lang.dart';

/// The [ অসমীয়া | English ] switch shown on reading screens.
class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key, this.onChanged});

  /// Called after the language changes (the reader uses it to keep your place).
  final ValueChanged<AppLang>? onChanged;

  @override
  Widget build(BuildContext context) {
    final current = context.lang;
    return SegmentedButton<AppLang>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      segments: [for (final l in AppLang.values) ButtonSegment(value: l, label: Text(l.label))],
      selected: {current},
      onSelectionChanged: (sel) {
        final l = sel.first;
        if (l == current) return;
        if (onChanged != null) {
          onChanged!(l);
        } else {
          context.services.language.set(l);
        }
      },
    );
  }
}

IconData categoryIcon(String? name) => switch (name) {
      'map' => Icons.map_outlined,
      'history' => Icons.history_edu_outlined,
      'terrain' => Icons.terrain_outlined,
      'theater' => Icons.theater_comedy_outlined,
      'pets' => Icons.pets_outlined,
      'payments' => Icons.payments_outlined,
      'account_balance' => Icons.account_balance_outlined,
      'groups' => Icons.groups_outlined,
      'person' => Icons.person_outline,
      'trending_up' => Icons.trending_up,
      'location_city' => Icons.location_city_outlined,
      'place' => Icons.place_outlined,
      'flag' => Icons.flag_outlined,
      'gavel' => Icons.gavel_outlined,
      'shield' => Icons.shield_outlined,
      'work' => Icons.work_outline,
      'public' => Icons.public,
      'menu_book' => Icons.menu_book_outlined,
      'workspace_premium' => Icons.workspace_premium_outlined,
      'picture_as_pdf' => Icons.picture_as_pdf_outlined,
      'video' => Icons.ondemand_video_outlined,
      'newspaper' => Icons.newspaper_outlined,
      'school' => Icons.school_outlined,
      _ => Icons.menu_book_outlined,
    };

/// Shown when something could not load.
class LoadError extends StatelessWidget {
  const LoadError({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off_outlined, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onRetry, child: Text(context.s.retry)),
          ]),
        ),
      );
}

/// A clear notice for sections that arrive in a later phase.
class LaterPhase extends StatelessWidget {
  const LaterPhase({super.key, required this.title, required this.phase, required this.icon});
  final String title;
  final int phase;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(context.s.comingInPhase(phase), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            ]),
          ),
        ),
      );
}

/// Small "Developed by Kbx" line shown at the bottom of the side menu and Me screen.
class DeveloperCredit extends StatelessWidget {
  const DeveloperCredit({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        context.s.developedBy,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, letterSpacing: 0.3),
      ),
    );
  }
}

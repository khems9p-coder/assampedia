import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/jobs_models.dart';

/// 24-11-2026 style, easy to read in both languages.
String formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

Color statusColor(BuildContext context, VacancyStatus s) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (s) {
    VacancyStatus.open => dark ? const Color(0xFFA5D6A7) : const Color(0xFF2E7D32),
    VacancyStatus.closingSoon => dark ? const Color(0xFFFFCC80) : const Color(0xFFE65100),
    VacancyStatus.newNotification => dark ? const Color(0xFF90CAF9) : const Color(0xFF1565C0),
    VacancyStatus.closed => Theme.of(context).colorScheme.outline,
    _ => dark ? const Color(0xFFCE93D8) : const Color(0xFF6A1B9A),
  };
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final VacancyStatus status;

  @override
  Widget build(BuildContext context) {
    final c = statusColor(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c),
      ),
      child: Text(
        status.label(context.lang),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// One vacancy in a list.
class VacancyCard extends StatelessWidget {
  const VacancyCard({super.key, required this.vacancy, required this.onTap, this.isNew = false});
  final Vacancy vacancy;
  final VoidCallback onTap;

  /// Shows a NEW label (on the Notifications screen).
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final status = vacancy.status();
    final org = vacancy.get('organisation', lang);
    final muted = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isNew)
                    Container(
                      margin: const EdgeInsets.only(right: 8, top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: theme.colorScheme.error, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        s.newBadge,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onError, fontWeight: FontWeight.w700),
                      ),
                    ),
                  Expanded(
                    child: Text(vacancy.post(lang), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: status),
                ],
              ),
              if (org != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(org, style: theme.textTheme.bodyMedium),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 14,
                runSpacing: 4,
                children: [
                  _Meta(Icons.event, s.lastDate(formatDate(vacancy.closingDate)), muted),
                  if (status.canApply) _Meta(Icons.hourglass_bottom, s.daysLeft(vacancy.daysLeft()), muted),
                  if (vacancy.count != null) _Meta(Icons.people_outline, s.posts(vacancy.count!), muted),
                  if (vacancy.state != null) _Meta(Icons.place_outlined, vacancy.state!, muted),
                  _Meta(Icons.category_outlined, vacancy.category.name(lang), muted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.text, this.style);
  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: style?.color),
      const SizedBox(width: 4),
      Text(text, style: style),
    ],
  );
}

/// Name of a job category in the current language, or "All".
String categoryLabel(BuildContext context, JobCategory? c) => c == null ? context.s.allCategories : c.name(context.lang);

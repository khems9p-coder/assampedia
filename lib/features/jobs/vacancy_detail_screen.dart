import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/jobs_models.dart';
import '../reader/official_info.dart';
import '../reader/reader_screen.dart';
import 'vacancy_widgets.dart';

/// Everything about one recruitment (master plan, Part 9.2), with links to
/// the official notification and application page.
class VacancyDetailScreen extends StatelessWidget {
  const VacancyDetailScreen({super.key, required this.vacancy});
  final Vacancy vacancy;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final v = vacancy;
    final status = v.status();
    final saved = context.services.savedJobs;

    final rows = <(String, String?)>[
      (s.fOrganisation, v.get('organisation', lang)),
      (s.fDepartment, v.get('department', lang)),
      (s.fPost, v.post(lang)),
      (s.fCount, v.count?.toString()),
      (s.fQualification, v.get('qualification', lang)),
      (s.fAge, v.get('age_limit', lang)),
      (s.fPay, v.get('pay', lang)),
      (s.fStart, v.startDate == null ? null : formatDate(v.startDate!)),
      (s.fClose, formatDate(v.closingDate)),
      (s.fFee, v.get('fee', lang)),
      (s.fSelection, v.get('selection', lang)),
      (s.fLocation, [?v.location, ?v.state].join(', ')),
      (s.fNotes, v.get('notes', lang)),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (v.id != null)
            ListenableBuilder(
              listenable: saved,
              builder: (context, _) => IconButton(
                tooltip: s.saveJob,
                icon: Icon(saved.contains(v.id) ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => saved.toggle(v),
              ),
            ),
          const Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch()),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Text(v.post(lang), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('${s.fStatus}: ', style: theme.textTheme.bodyMedium),
                  StatusChip(status: status),
                  if (status.canApply) ...[const SizedBox(width: 10), Text(s.daysLeft(v.daysLeft()))],
                ],
              ),
              if (!status.canApply && status == VacancyStatus.closed)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(s.closedNote, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => openLink(context, v.notificationUrl),
                    icon: const Icon(Icons.description_outlined),
                    label: Text(s.notificationPdf),
                  ),
                  if (v.applyUrl != null && status.canApply)
                    FilledButton.tonalIcon(
                      onPressed: () => openLink(context, v.applyUrl!),
                      icon: const Icon(Icons.open_in_new),
                      label: Text(s.applyOnline),
                    ),
                  if (v.syllabusContentId != null)
                    OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReaderScreen(contentId: v.syllabusContentId))),
                      icon: const Icon(Icons.menu_book_outlined),
                      label: Text(s.examSyllabus),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              for (final (label, value) in rows)
                if (value != null && value.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
                        const SizedBox(height: 2),
                        SelectableText(value, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                      ],
                    ),
                  ),
              const Divider(height: 32),
              Text(s.lastVerified(formatDate(v.lastVerified)), style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(s.checkOfficial, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

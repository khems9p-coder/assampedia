import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/jobs_models.dart';
import '../../data/quotes.dart';
import '../jobs/vacancy_detail_screen.dart';
import '../jobs/vacancy_widgets.dart';

/// Today's motivational quote and the open job vacancies, with the ones the
/// reader has not seen yet marked NEW.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Future<void>? _loading;
  bool _failed = false;

  /// Vacancies that were new when this screen opened. They keep their NEW
  /// label until the screen closes, even though they now count as seen.
  Set<String> _newIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loading ??= _load();
  }

  Future<void> _load() async {
    final services = context.services;
    final notes = services.notifications;
    try {
      final all = await services.content?.vacancies();
      if (all != null) notes.updateJobs(all);
      _failed = false;
    } catch (_) {
      // Show whatever the Home screen already loaded.
      _failed = notes.openJobs.isEmpty;
    }
    if (!mounted) return;
    setState(
      () => _newIds = {
        for (final v in notes.openJobs)
          if (notes.isNew(v)) v.id!,
      },
    );
    await notes.markJobsSeen();
  }

  void _open(Vacancy v) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => VacancyDetailScreen(vacancy: v)));

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final services = context.services;
    final notes = services.notifications;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final quote = quoteForDay(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(s.notifications)),
      body: ListenableBuilder(
        listenable: notes,
        builder: (context, _) => RefreshIndicator(
          onRefresh: () => _loading = _load(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Card(
                color: scheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.wb_sunny_outlined, color: scheme.onPrimaryContainer),
                          const SizedBox(width: 8),
                          Text(
                            s.thoughtForToday,
                            style: theme.textTheme.labelLarge?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '“${quote.text(lang)}”',
                        style: theme.textTheme.titleMedium?.copyWith(color: scheme.onPrimaryContainer, height: 1.45),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '— ${quote.author(lang)}',
                          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimaryContainer, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                secondary: const Icon(Icons.notifications_active_outlined),
                title: Text(s.morningQuote),
                subtitle: Text(s.morningQuoteHint),
                value: notes.dailyOn,
                onChanged: (on) => notes.setDailyOn(on, lang),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(s.openJobs, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  if (_newIds.isNotEmpty) Text(s.newJobsCount(_newIds.length), style: TextStyle(color: scheme.primary)),
                ],
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: _loading,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done && notes.openJobs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (_failed) return Padding(padding: const EdgeInsets.all(16), child: Text(s.loadFailed));
                  if (notes.openJobs.isEmpty) return Padding(padding: const EdgeInsets.all(16), child: Text(s.noOpenJobs));
                  return Column(
                    children: [
                      for (final v in notes.openJobs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: VacancyCard(vacancy: v, isNew: _newIds.contains(v.id), onTap: () => _open(v)),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

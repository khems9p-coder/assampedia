import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/practice_models.dart';
import 'quiz_screen.dart';
import 'revision_screens.dart';

/// Practice Zone: every published quiz, grouped by kind, with a level filter
/// and the reader's own progress.
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  Future<List<QuestionSet>>? _sets;
  QuizLevel? _level;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sets ??= context.services.content?.questionSets();
  }

  void _reload() => setState(() => _sets = context.services.content?.questionSets());

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final progress = context.services.progress;
    return Scaffold(
      appBar: AppBar(title: Text(s.practiceZone), actions: const [LanguageSwitch(), SizedBox(width: 8)]),
      body: _sets == null
          ? Center(child: Text(s.notConnected))
          : FutureBuilder<List<QuestionSet>>(
              future: _sets,
              builder: (context, snap) {
                if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: _reload);
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final sets = [
                  for (final x in snap.data!)
                    if (_level == null || x.level == _level) x,
                ];
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListenableBuilder(
                    listenable: progress,
                    builder: (context, _) => ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.insights_outlined, color: theme.colorScheme.primary),
                            title: Text(s.myProgress, style: theme.textTheme.titleSmall),
                            subtitle: Text(
                              progress.quizzesTaken == 0
                                  ? s.noProgress
                                  : s.progressLine(progress.quizzesTaken, progress.questionsAnswered, (progress.accuracy * 100).round()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final l in <QuizLevel?>[null, ...QuizLevel.values])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text(l == null ? s.allLevels : l.name(lang)),
                                    selected: _level == l,
                                    onSelected: (_) => setState(() => _level = l),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (sets.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(child: Text(s.noQuizzes)),
                          ),
                        for (final k in QuizKind.values)
                          if (sets.any((x) => x.kind == k)) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
                              child: Text(
                                k.name(lang),
                                style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
                              ),
                            ),
                            for (final x in sets.where((x) => x.kind == k)) _SetCard(set: x, best: progress.best(x.id)),
                          ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _SetCard extends StatelessWidget {
  const _SetCard({required this.set, this.best});
  final QuestionSet set;
  final QuizAttempt? best;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final info = [
      set.level.name(lang),
      s.questionsCount(set.questionCount),
      if (set.timeLimitMinutes != null) s.minutes(set.timeLimitMinutes!),
      if (best != null) s.bestScore(best!.score, best!.total),
    ].join(' · ');
    void open(Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(set.isTimed ? Icons.timer_outlined : Icons.quiz_outlined, color: theme.colorScheme.primary),
            title: Text(set.title(lang)),
            subtitle: Text([?set.description(lang), info].join('\n')),
            isThreeLine: set.description(lang) != null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(QuizScreen(set: set)),
          ),
          // Revision from the same questions (mock tests and the daily question stay unseen).
          if (!set.isTimed && set.kind != QuizKind.daily && set.questionCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Wrap(
                spacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () => open(FlashcardsScreen(set: set)),
                    icon: const Icon(Icons.style_outlined, size: 18),
                    label: Text(s.flashcards),
                  ),
                  TextButton.icon(
                    onPressed: () => open(OneLinersScreen(set: set)),
                    icon: const Icon(Icons.format_list_numbered, size: 18),
                    label: Text(s.oneLiners),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

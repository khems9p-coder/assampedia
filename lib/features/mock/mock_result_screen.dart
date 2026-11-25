import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_models.dart';
import '../practice/quiz_screen.dart' show AnswerExplanation;
import 'mock_intro_screen.dart';

enum _Filter { all, correct, wrong, skipped, marked }

/// The analysis after a mock test: score, counts, accuracy, time, topics,
/// and every answer with its explanation.
class MockResultScreen extends StatefulWidget {
  const MockResultScreen({super.key, required this.result});
  final MockResult result;

  @override
  State<MockResultScreen> createState() => _MockResultScreenState();
}

class _MockResultScreenState extends State<MockResultScreen> {
  _Filter _filter = _Filter.all;

  MockResult get r => widget.result;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.analysis),
        actions: const [LanguageSwitch(), SizedBox(width: 8)],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Text(r.set.title(lang), style: Theme.of(context).textTheme.titleLarge),
              if (r.timeUp) ...[
                const SizedBox(height: 8),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: ListTile(leading: const Icon(Icons.timer_off_outlined), title: Text(s.timeUpSubmitted)),
                ),
              ],
              const SizedBox(height: 8),
              _scoreCard(context),
              const SizedBox(height: 12),
              _stats(context),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).pushReplacement(SectionRoute(context, builder: (_) => MockIntroScreen(set: r.set))),
                    icon: const Icon(Icons.replay),
                    label: Text(s.retakeTest),
                  ),
                  OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: Text(s.done)),
                ],
              ),
              if (r.topics.isNotEmpty) ...[const SizedBox(height: 24), _topics(context)],
              const SizedBox(height: 24),
              _review(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreCard(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final pct = (r.percent * 100).round();
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: r.percent,
                    strokeWidth: 9,
                    backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.6),
                  ),
                  Center(
                    child: Text('$pct%', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.yourScore, style: theme.textTheme.titleMedium),
                  Text(
                    formatMarks(r.marks),
                    style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(s.outOf(formatMarks(r.maxMarks)), style: theme.textTheme.bodyLarge),
                  if (r.marksLost > 0) ...[
                    const SizedBox(height: 6),
                    Text(s.negativeLost(formatMarks(r.marksLost)), style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stats(BuildContext context) {
    final s = context.s;
    final green = Colors.green.shade700;
    final red = Theme.of(context).colorScheme.error;
    final grey = Theme.of(context).colorScheme.outline;
    final primary = Theme.of(context).colorScheme.primary;
    final allowed = r.secondsAllowed;
    final tiles = [
      _Stat(Icons.check_circle, s.correctLabel, '${r.correct}', green),
      _Stat(Icons.cancel, s.wrongLabel, '${r.wrong}', red),
      _Stat(Icons.remove_circle_outline, s.skippedLabel, '${r.skipped}', grey),
      _Stat(Icons.edit_note, s.attemptedLabel, '${r.attempted} / ${r.total}', primary),
      _Stat(Icons.gps_fixed, s.accuracyLabel, '${(r.accuracy * 100).round()}%', primary, hint: s.accuracyHint),
      _Stat(
        Icons.timer_outlined,
        s.timeTaken,
        allowed == null ? formatClock(r.secondsTaken) : '${formatClock(r.secondsTaken)} / ${formatClock(allowed)}',
        primary,
      ),
      if (r.attempted > 0) _Stat(Icons.speed, s.perQuestion, s.secondsShort(r.secondsPerAnswer), primary),
    ];
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 640 ? 4 : 2;
        final w = (c.maxWidth - (cols - 1) * 8) / cols;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final t in tiles) SizedBox(width: w, child: t)],
        );
      },
    );
  }

  Widget _topics(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final green = Colors.green.shade700;
    // A topic is strong at 70% right or more, and weak below 40% (with at least 2 questions).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.topicWise, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (final t in r.topics)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(t.name(lang, s.generalTopic), style: theme.textTheme.titleSmall)),
                            if (t.total >= 2 && t.score >= 0.7)
                              _Tag(s.strongTopic, green)
                            else if (t.total >= 2 && t.score < 0.4)
                              _Tag(s.weakTopic, theme.colorScheme.error),
                            const SizedBox(width: 8),
                            Text('${t.correct}/${t.total}', style: theme.textTheme.titleSmall),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (t.correct > 0) Expanded(flex: t.correct, child: ColoredBox(color: green)),
                                if (t.wrong > 0) Expanded(flex: t.wrong, child: ColoredBox(color: theme.colorScheme.error)),
                                if (t.skipped > 0)
                                  Expanded(flex: t.skipped, child: ColoredBox(color: theme.colorScheme.surfaceContainerHighest)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(s.topicLine(t.correct, t.wrong, t.skipped), style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _review(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    bool keep(int i) => switch (_filter) {
      _Filter.all => true,
      _Filter.correct => r.outcomes[i] == MockOutcome.correct,
      _Filter.wrong => r.outcomes[i] == MockOutcome.wrong,
      _Filter.skipped => r.outcomes[i] == MockOutcome.skipped,
      _Filter.marked => r.marked.contains(i),
    };
    final shown = [
      for (var i = 0; i < r.total; i++)
        if (keep(i)) i,
    ];
    final labels = {
      _Filter.all: '${s.all} (${r.total})',
      _Filter.correct: '${s.correctLabel} (${r.correct})',
      _Filter.wrong: '${s.wrongLabel} (${r.wrong})',
      _Filter.skipped: '${s.skippedLabel} (${r.skipped})',
      if (r.marked.isNotEmpty) _Filter.marked: '${s.markedForReview} (${r.marked.length})',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s.reviewAnswers, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final e in labels.entries)
              ChoiceChip(label: Text(e.value), selected: _filter == e.key, onSelected: (_) => setState(() => _filter = e.key)),
          ],
        ),
        const SizedBox(height: 8),
        if (shown.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Text(s.noneHere)),
        for (final i in shown)
          Card(
            child: ExpansionTile(
              leading: switch (r.outcomes[i]) {
                MockOutcome.correct => Icon(Icons.check_circle, color: Colors.green.shade700),
                MockOutcome.wrong => Icon(Icons.cancel, color: theme.colorScheme.error),
                MockOutcome.skipped => Icon(Icons.remove_circle_outline, color: theme.colorScheme.outline),
              },
              title: Text('${i + 1}. ${r.questions[i].question(lang)}'),
              subtitle: Text(
                [
                  ?r.questions[i].topic(lang),
                  if (r.secondsPerQuestion[i] != null) s.secondsShort(r.secondsPerQuestion[i]!),
                  if (r.marked.contains(i)) s.markedForReview,
                ].join(' · '),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [AnswerExplanation(question: r.questions[i], chosen: r.answers[i], lang: lang, showChosen: true)],
            ),
          ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label, this.value, this.color, {this.hint});
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Expanded(child: Text(label, style: theme.textTheme.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color)),
            ),
          ],
        ),
      ),
    );
    return hint == null ? card : Tooltip(message: hint!, child: card);
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
  );
}

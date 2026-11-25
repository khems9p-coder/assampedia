import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_models.dart';
import '../../data/practice_models.dart';
import 'mock_test_screen.dart';

/// The page before a mock test: marks, time, negative marking and the
/// general instructions, like the first page of a real exam paper.
class MockIntroScreen extends StatefulWidget {
  const MockIntroScreen({super.key, required this.set});
  final QuestionSet set;

  @override
  State<MockIntroScreen> createState() => _MockIntroScreenState();
}

class _MockIntroScreenState extends State<MockIntroScreen> {
  Future<List<Question>>? _load;
  bool _agreed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load ??= context.services.content!.questions(widget.set.id!);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final set = widget.set;
    return Scaffold(
      appBar: AppBar(
        title: Text(set.title(lang), maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: const [LanguageSwitch(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Question>>(
        future: _load,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(
              message: s.loadFailed,
              onRetry: () => setState(() => _load = context.services.content!.questions(set.id!)),
            );
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final qs = snap.data!;
          final count = qs.length;
          final custom = set.instructions(lang);
          final rules = s.mockRules(minutes: set.timeLimitMinutes ?? 0, negative: set.negativeMarks > 0);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(set.title(lang), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                            if (set.description(lang) != null) ...[
                              const SizedBox(height: 4),
                              Text(set.description(lang)!, style: theme.textTheme.bodyMedium),
                            ],
                            const SizedBox(height: 16),
                            _facts(context, count),
                            const SizedBox(height: 20),
                            _heading(context, s.generalInstructions),
                            for (var i = 0; i < rules.length; i++) _numbered(context, i + 1, rules[i]),
                            if (custom.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              _heading(context, s.testInstructions),
                              for (var i = 0; i < custom.length; i++) _numbered(context, i + 1, custom[i]),
                            ],
                            const SizedBox(height: 12),
                            _heading(context, s.paletteLegend),
                            const PaletteLegend(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Material(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CheckboxListTile(
                          value: _agreed,
                          onChanged: (v) => setState(() => _agreed = v ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(s.readInstructions),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            onPressed: !_agreed || count == 0
                                ? null
                                : () => Navigator.of(context).pushReplacement(
                                    SectionRoute(context, builder: (_) => MockTestScreen(set: set, questions: qs)),
                                  ),
                            icon: const Icon(Icons.play_arrow),
                            label: Text(count == 0 ? s.noQuestions : s.startTest),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _facts(BuildContext context, int count) {
    final s = context.s;
    final set = widget.set;
    final theme = Theme.of(context);
    final m = set.marksPerQuestion;
    final rows = <(IconData, String, String)>[
      (Icons.help_outline, s.totalQuestions, '$count'),
      (Icons.emoji_events_outlined, s.totalMarks, formatMarks(count * m)),
      (Icons.timer_outlined, s.timeAllowed, set.timeLimitMinutes != null ? s.minutes(set.timeLimitMinutes!) : s.noTimeLimit),
      (Icons.check_circle_outline, s.marksForCorrect, s.plusMarks(formatMarks(m))),
      (
        Icons.remove_circle_outline,
        s.marksForWrong,
        set.negativeMarks > 0 ? s.minusMarks(formatMarks(set.negativeMarks)) : s.noNegative,
      ),
      (Icons.radio_button_unchecked, s.marksForSkipped, '0'),
    ];
    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final r in rows)
              ListTile(
                dense: true,
                leading: Icon(r.$1, color: theme.colorScheme.primary),
                title: Text(r.$2, style: theme.textTheme.bodyLarge),
                trailing: Text(r.$3, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _heading(BuildContext context, String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
    ),
  );

  Widget _numbered(BuildContext context, int n, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 28, child: Text('$n.', style: Theme.of(context).textTheme.bodyLarge)),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45)),
        ),
      ],
    ),
  );
}

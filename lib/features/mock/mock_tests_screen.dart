import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_models.dart';
import '../../data/practice_models.dart';
import '../premium/paywall_screen.dart';
import 'mock_intro_screen.dart';

/// Every published mock test, with the reader's last score.
class MockTestsScreen extends StatefulWidget {
  const MockTestsScreen({super.key});

  @override
  State<MockTestsScreen> createState() => _MockTestsScreenState();
}

class _MockTestsScreenState extends State<MockTestsScreen> {
  Future<List<QuestionSet>>? _sets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sets ??= context.services.content?.questionSets();
  }

  void _reload() => setState(() => _sets = context.services.content?.questionSets());

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(title: Text(s.mockTests), actions: const [LanguageSwitch(), SizedBox(width: 8)]),
      body: _sets == null
          ? Center(child: Text(s.notConnected))
          : FutureBuilder<List<QuestionSet>>(
              future: _sets,
              builder: (context, snap) {
                if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: _reload);
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final all = snap.data!;
                final mocks = [
                  for (final x in all)
                    if (x.isMockTest) x,
                ];
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([context.services.progress, context.services.premium]),
                    builder: (context, _) => ListView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      children: [
                        Text(s.mockTestsHint, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        if (mocks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(child: Text(s.noMockTests)),
                          ),
                        for (final x in mocks)
                          MockTestCard(
                            set: x,
                            // Same free rule as the Practice Zone: the first 3 of each type.
                            locked: !context.services.premium.canOpen(
                              indexInGroup: all.where((y) => y.kind == x.kind).toList().indexOf(x),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/// One mock test in a list. Also usable from other screens (for example a
/// course page) to open a test.
class MockTestCard extends StatelessWidget {
  const MockTestCard({super.key, required this.set, this.locked = false});
  final QuestionSet set;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final progress = context.services.progress;
    final last = progress.last(set.id);
    final info = [
      s.questionsCount(set.questionCount),
      '${s.totalMarks}: ${formatMarks(set.totalMarks)}',
      set.timeLimitMinutes != null ? s.minutes(set.timeLimitMinutes!) : s.noTimeLimit,
      if (set.negativeMarks > 0) s.minusMarks(formatMarks(set.negativeMarks)),
    ].join(' · ');
    final lastLine = last == null
        ? null
        : [
            s.lastAttempt(formatMarks(last.marks ?? last.score.toDouble()), formatMarks(last.maxMarks ?? last.total.toDouble())),
            s.timesTaken(progress.timesTaken(set.id)),
          ].join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(Icons.timer_outlined, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(set.title(lang), style: theme.textTheme.titleMedium),
        subtitle: Text([?set.description(lang), info, ?lastLine].join('\n')),
        isThreeLine: true,
        trailing: locked ? const LockIcon() : const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(
          context,
        ).push(SectionRoute(context, builder: (_) => locked ? const PaywallScreen() : MockIntroScreen(set: set))),
      ),
    );
  }
}

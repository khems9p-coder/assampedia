import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/content_repository.dart';
import '../../data/practice_models.dart';
import 'quiz_screen.dart';

/// Today's question on the Home screen. Hidden when no daily questions exist.
class DailyQuestionCard extends StatefulWidget {
  const DailyQuestionCard({super.key});

  @override
  State<DailyQuestionCard> createState() => _DailyQuestionCardState();
}

class _DailyQuestionCardState extends State<DailyQuestionCard> {
  Future<Question?>? _q;
  int? _chosen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _q ??= context.services.content?.dailyQuestion(DateTime.now()).catchError((Object _) => null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question?>(
      future: _q,
      builder: (context, snap) {
        final q = snap.data;
        if (q == null) return const SizedBox.shrink();
        final s = context.s;
        final lang = context.lang;
        final theme = Theme.of(context);
        final options = q.options(lang);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s.dailyQuestion, style: theme.textTheme.labelLarge)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(q.question(lang), style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (var o = 0; o < options.length; o++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(44),
                          foregroundColor: _chosen == null
                              ? null
                              : o == q.correctIndex
                              ? Colors.green.shade700
                              : o == _chosen
                              ? theme.colorScheme.error
                              : null,
                        ),
                        onPressed: _chosen == null ? () => setState(() => _chosen = o) : null,
                        child: Text('${String.fromCharCode(65 + o)}. ${options[o]}'),
                      ),
                    ),
                  if (_chosen != null) AnswerExplanation(question: q, chosen: _chosen, lang: lang),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/practice_models.dart';

/// The correct option of a question in [l], or an empty string.
String answerOf(Question q, AppLang l) {
  final o = q.options(l);
  return q.correctIndex < o.length ? o[q.correctIndex] : '';
}

/// Loads a quiz's questions and shows them with [builder].
class _QuestionsLoader extends StatefulWidget {
  const _QuestionsLoader({required this.set, required this.title, required this.builder});
  final QuestionSet set;
  final String title;
  final Widget Function(BuildContext, List<Question>) builder;

  @override
  State<_QuestionsLoader> createState() => _QuestionsLoaderState();
}

class _QuestionsLoaderState extends State<_QuestionsLoader> {
  Future<List<Question>>? _qs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _qs ??= context.services.content!.questions(widget.set.id!);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            Text(
              widget.set.title(context.lang),
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: const [LanguageSwitch(), SizedBox(width: 8)],
      ),
      body: FutureBuilder<List<Question>>(
        future: _qs,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(
              message: s.loadFailed,
              onRetry: () => setState(() => _qs = context.services.content!.questions(widget.set.id!)),
            );
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          if (snap.data!.isEmpty) return Center(child: Text(s.noQuestions));
          return widget.builder(context, snap.data!);
        },
      ),
    );
  }
}

/// Flip cards: the question on the front, the answer and explanation on the back.
class FlashcardsScreen extends StatelessWidget {
  const FlashcardsScreen({super.key, required this.set});
  final QuestionSet set;

  @override
  Widget build(BuildContext context) => _QuestionsLoader(
    set: set,
    title: context.s.flashcards,
    builder: (context, qs) => _Flashcards(questions: qs),
  );
}

class _Flashcards extends StatefulWidget {
  const _Flashcards({required this.questions});
  final List<Question> questions;

  @override
  State<_Flashcards> createState() => _FlashcardsState();
}

class _FlashcardsState extends State<_Flashcards> {
  late List<Question> _cards = List.of(widget.questions);
  int _i = 0;
  bool _back = false;

  void _go(int to) => setState(() {
    _i = to;
    _back = false;
  });

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final q = _cards[_i];
    final explanation = q.get('explanation', lang);

    final face = Container(
      key: ValueKey('$_i-$_back'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _back ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _back ? scheme.primary : scheme.outlineVariant, width: 2),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_back ? s.answer : s.question, style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary)),
            const SizedBox(height: 16),
            Text(
              _back ? answerOf(q, lang) : q.question(lang),
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(height: 1.4, fontWeight: _back ? FontWeight.w700 : null),
            ),
            if (_back && explanation != null) ...[
              const SizedBox(height: 16),
              Text(explanation, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            ],
            const SizedBox(height: 20),
            Text(_back ? s.tapToSeeQuestion : s.tapToSeeAnswer, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(s.cardOf(_i + 1, _cards.length), style: theme.textTheme.labelLarge)),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _cards = List.of(_cards)..shuffle();
                    _i = 0;
                    _back = false;
                  }),
                  icon: const Icon(Icons.shuffle),
                  label: Text(s.shuffle),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _back = !_back),
                onHorizontalDragEnd: (d) {
                  final v = d.primaryVelocity ?? 0;
                  if (v < -200 && _i < _cards.length - 1) _go(_i + 1);
                  if (v > 200 && _i > 0) _go(_i - 1);
                },
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, a) => ScaleTransition(scale: Tween(begin: 0.95, end: 1.0).animate(a), child: child),
                    child: face,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _i > 0 ? () => _go(_i - 1) : null,
                  icon: const Icon(Icons.chevron_left),
                  label: Text(s.previous),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _i < _cards.length - 1 ? () => _go(_i + 1) : null,
                  icon: const Icon(Icons.chevron_right),
                  label: Text(s.next),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick revision list: each question with its answer on one line.
class OneLinersScreen extends StatelessWidget {
  const OneLinersScreen({super.key, required this.set});
  final QuestionSet set;

  @override
  Widget build(BuildContext context) => _QuestionsLoader(
    set: set,
    title: context.s.oneLiners,
    builder: (context, qs) {
      final lang = context.lang;
      final theme = Theme.of(context);
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: qs.length,
        separatorBuilder: (_, _) => const Divider(height: 20),
        itemBuilder: (context, i) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 32, child: Text('${i + 1}.', style: theme.textTheme.bodyLarge)),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  children: [
                    TextSpan(text: '${qs[i].question(lang)}  '),
                    TextSpan(
                      text: answerOf(qs[i], lang),
                      style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

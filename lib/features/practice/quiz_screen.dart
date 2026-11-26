import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/practice_models.dart';

/// Takes one quiz.
///
/// Practice quizzes show the answer and explanation after each question.
/// Timed mock tests let you move freely and show everything at the end.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.set, this.only});
  final QuestionSet set;

  /// When set, practise just these questions (for "practise the wrong ones").
  final List<Question>? only;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Future<List<Question>>? _load;
  List<Question> _qs = const [];
  final _answers = <int, int>{};
  int _i = 0;
  bool _finished = false;
  bool _newRecord = false;
  Timer? _timer;
  int _secondsLeft = 0;
  final _started = DateTime.now();

  bool get _timed => widget.set.isTimed && widget.only == null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load ??= widget.only != null ? Future.value(widget.only!) : context.services.content!.questions(widget.set.id!);
    _load!.then((qs) {
      if (!mounted || _qs.isNotEmpty) return;
      setState(() => _qs = qs);
      if (_timed && qs.isNotEmpty) _startTimer();
    }, onError: (_) {});
  }

  void _startTimer() {
    _secondsLeft = widget.set.timeLimitMinutes! * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        t.cancel();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.s.timeUp)));
        _finish();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _score => [
    for (var i = 0; i < _qs.length; i++)
      if (_answers[i] == _qs[i].correctIndex) i,
  ].length;

  void _finish() {
    if (_finished) return;
    _timer?.cancel();
    // Only full quizzes count towards progress.
    QuizAttempt? attempt;
    if (widget.only == null && widget.set.id != null) {
      attempt = QuizAttempt(
        setId: widget.set.id!,
        score: _score,
        total: _qs.length,
        at: DateTime.now(),
        seconds: DateTime.now().difference(_started).inSeconds,
      );
    }
    final progress = context.services.progress;
    setState(() {
      _finished = true;
      _newRecord = attempt != null && progress.isNewRecord(attempt);
    });
    if (attempt != null) progress.add(attempt);
  }

  Future<bool> _confirmLeave() async {
    final s = context.s;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(s.leaveQuiz),
        content: Text(s.leaveQuizHint),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(s.stay)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(s.leave)),
        ],
      ),
    );
    return ok ?? false;
  }

  String _clock(int secs) => '${(secs ~/ 60).toString().padLeft(2, '0')}:${(secs % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return PopScope(
      canPop: _finished || _answers.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        if (await _confirmLeave()) nav.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.set.title(lang), maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: const [LanguageSwitch(), SizedBox(width: 8)],
        ),
        body: FutureBuilder<List<Question>>(
          future: _load,
          builder: (context, snap) {
            if (snap.hasError) {
              return LoadError(
                message: s.loadFailed,
                onRetry: () => setState(() => _load = context.services.content!.questions(widget.set.id!)),
              );
            }
            if (!snap.hasData || (_qs.isEmpty && snap.data!.isNotEmpty)) return const Center(child: CircularProgressIndicator());
            if (_qs.isEmpty) return Center(child: Text(s.noQuestions));
            return _finished ? _result(lang) : _question(lang);
          },
        ),
      ),
    );
  }

  Widget _question(AppLang lang) {
    final s = context.s;
    final theme = Theme.of(context);
    final q = _qs[_i];
    final chosen = _answers[_i];
    final reveal = !_timed && chosen != null;
    final last = _i == _qs.length - 1;
    final options = q.options(lang);

    return Column(
      children: [
        LinearProgressIndicator(value: (_i + 1) / _qs.length),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(child: Text(s.questionOf(_i + 1, _qs.length), style: theme.textTheme.labelLarge)),
                  if (_timed)
                    Chip(
                      avatar: const Icon(Icons.timer_outlined, size: 18),
                      label: Text(s.timeLeft(_clock(_secondsLeft))),
                      backgroundColor: _secondsLeft < 60 ? theme.colorScheme.errorContainer : null,
                    ),
                ],
              ),
              if (_timed && _i == 0) Text(s.mockHint, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              Text(q.question(lang), style: theme.textTheme.titleLarge?.copyWith(height: 1.4)),
              const SizedBox(height: 16),
              for (var o = 0; o < options.length; o++)
                _OptionTile(
                  label: options[o],
                  letter: String.fromCharCode(65 + o),
                  selected: chosen == o,
                  state: !reveal
                      ? _OptionState.plain
                      : o == q.correctIndex
                      ? _OptionState.right
                      : o == chosen
                      ? _OptionState.wrong
                      : _OptionState.plain,
                  onTap: reveal ? null : () => setState(() => _answers[_i] = o),
                ),
              if (reveal) ...[const SizedBox(height: 8), AnswerExplanation(question: q, chosen: chosen, lang: lang)],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                if (_timed && _i > 0) OutlinedButton(onPressed: () => setState(() => _i--), child: Text(s.previous)),
                const Spacer(),
                if (_timed && !last) TextButton(onPressed: _finish, child: Text(s.submitTest)) else const SizedBox.shrink(),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: (!_timed && chosen == null)
                      ? null
                      : last
                      ? _finish
                      : () => setState(() => _i++),
                  child: Text(last ? (_timed ? s.submitTest : s.finish) : s.next),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _result(AppLang lang) {
    final s = context.s;
    final theme = Theme.of(context);
    final score = _score;
    final pct = (score * 100 / _qs.length).round();
    final wrong = [
      for (var i = 0; i < _qs.length; i++)
        if (_answers[i] != _qs[i].correctIndex) _qs[i],
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (_newRecord) ...[NewRecordBadge(label: s.newRecord), const SizedBox(height: 8)],
                Text(s.yourResult, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$score / ${_qs.length}', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
                Text(s.scoreLine(score, _qs.length)),
                Text(s.accuracy(pct)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(SectionRoute(context, builder: (_) => QuizScreen(set: widget.set))),
              icon: const Icon(Icons.replay),
              label: Text(s.tryAgain),
            ),
            if (wrong.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushReplacement(
                  SectionRoute(
                    context,
                    builder: (_) => QuizScreen(set: widget.set, only: wrong),
                  ),
                ),
                icon: const Icon(Icons.healing_outlined),
                label: Text(s.practiseWrong),
              ),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(s.done)),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < _qs.length; i++)
          Card(
            child: ExpansionTile(
              leading: Icon(
                _answers[i] == _qs[i].correctIndex ? Icons.check_circle : Icons.cancel,
                color: _answers[i] == _qs[i].correctIndex ? Colors.green.shade700 : theme.colorScheme.error,
              ),
              title: Text('${i + 1}. ${_qs[i].question(lang)}'),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [AnswerExplanation(question: _qs[i], chosen: _answers[i], lang: lang, showChosen: true)],
            ),
          ),
      ],
    );
  }
}

enum _OptionState { plain, right, wrong }

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.letter, required this.selected, required this.state, this.onTap});
  final String label;
  final String letter;
  final bool selected;
  final _OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final green = Colors.green.shade700;
    final color = switch (state) {
      _OptionState.right => green,
      _OptionState.wrong => scheme.error,
      _OptionState.plain => selected ? scheme.primary : scheme.outlineVariant,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: state == _OptionState.plain && !selected ? null : color.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: selected || state != _OptionState.plain ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text(letter, style: TextStyle(color: color)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
                if (state == _OptionState.right) Icon(Icons.check_circle, color: green),
                if (state == _OptionState.wrong) Icon(Icons.cancel, color: scheme.error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Right or wrong, the correct answer, and the explanation fields.
/// Shared by the quiz and the daily question card.
class AnswerExplanation extends StatelessWidget {
  const AnswerExplanation({super.key, required this.question, required this.chosen, required this.lang, this.showChosen = false});
  final Question question;
  final int? chosen;
  final AppLang lang;
  final bool showChosen;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final options = question.options(lang);
    final right = chosen == question.correctIndex;
    final correctText = question.correctIndex < options.length ? options[question.correctIndex] : '';
    Widget section(String label, String? body) => body == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
                const SizedBox(height: 2),
                Text(body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
              ],
            ),
          );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showChosen)
            Text(
              right ? s.correct : s.wrong,
              style: theme.textTheme.titleMedium?.copyWith(color: right ? Colors.green.shade700 : theme.colorScheme.error),
            ),
          if (showChosen)
            Text(
              '${s.yourAnswer}: ${chosen == null || chosen! >= options.length ? s.notAnswered : options[chosen!]}',
              style: theme.textTheme.bodyMedium,
            ),
          Text(s.rightAnswer(correctText), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          section(s.explanation, question.get('explanation', lang)),
          section(s.background, question.get('background', lang)),
          section(s.examRelevance, question.get('relevance', lang)),
          if (question.source != null && question.source!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(s.source(question.source!), style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}

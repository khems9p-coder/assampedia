import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/mock_models.dart';
import '../../data/practice_models.dart';
import 'mock_result_screen.dart';

/// Where a question stands, for the colours of the question palette.
enum PaletteState { notVisited, notAnswered, answered, marked, answeredMarked }

Color paletteColor(PaletteState p, ColorScheme scheme) => switch (p) {
  PaletteState.notVisited => scheme.surfaceContainerHighest,
  PaletteState.notAnswered => scheme.error,
  PaletteState.answered => Colors.green.shade700,
  PaletteState.marked => Colors.deepPurple,
  PaletteState.answeredMarked => Colors.deepPurple,
};

/// One numbered circle of the question palette.
class PaletteBubble extends StatelessWidget {
  const PaletteBubble({super.key, required this.label, required this.state, this.current = false, this.onTap, this.size = 40});
  final String label;
  final PaletteState state;
  final bool current;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = paletteColor(state, scheme);
    final fg = state == PaletteState.notVisited ? scheme.onSurface : Colors.white;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                shape: state == PaletteState.marked || state == PaletteState.answeredMarked ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: state == PaletteState.marked || state == PaletteState.answeredMarked ? null : BorderRadius.circular(8),
                border: Border.all(color: current ? scheme.primary : scheme.outlineVariant, width: current ? 3 : 1),
              ),
              child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
            ),
            if (state == PaletteState.answeredMarked)
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  decoration: BoxDecoration(color: Colors.green.shade700, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(2),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// What each palette colour means.
class PaletteLegend extends StatelessWidget {
  const PaletteLegend({super.key, this.counts});

  /// When given, shows how many questions are in each state.
  final Map<PaletteState, int>? counts;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final names = {
      PaletteState.answered: s.answered,
      PaletteState.notAnswered: s.notAnswered,
      PaletteState.notVisited: s.notVisited,
      PaletteState.marked: s.markedForReview,
      PaletteState.answeredMarked: s.answeredAndMarked,
    };
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        for (final e in names.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PaletteBubble(label: counts == null ? '' : '${counts![e.key] ?? 0}', state: e.key, size: 30),
              const SizedBox(width: 8),
              Flexible(child: Text(e.value)),
            ],
          ),
      ],
    );
  }
}

/// Takes a mock test: timer, question palette, mark for review, and a
/// confirmed submit. Opens the analysis afterwards.
class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key, required this.set, required this.questions, this.now = DateTime.now});
  final QuestionSet set;
  final List<Question> questions;

  /// The clock (tests pass their own).
  final DateTime Function() now;

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  final _answers = <int, int>{};
  final _marked = <int>{};
  final _visited = <int>{0};
  final _spent = <int, int>{};
  late final DateTime _started = widget.now();
  final _scaffold = GlobalKey<ScaffoldState>();
  late DateTime _enteredAt = _started;
  DateTime? _endsAt;
  Timer? _timer;
  int _i = 0;
  bool _submitted = false;
  bool _warned5 = false;
  bool _warned1 = false;

  List<Question> get _qs => widget.questions;

  @override
  void initState() {
    super.initState();
    final mins = widget.set.timeLimitMinutes;
    if (mins != null) _endsAt = _started.add(Duration(minutes: mins));
    // Measured against the clock, so the time stays right even if the phone
    // is locked for a while.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Rounded up, so a fresh 10-minute test shows 10:00 and 0 means time is up.
  int get _secondsLeft => _endsAt == null ? 0 : (_endsAt!.difference(widget.now()).inMilliseconds / 1000).ceil();
  int get _secondsUsed => widget.now().difference(_started).inSeconds;

  void _tick() {
    if (!mounted || _submitted) return;
    setState(() {});
    if (_endsAt == null) return;
    final left = _secondsLeft;
    final total = widget.set.timeLimitMinutes! * 60;
    if (left <= 0) {
      _submit(timeUp: true);
    } else if (left <= 60 && !_warned1 && total > 120) {
      _warned1 = true;
      _snack(context.s.oneMinuteLeft);
    } else if (left <= 300 && !_warned5 && total > 600) {
      _warned5 = true;
      _snack(context.s.fiveMinutesLeft);
    }
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(m)));
  }

  PaletteState _state(int i) {
    final answered = _answers.containsKey(i);
    if (_marked.contains(i)) return answered ? PaletteState.answeredMarked : PaletteState.marked;
    if (answered) return PaletteState.answered;
    return _visited.contains(i) ? PaletteState.notAnswered : PaletteState.notVisited;
  }

  Map<PaletteState, int> get _counts {
    final c = <PaletteState, int>{};
    for (var i = 0; i < _qs.length; i++) {
      c.update(_state(i), (n) => n + 1, ifAbsent: () => 1);
    }
    return c;
  }

  void _logTime() {
    final now = widget.now();
    _spent.update(_i, (s) => s + now.difference(_enteredAt).inSeconds, ifAbsent: () => now.difference(_enteredAt).inSeconds);
    _enteredAt = now;
  }

  void _go(int i) {
    if (i < 0 || i >= _qs.length) return;
    setState(() {
      _logTime();
      _i = i;
      _visited.add(i);
    });
  }

  void _toggleMark() {
    setState(() => _marked.contains(_i) ? _marked.remove(_i) : _marked.add(_i));
    // Like a real exam, marking moves on to the next question.
    if (_marked.contains(_i) && _i < _qs.length - 1) _go(_i + 1);
  }

  Future<void> _confirmSubmit() async {
    final s = context.s;
    final counts = _counts;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(s.submitConfirmTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaletteLegend(counts: counts),
              const SizedBox(height: 16),
              if (_endsAt != null) Text(s.submitConfirmTime(formatClock(_secondsLeft))),
              Text(s.submitConfirmHint),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(s.goBack)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(s.submit)),
        ],
      ),
    );
    if (ok == true) _submit();
  }

  void _submit({bool timeUp = false}) {
    if (_submitted) return;
    _submitted = true;
    _timer?.cancel();
    _logTime();
    // Close the submit dialog or palette drawer if one is open.
    Navigator.of(context).popUntil((r) => r is! PopupRoute);
    _scaffold.currentState?.closeEndDrawer();
    final used = _endsAt != null && timeUp ? widget.set.timeLimitMinutes! * 60 : _secondsUsed;
    final result = MockResult.compute(
      set: widget.set,
      questions: _qs,
      answers: _answers,
      marked: _marked,
      secondsTaken: used,
      secondsPerQuestion: _spent,
      timeUp: timeUp,
    );
    if (widget.set.id != null) context.services.progress.add(result.toAttempt(widget.now()));
    Navigator.of(context).pushReplacement(SectionRoute(context, builder: (_) => MockResultScreen(result: result)));
  }

  Future<void> _confirmLeave() async {
    final s = context.s;
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(s.leaveTest),
        content: Text(s.leaveTestHint),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(s.stay)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(s.leave)),
        ],
      ),
    );
    if (ok == true && mounted) {
      _submitted = true;
      _timer?.cancel();
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return PopScope(
      canPop: _submitted,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave();
      },
      child: Scaffold(
        key: _scaffold,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(tooltip: s.leave, icon: const Icon(Icons.close), onPressed: _confirmLeave),
          title: Text(widget.set.title(context.lang), maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            _clock(context),
            const LanguageSwitch(),
            if (!wide)
              IconButton(
                tooltip: s.questionPalette,
                icon: const Icon(Icons.grid_view),
                onPressed: () => _scaffold.currentState?.openEndDrawer(),
              ),
            const SizedBox(width: 4),
          ],
        ),
        endDrawer: wide ? null : Drawer(width: 340, child: SafeArea(child: _palette(context))),
        body: wide
            ? Row(
                children: [
                  Expanded(child: _questionArea(context)),
                  const VerticalDivider(width: 1),
                  SizedBox(width: 340, child: _palette(context)),
                ],
              )
            : _questionArea(context),
      ),
    );
  }

  Widget _clock(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final timed = _endsAt != null;
    final secs = timed ? _secondsLeft : _secondsUsed;
    final urgent = timed && secs <= 300;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        visualDensity: VisualDensity.compact,
        avatar: Icon(timed ? Icons.timer_outlined : Icons.schedule, size: 18, color: urgent ? scheme.onErrorContainer : null),
        label: Text(
          formatClock(secs),
          style: TextStyle(
            fontFeatures: const [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w700,
            color: urgent ? scheme.onErrorContainer : null,
          ),
        ),
        backgroundColor: urgent ? scheme.errorContainer : null,
      ),
    );
  }

  Widget _palette(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(s.questionPalette, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PaletteLegend(counts: _counts),
        ),
        const Divider(height: 24),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 56, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: _qs.length,
            itemBuilder: (context, i) => Center(
              child: PaletteBubble(
                label: '${i + 1}',
                state: _state(i),
                current: i == _i,
                onTap: () {
                  _go(i);
                  _scaffold.currentState?.closeEndDrawer();
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _confirmSubmit,
            icon: const Icon(Icons.send),
            label: Text(s.submitTest),
          ),
        ),
      ],
    );
  }

  Widget _questionArea(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final q = _qs[_i];
    final options = q.options(lang);
    final chosen = _answers[_i];
    final last = _i == _qs.length - 1;
    final marked = _marked.contains(_i);
    final set = widget.set;
    final neg = set.negativeMarks > 0 ? s.minusMarks(formatMarks(set.negativeMarks)) : '0';
    return Column(
      children: [
        LinearProgressIndicator(value: (_i + 1) / _qs.length),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(child: Text(s.questionOf(_i + 1, _qs.length), style: theme.textTheme.titleSmall)),
                  Text(s.marksLine(s.plusMarks(formatMarks(set.marksPerQuestion)), neg), style: theme.textTheme.bodySmall),
                ],
              ),
              if (q.topic(lang) != null) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(q.topic(lang)!, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
                ),
              ],
              const SizedBox(height: 12),
              Text(q.question(lang), style: theme.textTheme.titleLarge?.copyWith(height: 1.4)),
              const SizedBox(height: 16),
              for (var o = 0; o < options.length; o++)
                _Choice(
                  letter: String.fromCharCode(65 + o),
                  label: options[o],
                  selected: chosen == o,
                  onTap: () => setState(() => _answers[_i] = o),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Material(
            color: theme.colorScheme.surface,
            shape: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: marked ? OutlinedButton.styleFrom(backgroundColor: theme.colorScheme.primaryContainer) : null,
                          onPressed: _toggleMark,
                          icon: Icon(marked ? Icons.bookmark : Icons.bookmark_border),
                          label: Text(marked ? s.unmark : s.markForReview, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: chosen == null ? null : () => setState(() => _answers.remove(_i)),
                          icon: const Icon(Icons.backspace_outlined),
                          label: Text(s.clearAnswer, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _i == 0 ? null : () => _go(_i - 1),
                          icon: const Icon(Icons.chevron_left),
                          label: Text(s.previous),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: last
                            ? FilledButton.icon(onPressed: _confirmSubmit, icon: const Icon(Icons.send), label: Text(s.submitTest))
                            : FilledButton.icon(
                                onPressed: () => _go(_i + 1),
                                icon: const Icon(Icons.chevron_right),
                                label: Text(s.saveAndNext, maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.letter, required this.label, required this.selected, required this.onTap});
  final String letter;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.outlineVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: color, width: selected ? 2 : 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: selected ? scheme.primary : scheme.primaryContainer,
                  child: Text(letter, style: TextStyle(color: selected ? scheme.onPrimary : scheme.onSurface)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
                if (selected) Icon(Icons.radio_button_checked, color: scheme.primary) else Icon(Icons.radio_button_off, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

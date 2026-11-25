import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/practice_models.dart';

const _border = OutlineInputBorder();

Widget _pair(BuildContext context, Widget a, Widget b) => MediaQuery.sizeOf(context).width >= 720
    ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      )
    : Column(children: [a, const SizedBox(height: 8), b]);

Widget _heading(BuildContext context, String t) => Padding(
  padding: const EdgeInsets.only(top: 20, bottom: 8),
  child: Text(t, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
);

String _either(String Function(AppLang) f) {
  final en = f(AppLang.english);
  return en.isNotEmpty ? en : f(AppLang.assamese);
}

String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

Future<bool> _confirmDelete(BuildContext context, String title, String body) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    ) ??
    false;

/// Admin list of all practice sets (quizzes), including drafts.
class AdminPracticeScreen extends StatefulWidget {
  const AdminPracticeScreen({super.key});

  @override
  State<AdminPracticeScreen> createState() => _AdminPracticeScreenState();
}

class _AdminPracticeScreenState extends State<AdminPracticeScreen> {
  late Future<List<QuestionSet>> _sets;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sets = context.services.admin!.questionSets();
  }

  void _reload() => setState(() => _sets = context.services.admin!.questionSets());

  Future<void> _newSet(int position) async {
    final saved = await Navigator.of(context).push<QuestionSet>(
      SectionRoute(context, 
        builder: (_) => SetEditorScreen(set: QuestionSet(position: position)),
      ),
    );
    if (saved != null && mounted) {
      _reload();
      await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminQuestionListScreen(set: saved)));
      if (mounted) _reload();
    }
  }

  Future<void> _newMock(int position) async {
    final saved = await Navigator.of(context).push<QuestionSet>(
      SectionRoute(
        context,
        builder: (_) => SetEditorScreen(
          set: QuestionSet(position: position, kind: QuizKind.mock, level: QuizLevel.competitive, timeLimitMinutes: 60),
        ),
      ),
    );
    if (saved != null && mounted) {
      _reload();
      await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminQuestionListScreen(set: saved)));
      if (mounted) _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Practice Zone')),
      body: FutureBuilder<List<QuestionSet>>(
        future: _sets,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final sets = snap.data!;
          final nextPosition = sets.isEmpty ? 1 : sets.map((x) => x.position).reduce((a, b) => a > b ? a : b) + 1;
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _newSet(nextPosition),
              icon: const Icon(Icons.add),
              label: const Text('Add quiz'),
            ),
            body: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'A quiz is a group of questions. Create the quiz first, then add its questions. '
                    'Use "Daily GK challenge" quizzes for the question shown on the Home screen (a different one each day).',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => _newMock(nextPosition),
                      icon: const Icon(Icons.timer_outlined),
                      label: const Text('Add mock test'),
                    ),
                  ),
                ),
                if (sets.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('No quizzes yet.')),
                for (final k in QuizKind.values)
                  if (sets.any((x) => x.kind == k)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(
                        k.nameEn,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    for (final x in sets.where((x) => x.kind == k))
                      ListTile(
                        leading: Icon(x.isTimed ? Icons.timer_outlined : Icons.quiz_outlined),
                        title: Text(_either(x.title)),
                        subtitle: Text([x.level.nameEn, '${x.questionCount} questions', if (!x.isPublished) 'Hidden (draft)'].join(' · ')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminQuestionListScreen(set: x)));
                          if (mounted) _reload();
                        },
                      ),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Title, kind, level and time limit of one quiz.
class SetEditorScreen extends StatefulWidget {
  const SetEditorScreen({super.key, required this.set});
  final QuestionSet set;

  @override
  State<SetEditorScreen> createState() => _SetEditorScreenState();
}

class _SetEditorScreenState extends State<SetEditorScreen> {
  late final Map<String, TextEditingController> _text = {
    for (final f in QuestionSet.textFields)
      for (final l in AppLang.values) '${f}_${l.code}': TextEditingController(text: widget.set.text['${f}_${l.code}'] ?? ''),
  };
  late final _minutes = TextEditingController(text: widget.set.timeLimitMinutes?.toString() ?? '');
  late final _marks = TextEditingController(text: _num(widget.set.marksPerQuestion));
  late final _negative = TextEditingController(text: _num(widget.set.negativeMarks));
  late QuizKind _kind = widget.set.kind;
  late QuizLevel _level = widget.set.level;
  late bool _published = widget.set.isPublished;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [..._text.values, _minutes, _marks, _negative]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _save() async {
    if (_text['title_en']!.text.trim().isEmpty && _text['title_as']!.text.trim().isEmpty) {
      return _snack('Write a title in at least one language.');
    }
    final m = _minutes.text.trim();
    final minutes = m.isEmpty ? null : int.tryParse(m);
    if (m.isNotEmpty && (minutes == null || minutes < 1 || minutes > 300)) {
      return _snack('Time limit: a number of minutes from 1 to 300, or leave it empty.');
    }
    final isMock = _kind == QuizKind.mock;
    if (isMock && minutes == null) return _snack('A mock test needs a time limit in minutes.');
    final marks = double.tryParse(_marks.text.trim().replaceAll(',', '.'));
    final negative = double.tryParse(_negative.text.trim().isEmpty ? '0' : _negative.text.trim().replaceAll(',', '.'));
    if (isMock && (marks == null || marks <= 0 || marks > 100)) {
      return _snack('Marks for a right answer: a number above 0, for example 1 or 2.');
    }
    if (isMock && (negative == null || negative < 0 || negative > (marks ?? 1))) {
      return _snack('Marks taken away for a wrong answer: 0 (no negative marking) or a number such as 0.25, not more than the marks for a right answer.');
    }
    setState(() => _saving = true);
    try {
      final saved = await context.services.admin!.saveSet(
        QuestionSet(
          id: widget.set.id,
          kind: _kind,
          level: _level,
          text: {
            for (final e in _text.entries)
              if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
          },
          contentId: widget.set.contentId,
          timeLimitMinutes: minutes,
          position: widget.set.position,
          isPublished: _published,
          marksPerQuestion: isMock ? marks! : widget.set.marksPerQuestion,
          negativeMarks: isMock ? negative! : widget.set.negativeMarks,
          slug: widget.set.slug,
        ),
      );
      if (mounted) Navigator.of(context).pop(saved);
    } catch (e) {
      _snack('Not saved: $e');
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.set.id == null ? (_kind == QuizKind.mock ? 'New mock test' : 'New quiz') : 'Edit quiz'),
        actions: [
          FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          _pair(
            context,
            TextField(
              controller: _text['title_as'],
              decoration: const InputDecoration(labelText: 'Quiz title (অসমীয়া)', border: _border),
            ),
            TextField(
              controller: _text['title_en'],
              decoration: const InputDecoration(labelText: 'Quiz title (English)', border: _border),
            ),
          ),
          const SizedBox(height: 12),
          _pair(
            context,
            TextField(
              controller: _text['description_as'],
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Short description (অসমীয়া)', border: _border),
            ),
            TextField(
              controller: _text['description_en'],
              maxLines: null,
              decoration: const InputDecoration(labelText: 'Short description (English)', border: _border),
            ),
          ),
          _heading(context, 'Type and level'),
          DropdownButtonFormField<QuizKind>(
            initialValue: _kind,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Type of quiz', border: _border),
            items: [for (final k in QuizKind.values) DropdownMenuItem(value: k, child: Text(k.nameEn))],
            onChanged: (k) => setState(() => _kind = k ?? _kind),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<QuizLevel>(
            initialValue: _level,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Difficulty level', border: _border),
            items: [for (final l in QuizLevel.values) DropdownMenuItem(value: l, child: Text(l.nameEn))],
            onChanged: (l) => setState(() => _level = l ?? _level),
          ),
          const SizedBox(height: 12),
          if (_kind != QuizKind.mock)
            TextField(
              controller: _minutes,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Time limit in minutes (optional)',
                helperText: 'Leave empty for a practice quiz: readers then see the answer after each question. '
                    'With a time limit it is taken like a mock test.',
                border: _border,
              ),
            ),
          if (_kind == QuizKind.mock) ...[
            _heading(context, 'Mock test settings'),
            const Text(
              'Readers see these on the instructions page before the test starts. '
              'The timer submits the test by itself when the time is up.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _minutes,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Time limit in minutes', helperText: 'For example 60.', border: _border),
            ),
            const SizedBox(height: 12),
            _pair(
              context,
              TextField(
                controller: _marks,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Marks for each right answer',
                  helperText: 'For example 1 or 2.',
                  border: _border,
                ),
              ),
              TextField(
                controller: _negative,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Marks taken away for each wrong answer',
                  helperText: '0 means no negative marking. 0.25 takes away a quarter mark. Check the real exam notice for its rule.',
                  helperMaxLines: 2,
                  border: _border,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _pair(
              context,
              TextField(
                controller: _text['instructions_as'],
                maxLines: null,
                minLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Extra instructions (অসমীয়া), one per line',
                  border: _border,
                ),
              ),
              TextField(
                controller: _text['instructions_en'],
                maxLines: null,
                minLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Extra instructions (English), one per line',
                  helperText: 'Optional. The general rules (timer, palette, marking) are always shown.',
                  helperMaxLines: 2,
                  border: _border,
                ),
              ),
            ),
          ],
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show to readers'),
            subtitle: const Text('Leave off until every question has been checked.'),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
        ],
      ),
    );
  }
}

/// The questions of one quiz.
class AdminQuestionListScreen extends StatefulWidget {
  const AdminQuestionListScreen({super.key, required this.set});
  final QuestionSet set;

  @override
  State<AdminQuestionListScreen> createState() => _AdminQuestionListScreenState();
}

class _AdminQuestionListScreenState extends State<AdminQuestionListScreen> {
  late QuestionSet _set = widget.set;
  late Future<List<Question>> _qs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _qs = context.services.admin!.questions(_set.id!);
  }

  void _reload() => setState(() => _qs = context.services.admin!.questions(_set.id!));

  Future<void> _edit(Question q) async {
    final changed = await Navigator.of(context).push<bool>(SectionRoute(context, builder: (_) => QuestionEditorScreen(question: q)));
    if (changed == true && mounted) _reload();
  }

  Future<void> _editSet() async {
    final saved = await Navigator.of(context).push<QuestionSet>(SectionRoute(context, builder: (_) => SetEditorScreen(set: _set)));
    if (saved != null && mounted) setState(() => _set = saved);
  }

  Future<void> _deleteSet() async {
    if (!await _confirmDelete(context, 'Delete this quiz?', 'The quiz and all its questions will be deleted. This cannot be undone.')) {
      return;
    }
    if (!mounted) return;
    try {
      await context.services.admin!.deleteSet(_set.id!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not deleted: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_either(_set.title), maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(tooltip: 'Delete quiz', onPressed: _deleteSet, icon: const Icon(Icons.delete_outline)),
          IconButton(tooltip: 'Edit quiz details', onPressed: _editSet, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: _qs,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final qs = snap.data!;
          final next = qs.isEmpty ? 1 : qs.map((q) => q.position).reduce((a, b) => a > b ? a : b) + 1;
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _edit(Question(setId: _set.id!, position: next, correctIndex: 0)),
              icon: const Icon(Icons.add),
              label: const Text('Add question'),
            ),
            body: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                ListTile(
                  title: Text('${_set.kind.nameEn} · ${_set.level.nameEn}'),
                  subtitle: Text(
                    [
                      if (_set.isTimed) 'Timed: ${_set.timeLimitMinutes} min' else 'Practice (answers shown after each question)',
                      if (_set.isMockTest) '+${_num(_set.marksPerQuestion)} right, −${_num(_set.negativeMarks)} wrong',
                      _set.isPublished ? 'Shown to readers' : 'Hidden (draft)',
                    ].join(' · '),
                  ),
                ),
                const Divider(),
                if (qs.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('No questions yet. Tap "Add question".')),
                for (var i = 0; i < qs.length; i++)
                  ListTile(
                    leading: CircleAvatar(radius: 14, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
                    title: Text(_either(qs[i].question), maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      [
                        if (qs[i].text['question_as'] == null) 'English only',
                        if (qs[i].text['question_en'] == null) 'Assamese only',
                        if (qs[i].get('explanation', AppLang.english) == null) 'No explanation yet',
                        if (_set.isMockTest) qs[i].get('topic', AppLang.english) ?? 'No topic',
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.edit_outlined),
                    onTap: () => _edit(qs[i]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Opt {
  _Opt(String as, String en) : as = TextEditingController(text: as), en = TextEditingController(text: en);
  final TextEditingController as;
  final TextEditingController en;
  TextEditingController of(AppLang l) => l == AppLang.assamese ? as : en;
  void dispose() {
    as.dispose();
    en.dispose();
  }
}

/// One multiple-choice question in both languages.
class QuestionEditorScreen extends StatefulWidget {
  const QuestionEditorScreen({super.key, required this.question});
  final Question question;

  @override
  State<QuestionEditorScreen> createState() => _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends State<QuestionEditorScreen> {
  late final Question _q = widget.question;
  late final Map<String, TextEditingController> _text = {
    for (final f in Question.textFields)
      for (final l in AppLang.values) '${f}_${l.code}': TextEditingController(text: _q.text['${f}_${l.code}'] ?? ''),
  };
  late final _source = TextEditingController(text: _q.source ?? '');
  late final List<_Opt> _opts = [
    for (var i = 0; i < _optionCount; i++)
      _Opt(i < (_q.optionsAs?.length ?? 0) ? _q.optionsAs![i] : '', i < (_q.optionsEn?.length ?? 0) ? _q.optionsEn![i] : ''),
  ];
  late int _correct = _q.correctIndex;
  bool _saving = false;

  int get _optionCount {
    final n = [_q.optionsAs?.length ?? 0, _q.optionsEn?.length ?? 0].reduce((a, b) => a > b ? a : b);
    return n < 2 ? 4 : n;
  }

  bool get _isNew => _q.id == null;

  @override
  void dispose() {
    for (final c in [..._text.values, _source]) {
      c.dispose();
    }
    for (final o in _opts) {
      o.dispose();
    }
    super.dispose();
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  String _clean(TextEditingController c) => c.text.trim();

  Future<void> _save() async {
    final langs = [
      for (final l in AppLang.values)
        if (_clean(_text['question_${l.code}']!).isNotEmpty) l,
    ];
    if (langs.isEmpty) return _snack('Write the question in at least one language.');
    for (final l in langs) {
      if (_opts.any((o) => _clean(o.of(l)).isEmpty)) {
        return _snack('Fill in every option in ${l.label}, or remove the empty option.');
      }
    }
    if (_correct >= _opts.length) return _snack('Choose the correct option.');
    setState(() => _saving = true);
    try {
      await context.services.admin!.saveQuestion(
        Question(
          id: _q.id,
          setId: _q.setId,
          position: _q.position,
          text: {
            for (final e in _text.entries)
              if (_clean(e.value).isNotEmpty) e.key: _clean(e.value),
          },
          optionsAs: langs.contains(AppLang.assamese) ? [for (final o in _opts) _clean(o.as)] : null,
          optionsEn: langs.contains(AppLang.english) ? [for (final o in _opts) _clean(o.en)] : null,
          correctIndex: _correct,
          source: _clean(_source).isEmpty ? null : _clean(_source),
        ),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _snack('Not saved: $e');
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    if (!await _confirmDelete(context, 'Delete this question?', 'This cannot be undone.') || !mounted) return;
    try {
      await context.services.admin!.deleteQuestion(_q.id!);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _snack('Not deleted: $e');
    }
  }

  Widget _bilingual(String field, String label, {int minLines = 2}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: _pair(
      context,
      TextField(
        controller: _text['${field}_as'],
        maxLines: null,
        minLines: minLines,
        decoration: InputDecoration(labelText: '$label (অসমীয়া)', border: _border),
      ),
      TextField(
        controller: _text['${field}_en'],
        maxLines: null,
        minLines: minLines,
        decoration: InputDecoration(labelText: '$label (English)', border: _border),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New question' : 'Edit question'),
        actions: [
          if (!_isNew) IconButton(tooltip: 'Delete', onPressed: _delete, icon: const Icon(Icons.delete_outline)),
          FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          const Text('Only use facts you have checked in a reliable source. Write both languages if you can.'),
          _heading(context, 'Question'),
          _bilingual('question', 'Question'),
          _bilingual('topic', 'Topic, e.g. History (for the mock test analysis)', minLines: 1),
          _heading(context, 'Options (tap the circle next to the correct one)'),
          for (var i = 0; i < _opts.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: 'Mark as correct',
                    onPressed: () => setState(() => _correct = i),
                    icon: Icon(
                      _correct == i ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: _correct == i ? Colors.green.shade700 : scheme.outline,
                    ),
                  ),
                  Expanded(
                    child: _pair(
                      context,
                      TextField(
                        controller: _opts[i].as,
                        decoration: InputDecoration(labelText: 'Option ${String.fromCharCode(65 + i)} (অসমীয়া)', border: _border),
                      ),
                      TextField(
                        controller: _opts[i].en,
                        decoration: InputDecoration(labelText: 'Option ${String.fromCharCode(65 + i)} (English)', border: _border),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remove option',
                    onPressed: _opts.length <= 2
                        ? null
                        : () => setState(() {
                            _opts.removeAt(i).dispose();
                            if (_correct == i) {
                              _correct = 0;
                            } else if (_correct > i) {
                              _correct--;
                            }
                          }),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                ],
              ),
            ),
          if (_opts.length < 6)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _opts.add(_Opt('', ''))),
                icon: const Icon(Icons.add),
                label: const Text('Add option'),
              ),
            ),
          _heading(context, 'Answer details'),
          _bilingual('explanation', 'Detailed explanation', minLines: 3),
          _bilingual('background', 'Relevant background'),
          _bilingual('relevance', 'Examination relevance'),
          TextField(
            controller: _source,
            decoration: const InputDecoration(
              labelText: 'Source (optional)',
              helperText: 'For example: the book or official site you checked, or "APSC CCE Prelims, year" for a previous-year question.',
              border: _border,
            ),
          ),
        ],
      ),
    );
  }
}

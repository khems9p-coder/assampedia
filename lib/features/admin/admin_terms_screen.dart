import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';

/// Admin list of dictionary terms.
class AdminTermsScreen extends StatefulWidget {
  const AdminTermsScreen({super.key});

  @override
  State<AdminTermsScreen> createState() => _AdminTermsScreenState();
}

class _AdminTermsScreenState extends State<AdminTermsScreen> {
  late Future<List<Term>> _terms;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _terms = context.services.admin!.terms();
  }

  void _reload() {
    context.services.refreshTerms();
    setState(() => _terms = context.services.admin!.terms());
  }

  Future<void> _edit([Term? t]) async {
    final changed = await Navigator.of(context).push<bool>(SectionRoute(context, builder: (_) => TermEditorScreen(term: t)));
    if (changed == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Dictionary')),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(), icon: const Icon(Icons.add), label: const Text('Add term')),
      body: FutureBuilder<List<Term>>(
        future: _terms,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return ListView(padding: const EdgeInsets.only(bottom: 96), children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Add a word once here. Then, in a chapter, use the "Insert dictionary term" button on a paragraph '
                  'so readers can tap the word to see its meaning.'),
            ),
            if (list.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('No terms yet.')),
            for (final t in list)
              ListTile(
                title: Text(t.termEn ?? t.slug),
                subtitle: Text([?t.termAs, if (!t.isPublished) 'Hidden'].join(' · ')),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _edit(t),
              ),
          ]);
        },
      ),
    );
  }
}

/// Add or edit one term in both languages.
class TermEditorScreen extends StatefulWidget {
  const TermEditorScreen({super.key, this.term});
  final Term? term;

  @override
  State<TermEditorScreen> createState() => _TermEditorScreenState();
}

class _TermEditorScreenState extends State<TermEditorScreen> {
  late final _slug = TextEditingController(text: widget.term?.slug ?? '');
  late final _termEn = TextEditingController(text: widget.term?.termEn ?? '');
  late final _termAs = TextEditingController(text: widget.term?.termAs ?? '');
  late final _meaningEn = TextEditingController(text: widget.term?.meaningEn ?? '');
  late final _meaningAs = TextEditingController(text: widget.term?.meaningAs ?? '');
  late bool _published = widget.term?.isPublished ?? true;
  bool _saving = false;

  bool get _isNew => widget.term == null;

  @override
  void dispose() {
    for (final c in [_slug, _termEn, _termAs, _meaningEn, _meaningAs]) {
      c.dispose();
    }
    super.dispose();
  }

  static String makeSlug(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');

  String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _save() async {
    if (_clean(_termEn) == null && _clean(_termAs) == null) {
      _snack('Write the word in at least one language.');
      return;
    }
    if (_isNew && _slug.text.trim().isEmpty) _slug.text = makeSlug(_termEn.text);
    final slug = _slug.text.trim();
    if (!RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$').hasMatch(slug)) {
      _snack('Short name: use English letters, numbers and dashes only (for example ahom-kingdom).');
      return;
    }
    setState(() => _saving = true);
    try {
      await context.services.admin!.saveTerm(Term(
        slug: slug,
        termEn: _clean(_termEn),
        termAs: _clean(_termAs),
        meaningEn: _clean(_meaningEn),
        meaningAs: _clean(_meaningAs),
        isPublished: _published,
      ));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _snack('Not saved: $e');
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this term?'),
        content: const Text('Chapters that use it will show the plain word without a meaning. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await context.services.admin!.deleteTerm(widget.term!.slug);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _snack('Not deleted: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    Widget pair(Widget a, Widget b) => wide
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: a), const SizedBox(width: 12), Expanded(child: b)])
        : Column(children: [a, const SizedBox(height: 12), b]);
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New term' : 'Edit term'),
        actions: [
          if (!_isNew) IconButton(tooltip: 'Delete', onPressed: _delete, icon: const Icon(Icons.delete_outline)),
          FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        pair(
          TextField(controller: _termAs, decoration: const InputDecoration(labelText: 'Word in অসমীয়া', border: OutlineInputBorder())),
          TextField(controller: _termEn, decoration: const InputDecoration(labelText: 'Word in English', border: OutlineInputBorder())),
        ),
        const SizedBox(height: 12),
        pair(
          TextField(
            controller: _meaningAs,
            maxLines: null,
            minLines: 3,
            decoration: const InputDecoration(labelText: 'Meaning in অসমীয়া', border: OutlineInputBorder()),
          ),
          TextField(
            controller: _meaningEn,
            maxLines: null,
            minLines: 3,
            decoration: const InputDecoration(labelText: 'Meaning in English', border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _slug,
          enabled: _isNew,
          decoration: const InputDecoration(
            labelText: 'Short name (used inside chapters)',
            helperText: 'Made from the English word if left empty. Cannot be changed later.',
            border: OutlineInputBorder(),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show to readers'),
          value: _published,
          onChanged: (v) => setState(() => _published = v),
        ),
      ]),
    );
  }
}

/// Lets the admin pick a term; returns its short name.
Future<Term?> pickTerm(BuildContext context) {
  return showModalBottomSheet<Term>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const _TermPicker(),
  );
}

class _TermPicker extends StatefulWidget {
  const _TermPicker();

  @override
  State<_TermPicker> createState() => _TermPickerState();
}

class _TermPickerState extends State<_TermPicker> {
  late final Future<List<Term>> _terms = context.services.admin!.terms();
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: FutureBuilder<List<Term>>(
        future: _terms,
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = [for (final t in snap.data!) if (_filter.isEmpty || termMatches(t, _filter)) t];
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Find a term', border: OutlineInputBorder()),
                onChanged: (v) => setState(() => _filter = v.trim()),
              ),
            ),
            if (snap.data!.isEmpty)
              const Padding(padding: EdgeInsets.all(16), child: Text('No terms yet. Add them in Admin → Dictionary terms first.')),
            Expanded(
              child: ListView(children: [
                for (final t in list)
                  ListTile(
                    title: Text(t.termEn ?? t.slug),
                    subtitle: Text(t.termAs ?? ''),
                    onTap: () => Navigator.of(context).pop(t),
                  ),
              ]),
            ),
          ]);
        },
      ),
    );
  }
}

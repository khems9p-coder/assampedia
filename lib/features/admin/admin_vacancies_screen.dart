import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/jobs_models.dart';
import '../../data/models.dart';
import '../jobs/vacancy_widgets.dart';

/// Admin list of all job vacancies, including drafts.
class AdminVacanciesScreen extends StatefulWidget {
  const AdminVacanciesScreen({super.key});

  @override
  State<AdminVacanciesScreen> createState() => _AdminVacanciesScreenState();
}

class _AdminVacanciesScreenState extends State<AdminVacanciesScreen> {
  late Future<List<Vacancy>> _list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _list = context.services.admin!.vacancies();
  }

  void _reload() => setState(() => _list = context.services.admin!.vacancies());

  Future<void> _edit([Vacancy? v]) async {
    final changed = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => VacancyEditorScreen(vacancy: v)));
    if (changed == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Job vacancies')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('Add vacancy'),
      ),
      body: FutureBuilder<List<Vacancy>>(
        future: _list,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'Copy details only from the official notification. Readers see a vacancy only after you switch on '
                    '"Show to readers". Its status (open, closing soon, closed) is worked out from the dates automatically.',
                  ),
                ),
                if (list.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('No vacancies yet.')),
                for (final v in list)
                  ListTile(
                    title: Text(v.post(AppLang.english).isEmpty ? v.post(AppLang.assamese) : v.post(AppLang.english)),
                    subtitle: Text(
                      [
                        v.get('organisation', AppLang.english) ?? '',
                        'Last date ${formatDate(v.closingDate)}',
                        if (!v.isPublished) 'Hidden (draft)',
                      ].where((e) => e.isNotEmpty).join(' · '),
                    ),
                    trailing: StatusChip(status: v.status()),
                    onTap: () => _edit(v),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Labels for the bilingual text fields, in the order the form shows them.
const _fieldLabels = {
  'post': 'Name of the post',
  'organisation': 'Organisation / recruiting body',
  'department': 'Department',
  'qualification': 'Educational qualification',
  'age_limit': 'Age limit',
  'pay': 'Pay scale / salary',
  'fee': 'Application fee',
  'selection': 'Selection process',
  'notes': 'Other notes',
};

const _stages = {
  'notification': 'Notification / applications (normal)',
  'admit_card': 'Admit card released',
  'exam_scheduled': 'Examination scheduled',
  'result': 'Result declared',
};

/// Add or edit one vacancy, with every text field in both languages.
class VacancyEditorScreen extends StatefulWidget {
  const VacancyEditorScreen({super.key, this.vacancy});
  final Vacancy? vacancy;

  @override
  State<VacancyEditorScreen> createState() => _VacancyEditorScreenState();
}

class _VacancyEditorScreenState extends State<VacancyEditorScreen> {
  late final Vacancy? _v = widget.vacancy;
  late final Map<String, TextEditingController> _text = {
    for (final f in Vacancy.textFields)
      for (final l in AppLang.values) '${f}_${l.code}': TextEditingController(text: _v?.text['${f}_${l.code}'] ?? ''),
  };
  late final _state = TextEditingController(text: _v?.state ?? 'Assam');
  late final _location = TextEditingController(text: _v?.location ?? '');
  late final _count = TextEditingController(text: _v?.count?.toString() ?? '');
  late final _notification = TextEditingController(text: _v?.notificationUrl ?? '');
  late final _apply = TextEditingController(text: _v?.applyUrl ?? '');
  late JobCategory _category = _v?.category ?? JobCategory.assam;
  late String _stage = _v?.stage ?? 'notification';
  late DateTime? _start = _v?.startDate;
  late DateTime? _closing = _v?.closingDate;
  late DateTime? _verified = _v?.lastVerified ?? DateTime.now();
  late String? _syllabusId = _v?.syllabusContentId;
  late bool _published = _v?.isPublished ?? false;
  bool _saving = false;

  /// Exam syllabus pages the admin can link to.
  late final Future<List<ChapterSummary>> _examPages = _loadExamPages();

  bool get _isNew => _v?.id == null;

  Future<List<ChapterSummary>> _loadExamPages() async {
    final admin = context.services.admin!;
    final cats = (await admin.categories()).where((c) => c.section == 'exam');
    return [for (final c in cats) ...await admin.chapters(c.id)];
  }

  @override
  void dispose() {
    for (final c in [..._text.values, _state, _location, _count, _notification, _apply]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  static final _url = RegExp(r'^https?://\S+$');

  Future<void> _save() async {
    if (_clean(_text['post_en']!) == null && _clean(_text['post_as']!) == null) {
      return _snack('Write the name of the post in at least one language.');
    }
    if (_closing == null) return _snack('Choose the last date to apply.');
    if (_start != null && _start!.isAfter(_closing!)) return _snack('The start date must be on or before the last date.');
    if (_verified == null) return _snack('Choose the date you last checked the official notification.');
    final notification = _notification.text.trim();
    if (!_url.hasMatch(notification)) return _snack('Add the official notification link (starting with https://).');
    final apply = _clean(_apply);
    if (apply != null && !_url.hasMatch(apply)) return _snack('The apply link must start with https://');
    final count = _clean(_count);
    if (count != null && int.tryParse(count) == null) return _snack('Number of posts: digits only, or leave it empty.');

    setState(() => _saving = true);
    try {
      await context.services.admin!.saveVacancy(
        Vacancy(
          id: _v?.id,
          category: _category,
          text: {
            for (final e in _text.entries)
              if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
          },
          state: _clean(_state),
          location: _clean(_location),
          count: count == null ? null : int.parse(count),
          startDate: _start,
          closingDate: _closing!,
          stage: _stage,
          notificationUrl: notification,
          applyUrl: apply,
          syllabusContentId: _syllabusId,
          lastVerified: _verified!,
          isPublished: _published,
        ),
      );
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
        title: const Text('Delete this vacancy?'),
        content: const Text('It will be removed for all readers. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await context.services.admin!.deleteVacancy(_v!.id!);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _snack('Not deleted: $e');
    }
  }

  Widget _date(String label, DateTime? value, ValueChanged<DateTime?> set, {bool required = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event_outlined),
      title: Text(required ? '$label *' : label),
      subtitle: Text(value == null ? (required ? 'Required. Tap to choose.' : 'Not set') : formatDate(value)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null && !required)
            IconButton(tooltip: 'Clear', onPressed: () => setState(() => set(null)), icon: const Icon(Icons.clear)),
          const Icon(Icons.edit_calendar_outlined),
        ],
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: DateTime(2000),
          lastDate: DateTime(now.year + 3, 12, 31),
        );
        if (picked != null) setState(() => set(picked));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    Widget pair(Widget a, Widget b) => wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: a),
              const SizedBox(width: 12),
              Expanded(child: b),
            ],
          )
        : Column(children: [a, const SizedBox(height: 8), b]);
    Widget heading(String t) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(t, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
    const border = OutlineInputBorder();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New vacancy' : 'Edit vacancy'),
        actions: [
          if (!_isNew) IconButton(tooltip: 'Delete', onPressed: _delete, icon: const Icon(Icons.delete_outline)),
          FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: const Text('Save')),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
        children: [
          const Text(
            'Fields marked * are required. Copy every detail from the official notification; leave a field empty if it is not given.',
          ),
          heading('Official links'),
          TextField(
            controller: _notification,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Official notification link (PDF or page) *',
              hintText: 'https://...',
              border: border,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _apply,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'Official apply-online link',
              helperText: 'Readers see the Apply button only while applications are open.',
              border: border,
            ),
          ),
          heading('Category and place'),
          DropdownButtonFormField<JobCategory>(
            initialValue: _category,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Job category *', border: border),
            items: [for (final c in JobCategory.values) DropdownMenuItem(value: c, child: Text(c.nameEn))],
            onChanged: (c) => setState(() => _category = c ?? _category),
          ),
          const SizedBox(height: 8),
          pair(
            TextField(
              controller: _state,
              decoration: const InputDecoration(labelText: 'State', border: border),
            ),
            TextField(
              controller: _location,
              decoration: const InputDecoration(labelText: 'Job location', border: border),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _count,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Number of posts', border: border),
          ),
          heading('Dates and stage'),
          _date('Application start date', _start, (d) => _start = d),
          _date('Last date to apply', _closing, (d) => _closing = d, required: true),
          _date('Last checked against the official notification', _verified, (d) => _verified = d, required: true),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _stage,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Recruitment stage',
              helperText: 'Change this when the admit card, exam date or result is announced.',
              border: border,
            ),
            items: [for (final e in _stages.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
            onChanged: (s) => setState(() => _stage = s ?? _stage),
          ),
          heading('Details (অসমীয়া and English)'),
          for (final f in Vacancy.textFields) ...[
            pair(
              TextField(
                controller: _text['${f}_as'],
                maxLines: null,
                decoration: InputDecoration(labelText: '${_fieldLabels[f]} (অসমীয়া)${f == 'post' ? ' *' : ''}', border: border),
              ),
              TextField(
                controller: _text['${f}_en'],
                maxLines: null,
                decoration: InputDecoration(labelText: '${_fieldLabels[f]} (English)${f == 'post' ? ' *' : ''}', border: border),
              ),
            ),
            const SizedBox(height: 12),
          ],
          heading('Exam syllabus page'),
          FutureBuilder<List<ChapterSummary>>(
            future: _examPages,
            builder: (context, snap) {
              if (snap.hasError) return Text('Could not load exam pages: ${snap.error}');
              if (!snap.hasData) return const LinearProgressIndicator();
              final pages = snap.data!;
              final known = _syllabusId == null || pages.any((p) => p.id == _syllabusId);
              return DropdownButtonFormField<String?>(
                initialValue: known ? _syllabusId : null,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Link to a syllabus page (optional)',
                  helperText: 'Pages from the Exam syllabus library.',
                  border: border,
                ),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('None')),
                  for (final p in pages)
                    DropdownMenuItem<String?>(
                      value: p.id,
                      child: Text(p.title(AppLang.english), overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (id) => setState(() => _syllabusId = id),
              );
            },
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show to readers'),
            subtitle: const Text('Leave off while you are still checking the details.'),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
        ],
      ),
    );
  }
}

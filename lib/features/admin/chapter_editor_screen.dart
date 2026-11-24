import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../data/admin_repository.dart';
import '../../data/models.dart';
import '../jobs/vacancy_widgets.dart';
import '../reader/block_view.dart';
import '../reader/reader_screen.dart';
import 'admin_terms_screen.dart';
import 'section_templates.dart';

/// One paragraph/box being edited, with its Assamese and English text side by side.
class _EditBlock {
  _EditBlock({required this.key, this.type = BlockType.paragraph, this.style = BlockStyle.normal, String as = '', String en = '', String image = ''})
      : as = TextEditingController(text: as),
        en = TextEditingController(text: en),
        image = TextEditingController(text: image);

  final String key;
  BlockType type;
  BlockStyle style;
  final TextEditingController as;
  final TextEditingController en;
  final TextEditingController image;

  TextEditingController text(AppLang l) => l == AppLang.assamese ? as : en;

  void dispose() {
    as.dispose();
    en.dispose();
    image.dispose();
  }
}

/// The title, summary, sources and status of one language.
class _EditVersion {
  final title = TextEditingController();
  final summary = TextEditingController();
  final sources = TextEditingController();
  String? lastChecked;
  bool published = false;

  void dispose() {
    title.dispose();
    summary.dispose();
    sources.dispose();
  }
}

/// Add or edit a chapter in both languages, preview it, then save.
class ChapterEditorScreen extends StatefulWidget {
  const ChapterEditorScreen({super.key, required this.category, this.contentId, this.newPosition = 0});
  final Category category;
  final String? contentId;
  final int newPosition;

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  final _slug = TextEditingController();
  final _official = TextEditingController();
  final _notification = TextEditingController();
  final _appliesTo = TextEditingController();
  final _versions = {for (final l in AppLang.values) l: _EditVersion()};
  final _blocks = <_EditBlock>[];
  String? _id;
  DateTime? _eventDate;
  int _position = 0;
  bool _loading = true;
  bool _saving = false;
  int _nextKey = 1;

  @override
  void initState() {
    super.initState();
    _id = widget.contentId;
    _position = widget.newPosition;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _slug.dispose();
    _official.dispose();
    _notification.dispose();
    _appliesTo.dispose();
    for (final v in _versions.values) {
      v.dispose();
    }
    for (final b in _blocks) {
      b.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    if (_id == null) {
      if (_isExamOrJob) {
        _addSections();
      } else {
        _addBlock();
      }
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await context.services.admin!.loadForEdit(_id!);
      final content = data['content'] as Map<String, dynamic>;
      _slug.text = content['slug'] as String;
      _official.text = content['official_url'] as String? ?? '';
      _notification.text = content['notification_url'] as String? ?? '';
      _appliesTo.text = content['applies_to'] as String? ?? '';
      _position = (content['position'] as num?)?.toInt() ?? 0;
      _eventDate = DateTime.tryParse(content['event_date'] as String? ?? '');
      for (final v in data['versions'] as List) {
        final l = AppLang.fromCode(v['lang'] as String?);
        if (l == null) continue;
        final e = _versions[l]!;
        e.title.text = v['title'] as String? ?? '';
        e.summary.text = v['summary'] as String? ?? '';
        e.sources.text = v['sources'] as String? ?? '';
        e.lastChecked = v['last_checked'] as String?;
        e.published = v['status'] == 'published';
      }
      final byKey = <String, _EditBlock>{};
      for (final raw in [...data['blocks'] as List]..sort((a, b) => ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0))) {
        final b = Block.fromJson(raw as Map<String, dynamic>);
        final l = AppLang.fromCode(raw['lang'] as String?);
        final eb = byKey.putIfAbsent(b.key, () {
          final created = _EditBlock(key: b.key, type: b.type, style: b.style, image: b.imageUrl ?? '');
          _blocks.add(created);
          return created;
        });
        if (l != null) eb.text(l).text = b.body;
        final n = int.tryParse(b.key.replaceAll(RegExp(r'[^0-9]'), ''));
        if (n != null && n >= _nextKey) _nextKey = n + 1;
      }
    } catch (e) {
      _snack('Could not load: $e');
    }
    if (mounted) setState(() => _loading = false);
  }

  /// Pages that start with standard section headings (exams, careers, news).
  bool get _isExamOrJob => widget.category.section != 'gk';
  bool get _isNews => widget.category.section == 'ca';

  String? _text(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  /// Adds the standard section headings (both languages), each followed by an
  /// empty paragraph to fill in. Empty paragraphs are not shown to readers.
  void _addSections() {
    setState(() {
      for (final t in sectionsFor(widget.category.section)) {
        _blocks.add(_EditBlock(key: 'b${_nextKey++}', type: BlockType.heading, as: t.as, en: t.en));
        _blocks.add(_EditBlock(key: 'b${_nextKey++}', style: styleUnder(t)));
      }
    });
  }

  void _addBlock() => setState(() => _blocks.add(_EditBlock(key: 'b${_nextKey++}')));

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Builds the chapter exactly as readers would see it.
  Map<AppLang, ChapterVersion> _build() {
    final out = <AppLang, ChapterVersion>{};
    for (final l in AppLang.values) {
      final v = _versions[l]!;
      if (v.title.text.trim().isEmpty) continue;
      final blocks = <Block>[];
      for (var i = 0; i < _blocks.length; i++) {
        final b = _blocks[i];
        final body = b.text(l).text.trim();
        if (body.isEmpty && b.type != BlockType.image) continue;
        blocks.add(Block(
          key: b.key,
          position: i + 1,
          type: b.type,
          style: b.style,
          body: body,
          imageUrl: b.image.text.trim().isEmpty ? null : b.image.text.trim(),
        ));
      }
      out[l] = ChapterVersion(
        title: v.title.text.trim(),
        summary: v.summary.text.trim().isEmpty ? null : v.summary.text.trim(),
        sources: v.sources.text.trim().isEmpty ? null : v.sources.text.trim(),
        lastChecked: v.lastChecked,
        status: v.published ? 'published' : 'draft',
        blocks: blocks,
      );
    }
    return out;
  }

  String _makeSlug() {
    final source = _versions[AppLang.english]!.title.text.trim();
    final s = source.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
    return s.isEmpty ? 'chapter-${DateTime.now().millisecondsSinceEpoch}' : s;
  }

  Future<void> _save() async {
    final versions = _build();
    if (versions.isEmpty) {
      _snack('Add a title in at least one language.');
      return;
    }
    if (_isNews && _eventDate == null) {
      _snack('Choose the date of the event first.');
      return;
    }
    if (_slug.text.trim().isEmpty) _slug.text = _makeSlug();
    setState(() => _saving = true);
    try {
      _id = await context.services.admin!.save(
        id: _id,
        slug: _slug.text.trim(),
        categoryId: widget.category.id,
        position: _position,
        versions: versions,
        section: widget.category.section,
        officialUrl: _text(_official),
        notificationUrl: _text(_notification),
        appliesTo: _text(_appliesTo),
        eventDate: _eventDate,
      );
      _snack('Saved.');
    } catch (e) {
      _snack('Not saved: $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  /// Adds a tappable term to both languages of a paragraph, where the cursor is
  /// (or at the end). The reader shows the word in their language.
  Future<void> _insertTerm(_EditBlock b) async {
    final t = await pickTerm(context);
    if (t == null || !mounted) return;
    for (final l in AppLang.values) {
      final c = b.text(l);
      final marker = '{{term:${t.slug}}}';
      final sel = c.selection;
      final at = (sel.isValid && sel.start >= 0 && sel.start <= c.text.length) ? sel.start : c.text.length;
      final end = (sel.isValid && sel.end >= at && sel.end <= c.text.length) ? sel.end : at;
      final before = c.text.substring(0, at);
      final pad = before.isEmpty || before.endsWith(' ') ? '' : ' ';
      c.value = TextEditingValue(
        text: '$before$pad$marker${c.text.substring(end)}',
        selection: TextSelection.collapsed(offset: at + pad.length + marker.length),
      );
    }
    setState(() {});
    _snack('Added "${t.termEn ?? t.slug}" to both languages. Readers can tap it.');
  }

  void _preview() {
    final versions = _build();
    if (versions.isEmpty) {
      _snack('Add a title in at least one language.');
      return;
    }
    Navigator.of(context).push(SectionRoute(context, 
      builder: (_) => ReaderScreen(
        preview: Chapter(
          id: _id ?? 'preview',
          slug: _slug.text,
          versions: versions,
          officialUrl: _text(_official),
          notificationUrl: _text(_notification),
          appliesTo: _text(_appliesTo),
        ),
      ),
    ));
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this chapter?'),
        content: const Text('Both the Assamese and English versions will be deleted. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || _id == null || !mounted) return;
    try {
      await context.services.admin!.delete(_id!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _snack('Not deleted: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    return Scaffold(
      appBar: AppBar(
        title: Text(_id == null ? 'New chapter' : 'Edit chapter'),
        actions: [
          if (_id != null) IconButton(tooltip: 'Delete', onPressed: _delete, icon: const Icon(Icons.delete_outline)),
          TextButton.icon(onPressed: _preview, icon: const Icon(Icons.visibility_outlined), label: const Text('Preview')),
          const SizedBox(width: 4),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                Text('Category: ${widget.category.nameEn}', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                _pair(wide, [for (final l in AppLang.values) _versionCard(l)]),
                if (_isNews) _eventDateCard() else if (_isExamOrJob) _officialCard(),
                const SizedBox(height: 24),
                Text('Paragraphs and boxes', style: Theme.of(context).textTheme.titleLarge),
                const Text('Each item has the same place in both languages, so readers keep their place when they switch.'),
                const Text('Tap the translate icon on a paragraph to insert a dictionary word. It appears as {{term:name}} here '
                    'and as a tappable word for readers. To show different words, write {{term:name|your words}}.'),
                const SizedBox(height: 8),
                for (var i = 0; i < _blocks.length; i++) _blockCard(i, wide),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(onPressed: _addBlock, icon: const Icon(Icons.add), label: const Text('Add paragraph or box')),
                  if (_isExamOrJob)
                    OutlinedButton.icon(
                      onPressed: _addSections,
                      icon: const Icon(Icons.playlist_add),
                      label: const Text('Add standard sections'),
                    ),
                ]),
                const SizedBox(height: 24),
                ExpansionTile(
                  title: const Text('Advanced'),
                  children: [
                    TextField(
                      controller: _slug,
                      decoration: const InputDecoration(
                          labelText: 'Short web name (slug)', helperText: 'Made automatically from the English title if left empty', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: '$_position',
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Order in the list', border: OutlineInputBorder()),
                      onChanged: (v) => _position = int.tryParse(v) ?? _position,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _pair(bool wide, List<Widget> children) => wide
      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (final c in children) Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c)),
        ])
      : Column(children: children);

  /// The date the news event happened. The Current Affairs list is sorted by it.
  Widget _eventDateCard() {
    final d = _eventDate;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.event_outlined),
        title: const Text('Date of the event'),
        subtitle: Text(d == null ? 'Required. Tap to choose.' : formatDate(d)),
        trailing: const Icon(Icons.edit_calendar_outlined),
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: d ?? now,
            firstDate: DateTime(2000),
            lastDate: DateTime(now.year + 1, 12, 31),
          );
          if (picked != null) setState(() => _eventDate = picked);
        },
      ),
    );
  }

  /// Official links and the year/version the page applies to (exams and careers).
  Widget _officialCard() {
    final exam = widget.category.section == 'exam';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Official information', style: Theme.of(context).textTheme.titleMedium),
          const Text('Readers see these at the top of the page. Only use official sources.'),
          TextField(
            controller: _appliesTo,
            decoration: InputDecoration(
              labelText: exam ? 'Syllabus year / version' : 'Pay scale and rules apply as of',
              helperText: exam ? 'For example: as per the official notification of a given year' : 'For example: the date of the official pay rules you used',
            ),
          ),
          TextField(controller: _official, keyboardType: TextInputType.url, decoration: const InputDecoration(labelText: 'Official website (https://...)')),
          TextField(
            controller: _notification,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(labelText: 'Official notification link (https://...)'),
          ),
        ]),
      ),
    );
  }

  Widget _versionCard(AppLang l) {
    final v = _versions[l]!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(l.label, style: Theme.of(context).textTheme.titleMedium)),
            Text(v.published ? 'Published' : 'Draft'),
            Switch(value: v.published, onChanged: (x) => setState(() => v.published = x)),
          ]),
          TextField(controller: v.title, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: v.summary, maxLines: null, decoration: const InputDecoration(labelText: 'Short summary (optional)')),
          TextField(controller: v.sources, maxLines: null, decoration: const InputDecoration(labelText: 'Sources and reference links')),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text(v.lastChecked == null ? 'Facts last checked: not set' : 'Facts last checked: ${v.lastChecked}')),
            TextButton(
              onPressed: () async {
                final d = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100), initialDate: DateTime.now());
                if (d != null) setState(() => v.lastChecked = d.toIso8601String().substring(0, 10));
              },
              child: const Text('Set date'),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _blockCard(int i, bool wide) {
    final b = _blocks[i];
    final color = contentColorFor(b.style)?.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: color == null ? BorderSide.none : BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
            Text('${i + 1}.', style: Theme.of(context).textTheme.titleMedium),
            DropdownButton<BlockType>(
              value: b.type,
              onChanged: (t) => setState(() => b.type = t!),
              items: const [
                DropdownMenuItem(value: BlockType.paragraph, child: Text('Paragraph')),
                DropdownMenuItem(value: BlockType.heading, child: Text('Heading')),
                DropdownMenuItem(value: BlockType.factBox, child: Text('Fact box')),
                DropdownMenuItem(value: BlockType.list, child: Text('List (one item per line)')),
                DropdownMenuItem(value: BlockType.image, child: Text('Image')),
              ],
            ),
            DropdownButton<BlockStyle>(
              value: b.style,
              onChanged: (s) => setState(() => b.style = s!),
              items: [
                const DropdownMenuItem(value: BlockStyle.normal, child: Text('No colour')),
                for (final s in BlockStyle.values.skip(1))
                  DropdownMenuItem(
                    value: s,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 14, height: 14, decoration: BoxDecoration(color: contentColorFor(s)!.of(context), shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(contentColorFor(s)!.meaningEn.split(',').first),
                    ]),
                  ),
              ],
            ),
            if (b.type != BlockType.image)
              IconButton(
                tooltip: 'Insert dictionary term',
                onPressed: () => _insertTerm(b),
                icon: const Icon(Icons.translate),
              ),
            IconButton(
              tooltip: 'Move up',
              onPressed: i == 0 ? null : () => setState(() => _blocks.insert(i - 1, _blocks.removeAt(i))),
              icon: const Icon(Icons.arrow_upward),
            ),
            IconButton(
              tooltip: 'Move down',
              onPressed: i == _blocks.length - 1 ? null : () => setState(() => _blocks.insert(i + 1, _blocks.removeAt(i))),
              icon: const Icon(Icons.arrow_downward),
            ),
            IconButton(
              tooltip: 'Remove',
              onPressed: () => setState(() => _blocks.removeAt(i).dispose()),
              icon: const Icon(Icons.close),
            ),
          ]),
          if (b.type == BlockType.image) _ImagePickerField(controller: b.image),
          _pair(wide, [
            for (final l in AppLang.values)
              TextField(
                controller: b.text(l),
                maxLines: null,
                minLines: b.type == BlockType.heading ? 1 : 3,
                decoration: InputDecoration(labelText: b.type == BlockType.image ? '${l.label} caption' : l.label),
              ),
          ]),
        ]),
      ),
    );
  }
}

/// Picture of an image block: upload one from the phone's gallery, or paste a
/// web address. Shows a small preview.
class _ImagePickerField extends StatefulWidget {
  const _ImagePickerField({required this.controller});
  final TextEditingController controller;

  @override
  State<_ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<_ImagePickerField> {
  bool _uploading = false;

  Future<void> _pick() async {
    final admin = context.services.admin;
    if (admin == null) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      // Large photos are shrunk so chapters load quickly on mobile data.
      final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600, maxHeight: 1600, imageQuality: 85);
      if (file == null) return;
      setState(() => _uploading = true);
      final url = await admin.uploadImage(await file.readAsBytes(), file.name);
      widget.controller.text = url;
      messenger.showSnackBar(const SnackBar(content: Text('Picture uploaded. Remember to save the chapter.')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final url = value.text.trim();
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (url.startsWith('http'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox(height: 60, child: Center(child: Icon(Icons.broken_image_outlined))),
                    ),
                  ),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: _uploading ? null : _pick,
                    icon: _uploading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.add_photo_alternate_outlined),
                    label: Text(_uploading ? 'Uploading…' : (url.isEmpty ? 'Upload picture' : 'Change picture')),
                  ),
                  if (url.isNotEmpty && !_uploading)
                    TextButton.icon(onPressed: widget.controller.clear, icon: const Icon(Icons.delete_outline), label: const Text('Remove')),
                ],
              ),
              const SizedBox(height: 8),
              TextField(controller: widget.controller, decoration: const InputDecoration(labelText: 'Or paste a picture web address (https://...)')),
            ],
          ),
        );
      },
    );
  }
}

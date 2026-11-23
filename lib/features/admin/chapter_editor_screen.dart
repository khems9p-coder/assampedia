import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../data/models.dart';
import '../reader/block_view.dart';
import '../reader/reader_screen.dart';

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
  final _versions = {for (final l in AppLang.values) l: _EditVersion()};
  final _blocks = <_EditBlock>[];
  String? _id;
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
      _addBlock();
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await context.services.admin!.loadForEdit(_id!);
      final content = data['content'] as Map<String, dynamic>;
      _slug.text = content['slug'] as String;
      _position = (content['position'] as num?)?.toInt() ?? 0;
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
      for (final raw in data['blocks'] as List) {
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
    if (_slug.text.trim().isEmpty) _slug.text = _makeSlug();
    setState(() => _saving = true);
    try {
      _id = await context.services.admin!.save(
        id: _id,
        slug: _slug.text.trim(),
        categoryId: widget.category.id,
        position: _position,
        versions: versions,
      );
      _snack('Saved.');
    } catch (e) {
      _snack('Not saved: $e');
    }
    if (mounted) setState(() => _saving = false);
  }

  void _preview() {
    final versions = _build();
    if (versions.isEmpty) {
      _snack('Add a title in at least one language.');
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReaderScreen(preview: Chapter(id: _id ?? 'preview', slug: _slug.text, versions: versions)),
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
                const SizedBox(height: 24),
                Text('Paragraphs and boxes', style: Theme.of(context).textTheme.titleLarge),
                const Text('Each item has the same place in both languages, so readers keep their place when they switch.'),
                const SizedBox(height: 8),
                for (var i = 0; i < _blocks.length; i++) _blockCard(i, wide),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: _addBlock, icon: const Icon(Icons.add), label: const Text('Add paragraph or box')),
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
          if (b.type == BlockType.image)
            TextField(controller: b.image, decoration: const InputDecoration(labelText: 'Image web address (https://...)')),
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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/admin_repository.dart';
import '../../data/course_models.dart';
import '../../data/study_models.dart';
import 'admin_courses_screen.dart';

const _border = OutlineInputBorder();
const _maxFileBytes = 50 * 1024 * 1024;
const _icons = ['menu_book', 'picture_as_pdf', 'video', 'newspaper', 'school', 'workspace_premium', 'history', 'map', 'account_balance', 'flag'];

String _name(StudySection s) => s.titleEn ?? s.title(AppLang.english);

/// Admin > Study Material: the top-level Free and Premium sections.
class AdminStudyScreen extends StatefulWidget {
  const AdminStudyScreen({super.key});

  @override
  State<AdminStudyScreen> createState() => _AdminStudyScreenState();
}

class _AdminStudyScreenState extends State<AdminStudyScreen> {
  List<StudySection>? _all;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_all == null && _error == null) _load();
  }

  Future<void> _load() async {
    try {
      final all = await context.services.admin!.studySections();
      if (mounted) {
        setState(() {
          _all = all;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _add(StudyTier tier) async {
    final top = childSections(_all!, null);
    final saved = await Navigator.of(context).push<StudySection>(
      SectionRoute(context, builder: (_) => StudySectionEditor(section: StudySection(tier: tier, position: top.length + 1))),
    );
    if (saved != null && mounted) await _load();
  }

  Future<void> _open(StudySection s) async {
    await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminStudySectionScreen(section: s)));
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final all = _all;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Study Material')),
      body: _error != null
          ? LoadError(
              message: '$_error\n\nIf this says the table is missing, run supabase/migrations/0012_study_material.sql first.',
              onRetry: () => setState(() => _error = null),
            )
          : all == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 32),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Free sections are the hook: anyone can open them. In Premium sections the first 3 items are a free preview '
                      'and the rest need Premium. Open a section to add sub-sections, PDFs, pictures, YouTube videos, note pages and quizzes.',
                    ),
                  ),
                  for (final tier in StudyTier.values) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              tier == StudyTier.free ? 'Free sections' : 'Premium sections',
                              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                            ),
                          ),
                          TextButton.icon(onPressed: () => _add(tier), icon: const Icon(Icons.add), label: const Text('Add section')),
                        ],
                      ),
                    ),
                    for (final s in childSections(all, null).where((s) => s.tier == tier))
                      ListTile(
                        leading: Icon(categoryIcon(s.icon)),
                        title: Text(_name(s)),
                        subtitle: Text([?s.titleAs, if (!s.isPublished) 'Hidden (draft)'].join(' · ')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _open(s),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

/// One section in Admin: its sub-sections and items.
class AdminStudySectionScreen extends StatefulWidget {
  const AdminStudySectionScreen({super.key, required this.section, this.course});
  final StudySection section;

  /// Set when this is a course's own content (Admin > Courses).
  final Course? course;

  @override
  State<AdminStudySectionScreen> createState() => _AdminStudySectionScreenState();
}

class _AdminStudySectionScreenState extends State<AdminStudySectionScreen> {
  late StudySection _section = widget.section;
  late Course? _course = widget.course;
  List<StudySection>? _all;
  List<StudyItem>? _items;
  Object? _error;
  bool _busy = false;

  AdminRepository get _admin => context.services.admin!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_items == null && _error == null) _load();
  }

  Future<void> _load() async {
    try {
      final all = await _admin.studySections();
      final items = await _admin.studyItems(_section.id!);
      if (mounted) {
        setState(() {
          _all = all;
          _items = items;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _say(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _run(Future<void> Function() job, {String? done}) async {
    setState(() => _busy = true);
    try {
      await job();
      await _load();
      if (done != null) _say(done);
    } catch (e) {
      _say('Could not save: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  int get _nextPosition {
    final items = _items ?? const [];
    return items.isEmpty ? 10 : items.map((i) => i.position).reduce((a, b) => a > b ? a : b) + 10;
  }

  /// Asks for the name (both languages) of a new PDF, picture or video.
  Future<(String?, String?, String?)?> _askNames({required String what, String? suggested, bool askLink = false}) async {
    final en = TextEditingController(text: suggested);
    final as = TextEditingController();
    final link = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('New $what'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (askLink) ...[
                TextField(
                  controller: link,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(labelText: 'YouTube link', hintText: 'https://youtu.be/...', border: _border),
                ),
                const SizedBox(height: 12),
              ],
              TextField(controller: en, decoration: const InputDecoration(labelText: 'Name (English)', border: _border)),
              const SizedBox(height: 12),
              TextField(controller: as, decoration: const InputDecoration(labelText: 'Name (Assamese)', border: _border)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Add')),
        ],
      ),
    );
    String? v(TextEditingController t) => t.text.trim().isEmpty ? null : t.text.trim();
    final result = (v(en), v(as), v(link));
    for (final t in [en, as, link]) {
      t.dispose();
    }
    if (ok != true) return null;
    if (result.$1 == null && result.$2 == null) {
      _say('Write a name in at least one language.');
      return null;
    }
    return result;
  }

  Future<void> _addPdf() async {
    final f = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['pdf']);
    if (f == null || !mounted) return;
    final size = await f.length() ?? 0;
    if (size > _maxFileBytes) return _say('This PDF is over 50 MB. Please make it smaller first.');
    final names = await _askNames(what: 'PDF', suggested: f.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), ''));
    if (names == null) return;
    await _run(() async {
      final path = await _admin.uploadStudyFile(await f.xFile.readAsBytes(), f.name);
      await _admin.saveStudyItem(
        StudyItem(sectionId: _section.id!, position: _nextPosition, type: StudyItemType.pdf, titleEn: names.$1, titleAs: names.$2, filePath: path, fileSize: size),
      );
    }, done: 'PDF added.');
  }

  Future<void> _addPicture() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 2000, maxHeight: 2000, imageQuality: 85);
    if (file == null || !mounted) return;
    final names = await _askNames(what: 'picture');
    if (names == null) return;
    await _run(() async {
      final bytes = await file.readAsBytes();
      final path = await _admin.uploadStudyFile(bytes, file.name);
      await _admin.saveStudyItem(
        StudyItem(sectionId: _section.id!, position: _nextPosition, type: StudyItemType.image, titleEn: names.$1, titleAs: names.$2, filePath: path, fileSize: bytes.length),
      );
    }, done: 'Picture added.');
  }

  Future<void> _addVideo() async {
    final names = await _askNames(what: 'video', askLink: true);
    if (names == null) return;
    final link = names.$3;
    if (link == null || Uri.tryParse(link)?.hasScheme != true) return _say('Paste the full video link, starting with https://');
    if (youTubeId(link) == null) _say('Saved. This does not look like a YouTube link, so check that it opens.');
    await _run(
      () => _admin.saveStudyItem(
        StudyItem(sectionId: _section.id!, position: _nextPosition, type: StudyItemType.video, titleEn: names.$1, titleAs: names.$2, videoUrl: link),
      ),
      done: 'Video added.',
    );
  }

  Future<void> _addPage() async {
    final id = await Navigator.of(context).push<String>(SectionRoute(context, builder: (_) => const PagePicker()));
    if (id != null) {
      await _run(() => _admin.saveStudyItem(StudyItem(sectionId: _section.id!, position: _nextPosition, type: StudyItemType.page, contentId: id)));
    }
  }

  Future<void> _addQuiz() async {
    final id = await Navigator.of(context).push<String>(SectionRoute(context, builder: (_) => const QuizPicker()));
    if (id != null) {
      await _run(() => _admin.saveStudyItem(StudyItem(sectionId: _section.id!, position: _nextPosition, type: StudyItemType.quiz, setId: id)));
    }
  }

  Future<void> _addSubSection() async {
    final subs = childSections(_all ?? const [], _section.id);
    final saved = await Navigator.of(context).push<StudySection>(
      SectionRoute(
        context,
        builder: (_) => StudySectionEditor(
          section: StudySection(parentId: _section.id, tier: _section.tier, position: subs.length + 1, isPublished: true),
        ),
      ),
    );
    if (saved != null && mounted) await _load();
  }

  Future<void> _edit() async {
    if (_course != null) {
      final c = await Navigator.of(context).push<Course>(SectionRoute(context, builder: (_) => CourseEditorScreen(course: _course!)));
      if (c != null && mounted) setState(() => _course = c);
      return;
    }
    final saved = await Navigator.of(context).push<StudySection>(SectionRoute(context, builder: (_) => StudySectionEditor(section: _section)));
    if (saved != null && mounted) setState(() => _section = saved);
  }

  Future<void> _delete() async {
    if (_course != null) return _deleteCourse();
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this section?'),
        content: const Text('Its sub-sections, items and uploaded files are deleted too. Note pages and quizzes stay in the app.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await _admin.deleteStudySection(_section.id!, _all ?? const []);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _say('Could not delete: $e');
    }
  }

  Future<void> _deleteCourse() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this course?'),
        content: const Text('The course, its sections, subjects, topics and uploaded files are deleted. Chapters and quizzes from the app stay.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await _admin.deleteStudySection(_section.id!, _all ?? const []);
      await _admin.deleteCourse(_course!.id!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _say('Could not delete: $e');
    }
  }

  Future<void> _itemMenu(StudyItem it) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.edit_outlined), title: const Text('Rename'), onTap: () => Navigator.pop(c, 'rename')),
            ListTile(
              leading: Icon(it.isPublished ? Icons.visibility_off_outlined : Icons.visibility_outlined),
              title: Text(it.isPublished ? 'Hide (make draft)' : 'Publish'),
              onTap: () => Navigator.pop(c, 'publish'),
            ),
            ListTile(leading: const Icon(Icons.delete_outline), title: const Text('Delete'), onTap: () => Navigator.pop(c, 'delete')),
          ],
        ),
      ),
    );
    if (!mounted) return;
    switch (choice) {
      case 'rename':
        final names = await _askNames(what: 'name', suggested: it.titleEn);
        if (names != null) await _run(() => _admin.renameStudyItem(it.id!, titleEn: names.$1, titleAs: names.$2));
      case 'publish':
        await _run(() => _admin.setStudyItemFlags(it.id!, published: !it.isPublished));
      case 'delete':
        await _run(() => _admin.deleteStudyItem(it), done: 'Deleted.');
    }
  }

  void _reorder(int from, int to) {
    final items = [..._items!];
    items.insert(to, items.removeAt(from));
    setState(() => _items = items);
    _run(() => _admin.reorderStudyItems(items));
  }

  void _addMenu() => showModalBottomSheet<void>(
    context: context,
    builder: (c) {
      Widget opt(IconData icon, String title, String sub, VoidCallback go) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(sub),
        onTap: () {
          Navigator.pop(c);
          go();
        },
      );
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              opt(Icons.create_new_folder_outlined, 'Add section / subject / topic', 'A folder inside this one; open it to add more inside', _addSubSection),
              opt(Icons.picture_as_pdf_outlined, 'Upload PDF', 'From this tablet, up to 50 MB', _addPdf),
              opt(Icons.image_outlined, 'Upload picture', 'From the gallery', _addPicture),
              opt(Icons.ondemand_video_outlined, 'Add video', 'Paste a YouTube link', _addVideo),
              opt(Icons.article_outlined, 'Add note page', 'A chapter or exam page already in the app', _addPage),
              opt(Icons.quiz_outlined, 'Add quiz', 'From the Practice Zone', _addQuiz),
            ],
          ),
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final subs = childSections(_all ?? const [], _section.id);
    final premium = _section.isPremium;
    return Scaffold(
      appBar: AppBar(
        title: Text(_course != null ? (_course!.titleEn ?? _course!.title(AppLang.english)) : _name(_section)),
        actions: [
          IconButton(tooltip: _course != null ? 'Edit course name and description' : 'Edit section', icon: const Icon(Icons.edit_outlined), onPressed: _edit),
          IconButton(tooltip: _course != null ? 'Delete course' : 'Delete section', icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
        bottom: _busy ? const PreferredSize(preferredSize: Size.fromHeight(4), child: LinearProgressIndicator()) : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy || items == null ? null : _addMenu,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: _error != null
          ? LoadError(message: '$_error', onRetry: () => setState(() => _error = null))
          : items == null
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              buildDefaultDragHandles: false,
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_course != null)
                    Card(
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Build this course here: tap Add to make sections, subjects and topics (each can hold more inside), '
                          'and upload PDFs, pictures and YouTube videos straight into any of them. '
                          'The first 3 items of each section or topic are a free preview. '
                          '${_course!.isPublished ? 'The course is published.' : 'The course is hidden (draft): publish it with the edit button.'}',
                        ),
                      ),
                    ),
                  if (_course != null)
                    ListTile(
                      leading: const Icon(Icons.format_list_numbered),
                      title: const Text('Step-by-step lessons from the app'),
                      subtitle: const Text('Chapters and quizzes already in the app, in order, with progress ticks'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminCourseLessonsScreen(course: _course!))),
                    ),
                  if (_course == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      '${premium ? 'Premium section: the first 3 items are a free preview; switch "Free" on to give away more.' : 'Free section: everything here is free for everyone.'}'
                      '${_section.isPublished ? '' : ' This section is hidden (draft) until you publish it.'}',
                    ),
                  ),
                  if (subs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(_course != null ? 'Sections, subjects and topics' : 'Sub-sections', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  for (final s in subs)
                    ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(_name(s)),
                      subtitle: Text([s.isPremium ? 'Premium' : 'Free', if (!s.isPublished) 'Hidden (draft)'].join(' · ')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminStudySectionScreen(section: s)));
                        if (mounted) await _load();
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(
                      items.isEmpty ? 'No items yet. Tap Add.' : 'Items (drag ≡ to change the order, tap for more)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              itemCount: items.length,
              onReorderItem: _busy ? (_, _) {} : _reorder,
              itemBuilder: (context, i) {
                final it = items[i];
                final preview = premium && i < 3;
                return ListTile(
                  key: ValueKey(it.id),
                  leading: Icon(switch (it.type) {
                    StudyItemType.pdf => Icons.picture_as_pdf_outlined,
                    StudyItemType.image => Icons.image_outlined,
                    StudyItemType.video => Icons.ondemand_video_outlined,
                    StudyItemType.page => Icons.article_outlined,
                    StudyItemType.quiz => Icons.quiz_outlined,
                  }),
                  title: Text(it.title(AppLang.english)),
                  subtitle: Text([
                    it.type.name.toUpperCase(),
                    if (it.fileSize != null) fileSizeLabel(it.fileSize!),
                    if (!premium) 'Free' else if (preview) 'Free preview' else if (it.markedFree) 'Free' else 'Premium',
                    if (!it.isPublished) 'Hidden',
                  ].join(' · ')),
                  onTap: _busy ? null : () => _itemMenu(it),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (premium && !preview)
                        Tooltip(
                          message: 'Free',
                          child: Switch(
                            value: it.markedFree,
                            onChanged: _busy ? null : (v) => _run(() => _admin.setStudyItemFlags(it.id!, free: v)),
                          ),
                        ),
                      ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_handle)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// Name, description, icon, Free/Premium and the published switch of a section.
class StudySectionEditor extends StatefulWidget {
  const StudySectionEditor({super.key, required this.section});
  final StudySection section;

  @override
  State<StudySectionEditor> createState() => _StudySectionEditorState();
}

class _StudySectionEditorState extends State<StudySectionEditor> {
  late final _titleEn = TextEditingController(text: widget.section.titleEn);
  late final _titleAs = TextEditingController(text: widget.section.titleAs);
  late final _descEn = TextEditingController(text: widget.section.descriptionEn);
  late final _descAs = TextEditingController(text: widget.section.descriptionAs);
  late String _icon = widget.section.icon ?? 'menu_book';
  late StudyTier _tier = widget.section.tier;
  late bool _published = widget.section.isPublished;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_titleEn, _titleAs, _descEn, _descAs]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _v(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _save() async {
    if (_v(_titleEn) == null && _v(_titleAs) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Write a name in at least one language.')));
      return;
    }
    final s = widget.section;
    setState(() => _saving = true);
    try {
      final saved = await context.services.admin!.saveStudySection(
        StudySection(
          id: s.id,
          parentId: s.parentId,
          tier: _tier,
          slug: s.slug,
          titleEn: _v(_titleEn),
          titleAs: _v(_titleAs),
          descriptionEn: _v(_descEn),
          descriptionAs: _v(_descAs),
          icon: _icon,
          position: s.position,
          isPublished: _published,
        ),
      );
      if (mounted) Navigator.of(context).pop(saved);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget field(String label, TextEditingController c, {int lines = 1}) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        minLines: lines,
        maxLines: lines == 1 ? 1 : 6,
        decoration: InputDecoration(labelText: label, border: _border),
      ),
    );
    final isSub = widget.section.parentId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section.id == null ? (isSub ? 'New sub-section' : 'New section') : 'Edit section'),
        actions: [TextButton(onPressed: _saving ? null : _save, child: const Text('Save'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          field('Name (English)', _titleEn),
          field('Name (Assamese)', _titleAs),
          field('Short description (English)', _descEn, lines: 2),
          field('Short description (Assamese)', _descAs, lines: 2),
          const Text('Who can open it'),
          const SizedBox(height: 8),
          SegmentedButton<StudyTier>(
            segments: const [
              ButtonSegment(value: StudyTier.free, label: Text('Free'), icon: Icon(Icons.card_giftcard_outlined)),
              ButtonSegment(value: StudyTier.premium, label: Text('Premium'), icon: Icon(Icons.workspace_premium_outlined)),
            ],
            selected: {_tier},
            onSelectionChanged: (v) => setState(() => _tier = v.first),
          ),
          const SizedBox(height: 8),
          Text(
            _tier == StudyTier.free
                ? 'Everything inside is free.'
                : 'The first 3 items are a free preview; the rest need Premium.${isSub ? '' : ' Shows under Study > Premium.'}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          const Text('Icon'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in _icons)
                ChoiceChip(label: Icon(categoryIcon(name), size: 20), selected: _icon == name, onSelected: (_) => setState(() => _icon = name)),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Published'),
            subtitle: const Text('Students can see it'),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
        ],
      ),
    );
  }
}

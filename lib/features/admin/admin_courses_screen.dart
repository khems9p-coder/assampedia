import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/admin_repository.dart';
import '../../data/course_models.dart';
import '../../data/models.dart';
import '../../data/practice_models.dart';

import 'admin_study_screen.dart';

const _border = OutlineInputBorder();

const _icons = ['flag', 'gavel', 'shield', 'history', 'map', 'account_balance', 'work', 'public', 'groups', 'place'];

/// Admin list of all courses, including drafts.
class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({super.key});

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen> {
  late Future<List<Course>> _courses;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _courses = context.services.admin!.courses();
  }

  void _reload() => setState(() => _courses = context.services.admin!.courses());

  /// Opens the course's own content (sections, subjects, topics, uploads).
  Future<void> _open(Course c) async {
    try {
      final section = await context.services.admin!.courseSection(c);
      if (!mounted) return;
      await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminStudySectionScreen(section: section, course: c)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the course content: $e\nRun supabase/migrations/0013_course_content.sql first.')),
      );
      // Older databases: the lesson list still works.
      await Navigator.of(context).push(SectionRoute(context, builder: (_) => AdminCourseLessonsScreen(course: c)));
    }
    if (mounted) _reload();
  }

  Future<void> _new(int position) async {
    final saved = await Navigator.of(context).push<Course>(
      SectionRoute(context, builder: (_) => CourseEditorScreen(course: Course(slug: '', position: position))),
    );
    if (saved != null && mounted) await _open(saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Courses')),
      body: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _new(list.isEmpty ? 1 : list.map((c) => c.position).reduce((a, b) => a > b ? a : b) + 1),
              icon: const Icon(Icons.add),
              label: const Text('Add course'),
            ),
            body: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    'A course is a study path for one exam. Add pages (GK chapters, exam syllabus pages) and quizzes '
                    'that are already in the app, in the order students should study them. '
                    'The first 3 lessons of a published course are free for everyone.',
                  ),
                ),
                if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No courses yet. Run supabase/migrations/0010_courses.sql to add the starter courses.'),
                  ),
                for (final c in list)
                  ListTile(
                    leading: Icon(categoryIcon(c.icon)),
                    title: Text(c.titleEn ?? c.title(AppLang.english)),
                    subtitle: Text([?c.titleAs, '${c.lessonCount} lessons', if (!c.isPublished) 'Hidden (draft)'].join(' · ')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _open(c),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A course's lessons: add, reorder (drag the handle) and remove.
class AdminCourseLessonsScreen extends StatefulWidget {
  const AdminCourseLessonsScreen({super.key, required this.course});
  final Course course;

  @override
  State<AdminCourseLessonsScreen> createState() => _AdminCourseLessonsScreenState();
}

class _AdminCourseLessonsScreenState extends State<AdminCourseLessonsScreen> {
  late Course _course = widget.course;
  List<CourseItem>? _items;
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
      final items = await _admin.courseItems(_course.id!);
      if (mounted) {
        setState(() {
          _items = items;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _run(Future<void> Function() job) async {
    setState(() => _busy = true);
    try {
      await job();
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  int get _nextPosition {
    final items = _items ?? const [];
    return items.isEmpty ? 10 : items.map((i) => i.position).reduce((a, b) => a > b ? a : b) + 10;
  }

  Future<void> _addPage() async {
    final picked = await Navigator.of(context).push<String>(SectionRoute(context, builder: (_) => const PagePicker()));
    if (picked != null) await _run(() => _admin.addCourseItem(_course.id!, contentId: picked, position: _nextPosition));
  }

  Future<void> _addQuiz() async {
    final picked = await Navigator.of(context).push<String>(SectionRoute(context, builder: (_) => const QuizPicker()));
    if (picked != null) await _run(() => _admin.addCourseItem(_course.id!, setId: picked, position: _nextPosition));
  }

  Future<void> _edit() async {
    final saved = await Navigator.of(context).push<Course>(SectionRoute(context, builder: (_) => CourseEditorScreen(course: _course)));
    if (saved != null && mounted) setState(() => _course = saved);
  }

  Future<void> _deleteCourse() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete this course?'),
        content: const Text('The course and its lesson list are removed. The pages and quizzes themselves stay in the app.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await _admin.deleteCourse(_course.id!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete: $e')));
    }
  }

  void _reorder(int from, int to) {
    final items = [..._items!];
    items.insert(to, items.removeAt(from));
    setState(() => _items = items);
    _run(() => _admin.reorderCourseItems(items));
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      appBar: AppBar(
        title: Text(_course.titleEn ?? _course.title(AppLang.english)),
        actions: [
          IconButton(tooltip: 'Edit name and description', icon: const Icon(Icons.edit_outlined), onPressed: _edit),
          IconButton(tooltip: 'Delete course', icon: const Icon(Icons.delete_outline), onPressed: _deleteCourse),
        ],
        bottom: _busy ? const PreferredSize(preferredSize: Size.fromHeight(4), child: LinearProgressIndicator()) : null,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy
            ? null
            : () => showModalBottomSheet<void>(
                context: context,
                builder: (c) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: const Text('Add a page'),
                        subtitle: const Text('A GK chapter, exam syllabus page or career page'),
                        onTap: () {
                          Navigator.pop(c);
                          _addPage();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.quiz_outlined),
                        title: const Text('Add a quiz'),
                        subtitle: const Text('From the Practice Zone'),
                        onTap: () {
                          Navigator.pop(c);
                          _addQuiz();
                        },
                      ),
                    ],
                  ),
                ),
              ),
        icon: const Icon(Icons.add),
        label: const Text('Add lesson'),
      ),
      body: _error != null
          ? LoadError(message: '$_error', onRetry: () => setState(() => _error = null))
          : items == null
          ? const Center(child: CircularProgressIndicator())
          : ReorderableListView.builder(
              padding: const EdgeInsets.only(bottom: 96),
              header: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  '${_course.isPublished ? 'Published' : 'Hidden (draft): students cannot see it yet'}. '
                  'Drag ≡ to change the order. Lessons whose page or quiz is still a draft stay hidden from students.',
                ),
              ),
              itemCount: items.length,
              onReorderItem: _busy ? (_, _) {} : _reorder,
              buildDefaultDragHandles: false,
              itemBuilder: (context, i) {
                final it = items[i];
                return ListTile(
                  key: ValueKey(it.id),
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(it.label),
                  subtitle: Text(it.isQuiz ? 'Quiz' : 'Page'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Remove from course',
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _busy ? null : () => _run(() => _admin.deleteCourseItem(it.id!)),
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

/// Name, description, icon and published switch of a course.
class CourseEditorScreen extends StatefulWidget {
  const CourseEditorScreen({super.key, required this.course});
  final Course course;

  @override
  State<CourseEditorScreen> createState() => _CourseEditorScreenState();
}

class _CourseEditorScreenState extends State<CourseEditorScreen> {
  late final _titleEn = TextEditingController(text: widget.course.titleEn);
  late final _titleAs = TextEditingController(text: widget.course.titleAs);
  late final _descEn = TextEditingController(text: widget.course.descriptionEn);
  late final _descAs = TextEditingController(text: widget.course.descriptionAs);
  late String _icon = widget.course.icon ?? 'flag';
  late bool _published = widget.course.isPublished;
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Write a course name in at least one language.')));
      return;
    }
    final c = widget.course;
    var slug = c.slug;
    if (slug.isEmpty) {
      final base = (_v(_titleEn) ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
      slug = '${base.isEmpty ? 'course' : base}-${DateTime.now().millisecondsSinceEpoch % 100000}';
    }
    setState(() => _saving = true);
    try {
      final saved = await context.services.admin!.saveCourse(
        Course(
          id: c.id,
          slug: slug,
          titleEn: _v(_titleEn),
          titleAs: _v(_titleAs),
          descriptionEn: _v(_descEn),
          descriptionAs: _v(_descAs),
          icon: _icon,
          position: c.position,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.id == null ? 'New course' : 'Edit course'),
        actions: [
          TextButton(onPressed: _saving ? null : _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          field('Course name (English)', _titleEn),
          field('Course name (Assamese)', _titleAs),
          field('Short description (English)', _descEn, lines: 3),
          field('Short description (Assamese)', _descAs, lines: 3),
          const Text('Icon'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in _icons)
                ChoiceChip(
                  label: Icon(categoryIcon(name), size: 20),
                  selected: _icon == name,
                  onSelected: (_) => setState(() => _icon = name),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Published'),
            subtitle: const Text('Students see the course in the Courses tab'),
            value: _published,
            onChanged: (v) => setState(() => _published = v),
          ),
        ],
      ),
    );
  }
}

/// Pick a page: first its group, then the page. Returns the page's id.
class PagePicker extends StatefulWidget {
  const PagePicker({super.key});

  @override
  State<PagePicker> createState() => PagePickerState();
}

class PagePickerState extends State<PagePicker> {
  late final Future<List<Category>> _cats = context.services.admin!.categories();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Choose a group')),
    body: FutureBuilder<List<Category>>(
      future: _cats,
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text('${snap.error}'));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        return ListView(
          children: [
            for (final (section, label) in const [
              ('exam', 'Exam syllabus library'),
              ('gk', 'Assam GK encyclopedia'),
              ('job', 'Government careers'),
              ('ca', 'Current affairs'),
            ]) ...[
              if (snap.data!.any((c) => c.section == section))
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
                ),
              for (final c in snap.data!.where((c) => c.section == section))
                ListTile(
                  leading: Icon(categoryIcon(c.icon)),
                  title: Text(c.nameEn),
                  subtitle: Text(c.nameAs),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final id = await Navigator.of(context).push<String>(SectionRoute(context, builder: (_) => ChapterPicker(category: c)));
                    if (id != null && context.mounted) Navigator.of(context).pop(id);
                  },
                ),
            ],
          ],
        );
      },
    ),
  );
}

class ChapterPicker extends StatefulWidget {
  const ChapterPicker({super.key, required this.category});
  final Category category;

  @override
  State<ChapterPicker> createState() => ChapterPickerState();
}

class ChapterPickerState extends State<ChapterPicker> {
  late final Future<List<ChapterSummary>> _list = context.services.admin!.chapters(widget.category.id);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.category.nameEn)),
    body: FutureBuilder<List<ChapterSummary>>(
      future: _list,
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text('${snap.error}'));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (snap.data!.isEmpty) return const Center(child: Text('No pages in this group yet.'));
        return ListView(
          children: [
            for (final c in snap.data!)
              ListTile(
                title: Text(c.title(AppLang.english)),
                subtitle: Text(c.statuses.values.contains('published') ? 'Published' : 'Draft (students see it once published)'),
                onTap: () => Navigator.of(context).pop(c.id),
              ),
          ],
        );
      },
    ),
  );
}

class QuizPicker extends StatefulWidget {
  const QuizPicker({super.key});

  @override
  State<QuizPicker> createState() => QuizPickerState();
}

class QuizPickerState extends State<QuizPicker> {
  late final Future<List<QuestionSet>> _sets = context.services.admin!.questionSets();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Choose a quiz')),
    body: FutureBuilder<List<QuestionSet>>(
      future: _sets,
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text('${snap.error}'));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final sets = snap.data!.where((x) => x.kind != QuizKind.daily).toList();
        if (sets.isEmpty) return const Center(child: Text('No quizzes yet. Add them in Admin > Practice Zone.'));
        return ListView(
          children: [
            for (final x in sets)
              ListTile(
                leading: const Icon(Icons.quiz_outlined),
                title: Text(x.title(AppLang.english)),
                subtitle: Text([x.kind.nameEn, '${x.questionCount} questions', if (!x.isPublished) 'Draft'].join(' · ')),
                onTap: () => Navigator.of(context).pop(x.id),
              ),
          ],
        );
      },
    ),
  );
}

import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/course_models.dart';
import '../practice/practice_screen.dart';
import '../practice/quiz_screen.dart';
import '../premium/paywall_screen.dart';
import '../reader/reader_screen.dart';

/// The Courses tab: one study path per exam (APSC CCE, ADRE, Assam Police ...).
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  Future<List<Course>>? _courses;

  Future<List<Course>>? _fetch() => context.services.content?.courses();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_courses == null) {
      _courses = _fetch();
      context.services.courseProgress.ready();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(s.coursesTitle),
        actions: [
          IconButton(
            tooltip: s.practiceZone,
            icon: const Icon(Icons.quiz_outlined),
            onPressed: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => const PracticeScreen())),
          ),
          const Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch()),
        ],
      ),
      body: _courses == null
          ? Center(child: Text(s.notConnected))
          : FutureBuilder<List<Course>>(
              future: _courses,
              builder: (context, snap) {
                if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _courses = _fetch()));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final list = snap.data!;
                return RefreshIndicator(
                  onRefresh: () async => setState(() => _courses = _fetch()),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Padding(padding: const EdgeInsets.fromLTRB(4, 8, 4, 12), child: Text(s.coursesIntro)),
                      if (list.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Center(child: Text(s.noCourses))),
                      for (final c in list)
                        Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => CourseScreen(course: c))),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.colorScheme.primaryContainer,
                                    child: Icon(categoryIcon(c.icon), color: theme.colorScheme.onPrimaryContainer),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.title(lang), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                        if (c.description(lang) != null) ...[
                                          const SizedBox(height: 4),
                                          Text(c.description(lang)!, style: theme.textTheme.bodyMedium),
                                        ],
                                        const SizedBox(height: 6),
                                        Text(
                                          s.lessonsCount(c.lessonCount),
                                          style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

/// One course: its lessons in order, with ticks for the ones already done.
class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});
  final Course course;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  Future<List<CourseLesson>>? _lessons;

  Future<List<CourseLesson>>? _fetch() {
    final id = widget.course.id;
    return id == null ? null : context.services.content?.courseLessons(id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_lessons == null) {
      _lessons = _fetch();
      context.services.courseProgress.ready();
    }
  }

  Future<void> _open(CourseLesson l, bool locked) async {
    final services = context.services;
    final nav = Navigator.of(context);
    if (locked) {
      nav.push(SectionRoute(context, builder: (_) => const PaywallScreen()));
      return;
    }
    Widget? screen;
    if (l.contentId != null) {
      screen = ReaderScreen(contentId: l.contentId);
    } else if (l.setId != null) {
      try {
        final sets = await services.content!.questionSets();
        final set = sets.where((x) => x.id == l.setId).firstOrNull;
        if (set != null) screen = QuizScreen(set: set);
      } catch (_) {}
    }
    if (!mounted) return;
    if (screen == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.s.quizNotFound)));
      return;
    }
    services.courseProgress.setDone(l.id, true);
    nav.push(SectionRoute(context, builder: (_) => screen!));
  }

  String _kindLabel(LessonKind k) {
    final s = context.s;
    return switch (k) {
      LessonKind.chapter => s.lessonChapter,
      LessonKind.exam => s.lessonExam,
      LessonKind.career => s.lessonCareer,
      LessonKind.news => s.lessonNews,
      LessonKind.quiz => s.lessonQuiz,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final services = context.services;
    final course = widget.course;
    return Scaffold(
      appBar: AppBar(title: Text(course.title(lang)), actions: const [LanguageSwitch(), SizedBox(width: 8)]),
      body: _lessons == null
          ? Center(child: Text(s.notConnected))
          : FutureBuilder<List<CourseLesson>>(
              future: _lessons,
              builder: (context, snap) {
                if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _lessons = _fetch()));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final lessons = snap.data!;
                return ListenableBuilder(
                  listenable: Listenable.merge([services.courseProgress, services.premium]),
                  builder: (context, _) {
                    final progress = services.courseProgress;
                    final done = progress.doneCount(lessons.map((l) => l.id));
                    final next = lessons.where((l) => !progress.isDone(l.id)).firstOrNull;
                    bool locked(CourseLesson l) => !l.isFree && !services.premium.isPremium;
                    return RefreshIndicator(
                      onRefresh: () async => setState(() => _lessons = _fetch()),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (course.description(lang) != null) ...[
                                    Text(course.description(lang)!),
                                    const SizedBox(height: 12),
                                  ],
                                  if (lessons.isNotEmpty) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(value: done / lessons.length, minHeight: 8),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(s.lessonsDone(done, lessons.length), style: theme.textTheme.labelLarge),
                                    const SizedBox(height: 12),
                                    if (next == null)
                                      Text(s.courseFinished, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary))
                                    else
                                      FilledButton.icon(
                                        onPressed: () => _open(next, locked(next)),
                                        icon: const Icon(Icons.play_arrow),
                                        label: Text('${done == 0 ? s.startCourse : s.continueCourse}: ${s.lessonNo(next.number)}'),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (lessons.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(s.noLessons))),
                          for (final l in lessons)
                            Card(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: InkResponse(
                                  onTap: () => progress.setDone(l.id, !progress.isDone(l.id)),
                                  child: Tooltip(
                                    message: s.markDone,
                                    child: CircleAvatar(
                                      backgroundColor: progress.isDone(l.id)
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.surfaceContainerHighest,
                                      foregroundColor: progress.isDone(l.id)
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurfaceVariant,
                                      child: progress.isDone(l.id) ? const Icon(Icons.check) : Text('${l.number}'),
                                    ),
                                  ),
                                ),
                                title: Text(l.title(lang)),
                                subtitle: Text(
                                  [
                                    _kindLabel(l.kind),
                                    if (l.isFree && !services.premium.isPremium) s.lessonFree,
                                    if (l.missingIn(lang)) s.notAvailableIn(lang),
                                  ].join(' · '),
                                ),
                                trailing: locked(l)
                                    ? const LockIcon()
                                    : Icon(l.kind == LessonKind.quiz ? Icons.quiz_outlined : Icons.chevron_right),
                                onTap: () => _open(l, locked(l)),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

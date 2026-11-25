import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/line_art.dart';
import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../../core/widgets/common.dart';
import '../../data/course_models.dart';
import '../../data/study_models.dart';
import '../courses/courses_screen.dart';
import '../home/home_drawer.dart' show playStoreUrl;
import '../practice/practice_screen.dart';
import '../practice/quiz_screen.dart';
import '../premium/paywall_screen.dart';
import '../reader/reader_screen.dart';
import 'study_file_screens.dart';

/// The Study tab: Free material (the hook) and Premium courses and material.
class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  Future<List<StudySection>>? _sections;
  Future<List<Course>>? _courses;

  void _load() {
    final repo = context.services.content;
    // A database without the Study Material update still shows the courses.
    _sections = repo?.studySections().catchError((Object _) => <StudySection>[]);
    _courses = repo?.courses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_sections == null) {
      _load();
      context.services.courseProgress.ready();
    }
  }

  Future<void> _refresh() async => setState(_load);

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.studyTitle),
          actions: [
            IconButton(
              tooltip: s.practiceZone,
              icon: const Icon(Icons.quiz_outlined),
              onPressed: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => const PracticeScreen())),
            ),
            const Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch()),
          ],
          bottom: PillTabBar(labels: [s.tabFree, s.tabPremium]),
        ),
        body: _sections == null
            ? Center(child: Text(s.notConnected))
            : FutureBuilder<List<StudySection>>(
                future: _sections,
                builder: (context, snap) {
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                  final all = snap.data!;
                  return TabBarView(
                    children: [
                      _FreeTab(all: all, onRefresh: _refresh),
                      _PremiumTab(all: all, courses: _courses!, onRefresh: _refresh),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _FreeTab extends StatelessWidget {
  const _FreeTab({required this.all, required this.onRefresh});
  final List<StudySection> all;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final top = [for (final x in childSections(all, null)) if (!x.isPremium) x];
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          IntroCard(text: s.freeIntro, art: LineArt.books),
          if (top.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(s.nothingHereYet))),
          for (final x in top) SectionCard(section: x, all: all),
        ],
      ),
    );
  }
}

class _PremiumTab extends StatelessWidget {
  const _PremiumTab({required this.all, required this.courses, required this.onRefresh});
  final List<StudySection> all;
  final Future<List<Course>> courses;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final premium = context.services.premium;
    final top = [for (final x in childSections(all, null)) if (x.isPremium) x];
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListenableBuilder(
        listenable: premium,
        builder: (context, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            IntroCard(text: s.premiumIntro, art: LineArt.town, color: Theme.of(context).colorScheme.tertiaryContainer),
            if (!premium.isPremium) const UpsellCard(),
            _heading(context, s.coursesHeading),
            FutureBuilder<List<Course>>(
              future: courses,
              builder: (context, snap) {
                if (snap.hasError) return Text(s.loadFailed);
                if (!snap.hasData) return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
                if (snap.data!.isEmpty) return Padding(padding: const EdgeInsets.all(8), child: Text(s.noCourses));
                return Column(
                  children: [
                    for (final c in snap.data!)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Icon(categoryIcon(c.icon), color: theme.colorScheme.onPrimaryContainer),
                          ),
                          title: Text(c.title(lang), style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text([?c.description(lang), s.lessonsCount(c.lessonCount)].join('\n')),
                          isThreeLine: c.description(lang) != null,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => CourseScreen(course: c))),
                        ),
                      ),
                  ],
                );
              },
            ),
            if (top.isNotEmpty) _heading(context, s.materialHeading),
            for (final x in top) SectionCard(section: x, all: all),
          ],
        ),
      ),
    );
  }
}

Widget _heading(BuildContext context, String text) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
    child: Text(text, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
  );
}

/// "Unlock everything with Premium" card, opening the Premium page.
class UpsellCard extends StatelessWidget {
  const UpsellCard({super.key, this.title, this.subtitle});
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final price = context.services.premium.price;
    return Card(
      color: theme.colorScheme.tertiaryContainer,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.workspace_premium, color: theme.colorScheme.onTertiaryContainer),
        title: Text(
          title ?? s.unlockAll,
          style: TextStyle(fontWeight: FontWeight.w700, color: theme.colorScheme.onTertiaryContainer),
        ),
        subtitle: Text(
          [subtitle ?? s.unlockAllHint, if (price != null) s.perYear(price)].join('\n'),
          style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
        ),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onTertiaryContainer),
        onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => const PaywallScreen())),
      ),
    );
  }
}

/// A section in a list: icon, name, description and how much is inside.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.section, required this.all});
  final StudySection section;
  final List<StudySection> all;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final subs = childSections(all, section.id).length;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: section.isPremium ? theme.colorScheme.tertiaryContainer : theme.colorScheme.secondaryContainer,
          child: Icon(
            categoryIcon(section.icon ?? (section.isPremium ? 'workspace_premium' : 'menu_book')),
            color: section.isPremium ? theme.colorScheme.onTertiaryContainer : theme.colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(section.title(lang), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text([?section.description(lang), if (subs > 0) s.sectionsCount(subs)].join('\n')),
        isThreeLine: section.description(lang) != null && subs > 0,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Tag(section.isPremium ? s.premium : s.lessonFree, premium: section.isPremium),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => StudySectionScreen(section: section, all: all))),
      ),
    );
  }
}

/// A small "Free" or "Premium" label.
class _Tag extends StatelessWidget {
  const _Tag(this.text, {required this.premium});
  final String text;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = premium ? scheme.tertiaryContainer : (dark ? const Color(0xFF1F3A29) : const Color(0xFFE3F0E7));
    final fg = premium ? scheme.onTertiaryContainer : scheme.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

/// One section: its sub-sections, then its items. Locked items show a lock;
/// a card at the end says how many more open with Premium.
class StudySectionScreen extends StatefulWidget {
  const StudySectionScreen({super.key, required this.section, required this.all});
  final StudySection section;
  final List<StudySection> all;

  @override
  State<StudySectionScreen> createState() => _StudySectionScreenState();
}

class _StudySectionScreenState extends State<StudySectionScreen> {
  Future<List<StudyItem>>? _items;

  Future<List<StudyItem>>? _fetch() => context.services.content?.studyItems(widget.section.id!);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _items ??= _fetch();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final services = context.services;
    final subs = childSections(widget.all, widget.section.id);
    return Scaffold(
      appBar: AppBar(title: Text(widget.section.title(lang)), actions: const [LanguageSwitch(), SizedBox(width: 8)]),
      body: FutureBuilder<List<StudyItem>>(
        future: _items,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _items = _fetch()));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final items = snap.data!;
          return ListenableBuilder(
            listenable: services.premium,
            builder: (context, _) {
              final premium = services.premium.isPremium;
              final locked = premium ? 0 : items.where((i) => !i.isFree).length;
              return RefreshIndicator(
                onRefresh: () async => setState(() => _items = _fetch()),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    if (widget.section.description(lang) != null)
                      Padding(padding: const EdgeInsets.fromLTRB(4, 0, 4, 12), child: Text(widget.section.description(lang)!)),
                    if (widget.section.isPremium && !premium && items.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                        child: Text(s.previewHint, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    for (final x in subs) SectionCard(section: x, all: widget.all),
                    if (subs.isNotEmpty && items.isNotEmpty) const SizedBox(height: 8),
                    for (final it in items) StudyItemTile(item: it, locked: !premium && !it.isFree),
                    if (subs.isEmpty && items.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(s.nothingHereYet))),
                    if (locked > 0) ...[const SizedBox(height: 8), UpsellCard(title: s.moreWithPremium(locked))],
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

IconData studyItemIcon(StudyItemType t) => switch (t) {
  StudyItemType.pdf => Icons.picture_as_pdf_outlined,
  StudyItemType.image => Icons.image_outlined,
  StudyItemType.video => Icons.ondemand_video_outlined,
  StudyItemType.page => Icons.article_outlined,
  StudyItemType.quiz => Icons.quiz_outlined,
};

/// One item in a section list.
class StudyItemTile extends StatelessWidget {
  const StudyItemTile({super.key, required this.item, required this.locked});
  final StudyItem item;
  final bool locked;

  String _kind(BuildContext context) {
    final s = context.s;
    return switch (item.type) {
      StudyItemType.pdf => s.itemPdf,
      StudyItemType.image => s.itemImage,
      StudyItemType.video => s.itemVideo,
      StudyItemType.page => s.itemPage,
      StudyItemType.quiz => s.itemQuiz,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final premium = context.services.premium.isPremium;
    final info = [
      _kind(context),
      if (item.fileSize != null) fileSizeLabel(item.fileSize!),
      if (item.isFree && !premium) s.lessonFree,
    ].join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(studyItemIcon(item.type), color: locked ? theme.colorScheme.outline : theme.colorScheme.primary),
        title: Text(item.title(lang)),
        subtitle: Text([?item.description(lang), info].join('\n')),
        isThreeLine: item.description(lang) != null,
        trailing: locked ? const LockIcon() : const Icon(Icons.chevron_right),
        onTap: () => openStudyItem(context, item, locked: locked),
      ),
    );
  }
}

/// Opens an item in the right viewer, or the Premium page when it is locked.
Future<void> openStudyItem(BuildContext context, StudyItem item, {required bool locked}) async {
  final services = context.services;
  final nav = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final s = context.s;
  final lang = context.lang;
  void push(Widget w) => nav.push(SectionRoute(context, builder: (_) => w));
  if (locked) return push(const PaywallScreen());
  switch (item.type) {
    case StudyItemType.pdf:
      push(StudyPdfScreen(item: item, shareText: s.sharePdfText(item.title(lang), playStoreUrl)));
    case StudyItemType.image:
      push(StudyImageScreen(item: item));
    case StudyItemType.page:
      push(ReaderScreen(contentId: item.contentId));
    case StudyItemType.quiz:
      try {
        final set = (await services.content!.questionSets()).where((x) => x.id == item.setId).firstOrNull;
        if (set == null) {
          messenger.showSnackBar(SnackBar(content: Text(s.quizNotFound)));
        } else {
          push(QuizScreen(set: set));
        }
      } catch (_) {
        messenger.showSnackBar(SnackBar(content: Text(s.loadFailed)));
      }
    case StudyItemType.video:
      final url = item.videoUrl;
      final ok = url != null && await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).catchError((Object _) => false);
      if (!ok) messenger.showSnackBar(SnackBar(content: Text(s.couldNotOpenVideo)));
  }
}

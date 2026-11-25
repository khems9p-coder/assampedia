import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../dictionary/dictionary_screen.dart';
import 'home_drawer.dart';
import '../notifications/notifications_screen.dart';
import '../practice/daily_question_card.dart';
import '../mock/mock_tests_screen.dart';
import '../practice/practice_screen.dart';
import '../premium/paywall_screen.dart';
import '../reader/reader_screen.dart';
import '../saved/saved_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.openTab});

  /// Switches the bottom bar to another tab (see [Tabs]).
  final ValueChanged<int> openTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String>? _last;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLast();
    _jobsChecked ??= _checkJobs();
  }

  Future<void>? _jobsChecked;

  /// Loads the vacancies so the bell can show how many are new.
  Future<void> _checkJobs() async {
    final services = context.services;
    try {
      final all = await services.content?.vacancies();
      if (all != null) services.notifications.updateJobs(all);
    } catch (_) {
      // No internet: the bell just shows no count.
    }
  }

  Future<void> _loadLast() async {
    final last = await context.services.lastChapter();
    if (mounted) setState(() => _last = last);
  }

  void _push(Widget screen) => Navigator.of(context).push(SectionRoute(context, builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 900 ? 4 : (width > 600 ? 3 : 2);
    final name = (context.services.auth.profile?.fullName ?? '').trim();

    final tiles = [
      _Tile(s.encyclopedia, Icons.auto_stories_outlined, SectionColors.learn, () => widget.openTab(Tabs.learn)),
      _Tile(s.coursesTitle, Icons.route_outlined, SectionColors.courses, () => widget.openTab(Tabs.courses)),
      _Tile(s.tileExams, Icons.school_outlined, SectionColors.exams, () => widget.openTab(Tabs.exams)),
      _Tile(s.practiceZone, Icons.quiz_outlined, SectionColors.practice, () => _push(const PracticeScreen())),
      _Tile(s.mockTests, Icons.timer_outlined, SectionColors.mock, () => _push(const MockTestsScreen())),
      _Tile(s.tileJobs, Icons.badge_outlined, SectionColors.jobs, () => widget.openTab(Tabs.jobs)),
      _Tile(s.tileNews, Icons.newspaper_outlined, SectionColors.news, () => widget.openTab(Tabs.jobs)),
      _Tile(s.tileCareers, Icons.explore_outlined, SectionColors.careers, () => widget.openTab(Tabs.exams)),
      _Tile(s.dictionary, Icons.translate, SectionColors.dictionary, () => _push(const DictionaryScreen())),
      _Tile(s.saved, Icons.bookmarks_outlined, SectionColors.saved, () => _push(const SavedScreen())),
      _Tile(s.premium, Icons.workspace_premium_outlined, SectionColors.premium, () => _push(const PaywallScreen())),
    ];

    return Scaffold(
      drawer: HomeDrawer(openTab: widget.openTab),
      appBar: AppBar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        leading: Builder(
          builder: (context) =>
              IconButton(tooltip: s.openMenu, icon: const Icon(Icons.menu), onPressed: () => Scaffold.of(context).openDrawer()),
        ),
        title: const Text('ASSAMPEDIA', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        actions: [
          IconButton(tooltip: s.search, icon: const Icon(Icons.search), onPressed: () => _push(const SearchScreen())),
          ListenableBuilder(
            listenable: context.services.notifications,
            builder: (context, _) {
              final count = context.services.notifications.newJobCount;
              return IconButton(
                tooltip: count == 0 ? s.notifications : '${s.notifications}: ${s.newJobsCount(count)}',
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text(count > 9 ? '9+' : '$count'),
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () => _push(const NotificationsScreen()),
              );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: scheme.onPrimary, minimumSize: const Size(48, 48)),
            onPressed: () => context.services.language.set(lang.other),
            child: Semantics(
              label: s.switchLanguage,
              child: Text(lang.other == AppLang.assamese ? 'অ' : 'A', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadLast();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text(name.isEmpty ? s.helloNoName : s.hello(name), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            HomeSlides(
              slides: [
                HomeSlide(s.tagline, s.slideLearnCta, Icons.auto_stories, const [
                  Color(0xFF1E6B3C),
                  Color(0xFF2E8B57),
                ], () => widget.openTab(Tabs.learn)),
                HomeSlide(s.slidePremium, s.slidePremiumCta, Icons.workspace_premium, const [
                  Color(0xFF7A4A00),
                  Color(0xFFB8860B),
                ], () => _push(const PaywallScreen())),
                HomeSlide(s.slidePractice, s.slidePracticeCta, Icons.quiz, const [
                  Color(0xFF8E1F55),
                  Color(0xFFB3266B),
                ], () => _push(const PracticeScreen())),
                HomeSlide(s.slideJobs, s.slideJobsCta, Icons.work, const [
                  Color(0xFF00574F),
                  Color(0xFF00897B),
                ], () => widget.openTab(Tabs.jobs)),
              ],
            ),
            const SizedBox(height: 16),
            if (_last != null) ...[
              Card(
                child: ListTile(
                  leading: Icon(Icons.play_circle_outline, color: scheme.primary, size: 32),
                  title: Text(s.continueLearning, style: theme.textTheme.labelLarge),
                  subtitle: Text(lang.code == 'as' ? _last![1] : _last![2], maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context)
                          .push(SectionRoute(context, builder: (_) => ReaderScreen(contentId: _last![0])))
                          .then((_) => _loadLast()),
                ),
              ),
              const SizedBox(height: 12),
            ],
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: columns == 2 ? 1.35 : 1.6,
              children: [for (final t in tiles) _ColourTile(tile: t)],
            ),
            const SizedBox(height: 16),
            const DailyQuestionCard(),
          ],
        ),
      ),
    );
  }
}

class _Tile {
  const _Tile(this.title, this.icon, this.color, this.onTap);
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

/// A big coloured shortcut tile with an arrow badge.
class _ColourTile extends StatelessWidget {
  const _ColourTile({required this.tile});
  final _Tile tile;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tile.color,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: tile.onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
                    child: Icon(tile.icon, color: Colors.white, size: 28),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Icon(Icons.north_east, size: 16, color: tile.color),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                tile.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSlide {
  const HomeSlide(this.text, this.cta, this.icon, this.colors, this.onTap);
  final String text;
  final String cta;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
}

/// The sliding banner at the top of Home. Moves on by itself every 5 seconds.
class HomeSlides extends StatefulWidget {
  const HomeSlides({super.key, required this.slides});
  final List<HomeSlide> slides;

  @override
  State<HomeSlides> createState() => _HomeSlidesState();
}

class _HomeSlidesState extends State<HomeSlides> {
  final _pages = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Not in widget tests, where a running timer would hold the test open.
    final testing = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!testing) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!_pages.hasClients) return;
        final next = (_page + 1) % widget.slides.length;
        _pages.animateToPage(next, duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final height = MediaQuery.sizeOf(context).width > 600 ? 190.0 : 170.0;
    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _pages,
            itemCount: widget.slides.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final slide = widget.slides[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  borderRadius: BorderRadius.circular(22),
                  clipBehavior: Clip.antiAlias,
                  child: Ink(
                    decoration: BoxDecoration(gradient: LinearGradient(colors: slide.colors)),
                    child: InkWell(
                      onTap: slide.onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    slide.text,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                                    child: Text(
                                      slide.cta,
                                      style: TextStyle(color: slide.colors.first, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(slide.icon, color: Colors.white.withValues(alpha: 0.85), size: 72),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.slides.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == _page ? scheme.primary : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

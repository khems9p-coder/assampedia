import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/line_art.dart';
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
    final name = (context.services.auth.profile?.fullName ?? '').trim();

    final shortcuts = [
      _Tile(s.gridGk, Icons.menu_book_outlined, () => widget.openTab(Tabs.learn)),
      _Tile(s.studyTitle, Icons.local_library_outlined, () => widget.openTab(Tabs.courses)),
      _Tile(s.navExams, Icons.school_outlined, () => widget.openTab(Tabs.exams)),
      _Tile(s.navJobs, Icons.badge_outlined, () => widget.openTab(Tabs.jobs)),
      _Tile(s.gridNews, Icons.newspaper_outlined, () => widget.openTab(Tabs.jobs)),
      _Tile(s.gridCareers, Icons.explore_outlined, () => widget.openTab(Tabs.exams)),
      _Tile(s.dictionary, Icons.translate, () => _push(const DictionaryScreen())),
      _Tile(s.saved, Icons.bookmarks_outlined, () => _push(const SavedScreen())),
    ];

    void openLast() => Navigator.of(context)
        .push(SectionRoute(context, builder: (_) => ReaderScreen(contentId: _last![0])))
        .then((_) => _loadLast());

    Widget roundButton(String tooltip, Widget icon, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: scheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: scheme.outlineVariant)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: SizedBox(width: 42, height: 42, child: Center(child: icon)),
          ),
        ),
      ),
    );

    return Scaffold(
      drawer: HomeDrawer(openTab: widget.openTab),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _loadLast,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                children: [
                  // Top row: menu + logo + name, then search, bell and language.
                  Row(
                    children: [
                      Builder(
                        builder: (context) => InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Semantics(
                            label: s.openMenu,
                            button: true,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Image.asset('assets/brand/logo.png', width: 34, height: 34),
                                  const SizedBox(width: 10),
                                  const Text('ASSAMPEDIA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: 0.8)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      roundButton(s.search, const Icon(Icons.search, size: 22), () => _push(const SearchScreen())),
                      ListenableBuilder(
                        listenable: context.services.notifications,
                        builder: (context, _) {
                          final count = context.services.notifications.newJobCount;
                          return roundButton(
                            count == 0 ? s.notifications : '${s.notifications}: ${s.newJobsCount(count)}',
                            Badge(
                              isLabelVisible: count > 0,
                              label: Text(count > 9 ? '9+' : '$count'),
                              child: const Icon(Icons.notifications_outlined, size: 22),
                            ),
                            () => _push(const NotificationsScreen()),
                          );
                        },
                      ),
                      roundButton(
                        s.switchLanguage,
                        Text(lang.other == AppLang.assamese ? 'অ' : 'A', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        () => context.services.language.set(lang.other),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(name.isEmpty ? s.helloNoName : s.hello(name), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(s.helloSub, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  // The three things most people do every day.
                  _QuickBar(
                    items: [
                      _Tile(s.quickRead, Icons.auto_stories_outlined, _last != null ? openLast : () => widget.openTab(Tabs.learn)),
                      _Tile(s.quickPractice, Icons.quiz_outlined, () => _push(const PracticeScreen())),
                      _Tile(s.quickMock, Icons.timer_outlined, () => _push(const MockTestsScreen())),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Everything else, in one tidy grid.
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        childAspectRatio: width > 600 ? 1.6 : 1.05,
                        children: [for (final t in shortcuts) _GridButton(tile: t)],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _PremiumCard(onTap: () => _push(const PaywallScreen())),
                  if (_last != null) ...[
                    const SizedBox(height: 18),
                    Text(s.continueLearning, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.history_edu_outlined, color: scheme.onPrimaryContainer),
                        ),
                        title: Text(
                          lang.code == 'as' ? _last![1] : _last![2],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: openLast,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const DailyQuestionCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile {
  const _Tile(this.title, this.icon, this.onTap);
  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

/// The black bar with the three daily actions.
class _QuickBar extends StatelessWidget {
  const _QuickBar({required this.items});
  final List<_Tile> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primary,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            for (final t in items)
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: t.onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Icon(t.icon, color: scheme.onPrimary, size: 26),
                        const SizedBox(height: 6),
                        Text(
                          t.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// One icon with its name underneath, in the Home grid.
class _GridButton extends StatelessWidget {
  const _GridButton({required this.tile});
  final _Tile tile;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: tile.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tile.icon, size: 26, color: scheme.onSurface),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              tile.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}

/// A soft gold card with a line drawing that leads to Premium.
class _PremiumCard extends StatelessWidget {
  const _PremiumCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.premium, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(s.slidePremium, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onTertiaryContainer)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(999)),
                      child: Text(s.slidePremiumCta, style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const LineArtView(LineArt.town, height: 88),
            ],
          ),
        ),
      ),
    );
  }
}

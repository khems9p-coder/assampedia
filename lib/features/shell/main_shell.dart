import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/theme/section_theme.dart';
import '../account/account_screen.dart';
import '../exams/exams_screen.dart';
import '../jobs/jobs_screen.dart';
import '../home/home_screen.dart';
import '../learn/learn_screen.dart';

/// The bottom navigation bar and its five tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(openTab: _go),
          const SectionTheme(color: SectionColors.learn, child: LearnScreen()),
          const SectionTheme(color: SectionColors.exams, child: ExamsScreen()),
          const SectionTheme(color: SectionColors.jobs, child: JobsScreen()),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: _FloatingNavBar(
        index: _index,
        onTap: _go,
        colors: const [null, SectionColors.learn, SectionColors.exams, SectionColors.jobs, null],
        items: [
          (Icons.home_outlined, Icons.home, s.navHome),
          (Icons.menu_book_outlined, Icons.menu_book, s.navLearn),
          (Icons.school_outlined, Icons.school, s.navExams),
          (Icons.work_outline, Icons.work, s.navJobs),
          (Icons.person_outline, Icons.person, s.navMe),
        ],
      ),
    );
  }
}

/// A rounded bottom bar that floats above the page edge.
class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({required this.index, required this.onTap, required this.items, required this.colors});
  final int index;
  final ValueChanged<int> onTap;
  final List<(IconData, IconData, String)> items;

  /// Each tab's section colour (null: the app's green).
  final List<Color?> colors;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    Color accent(int i) {
      final c = colors[i];
      if (c == null) return scheme.onPrimaryContainer;
      return dark ? Color.lerp(c, Colors.white, 0.55)! : c;
    }

    Color fill(int i) => colors[i] == null ? scheme.primaryContainer : colors[i]!.withValues(alpha: dark ? 0.35 : 0.16);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
        child: Material(
          elevation: 6,
          shadowColor: Colors.black26,
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: Semantics(
                      selected: i == index,
                      button: true,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => onTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 56,
                          decoration: BoxDecoration(
                            color: i == index ? fill(i) : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(i == index ? items[i].$2 : items[i].$1, color: i == index ? accent(i) : scheme.onSurfaceVariant),
                              const SizedBox(height: 2),
                              Text(
                                items[i].$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                                  color: i == index ? accent(i) : scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

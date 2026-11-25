import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../account/account_screen.dart';
import '../courses/courses_screen.dart';
import '../exams/exams_screen.dart';
import '../jobs/jobs_screen.dart';
import '../home/home_screen.dart';
import '../learn/learn_screen.dart';

/// The bottom navigation bar and its six tabs.
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
          const LearnScreen(),
          const CoursesScreen(),
          const ExamsScreen(),
          const JobsScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: _FloatingNavBar(
        index: _index,
        onTap: _go,
        items: [
          (Icons.home_outlined, Icons.home, s.navHome),
          (Icons.menu_book_outlined, Icons.menu_book, s.navLearn),
          (Icons.route_outlined, Icons.route, s.navCourses),
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
  const _FloatingNavBar({required this.index, required this.onTap, required this.items});
  final int index;
  final ValueChanged<int> onTap;
  final List<(IconData, IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
                            color: i == index ? scheme.primaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                i == index ? items[i].$2 : items[i].$1,
                                color: i == index ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                items[i].$3,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                                  color: i == index ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
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

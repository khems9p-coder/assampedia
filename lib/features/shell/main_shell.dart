import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../account/account_screen.dart';
import '../study/study_screen.dart';
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
          const StudyScreen(),
          const ExamsScreen(),
          const JobsScreen(),
          const AccountScreen(),
        ],
      ),
      bottomNavigationBar: _SimpleNavBar(
        index: _index,
        onTap: _go,
        items: [
          (Icons.home_outlined, Icons.home, s.navHome),
          (Icons.menu_book_outlined, Icons.menu_book, s.navLearn),
          (Icons.local_library_outlined, Icons.local_library, s.navCourses),
          (Icons.school_outlined, Icons.school, s.navExams),
          (Icons.work_outline, Icons.work, s.navJobs),
          (Icons.person_outline, Icons.person, s.navMe),
        ],
      ),
    );
  }
}

/// A plain white bottom bar. The open tab is shown in black with a small dot.
class _SimpleNavBar extends StatelessWidget {
  const _SimpleNavBar({required this.index, required this.onTap, required this.items});
  final int index;
  final ValueChanged<int> onTap;
  final List<(IconData, IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    selected: i == index,
                    button: true,
                    child: InkResponse(
                      onTap: () => onTap(i),
                      radius: 32,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            i == index ? items[i].$2 : items[i].$1,
                            size: 24,
                            color: i == index ? scheme.onSurface : scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            items[i].$3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                              color: i == index ? scheme.onSurface : scheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: i == index ? 5 : 0,
                            height: 5,
                            decoration: BoxDecoration(color: scheme.onSurface, shape: BoxShape.circle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

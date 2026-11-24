import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../learn/chapter_list_screen.dart';
import '../search/search_screen.dart';

/// The Exams tab: the exam syllabus library and government career profiles.
class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.examsTitle),
          actions: [
            IconButton(
              tooltip: s.search,
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => const SearchScreen())),
            ),
            const Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch()),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.assignment_outlined), text: s.examsTab),
              Tab(icon: const Icon(Icons.badge_outlined), text: s.careersTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SectionList(section: 'exam', intro: s.examsIntro),
            _SectionList(section: 'job', intro: s.careersIntro),
          ],
        ),
      ),
    );
  }
}

class _SectionList extends StatefulWidget {
  const _SectionList({required this.section, required this.intro});
  final String section;
  final String intro;

  @override
  State<_SectionList> createState() => _SectionListState();
}

class _SectionListState extends State<_SectionList> with AutomaticKeepAliveClientMixin {
  Future<List<Category>>? _cats;

  @override
  bool get wantKeepAlive => true;

  Future<List<Category>>? _fetch() => context.services.content?.categories(section: widget.section);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cats ??= _fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = context.s;
    final lang = context.lang;
    final scheme = Theme.of(context).colorScheme;
    if (_cats == null) return Center(child: Text(s.notConnected));
    return FutureBuilder<List<Category>>(
      future: _cats,
      builder: (context, snap) {
        if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _cats = _fetch()));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final cats = snap.data!;
        return RefreshIndicator(
          onRefresh: () async => setState(() => _cats = _fetch()),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: Text(widget.intro)),
              if (cats.isEmpty) Padding(padding: const EdgeInsets.all(16), child: Text(s.noChapters)),
              for (final c in cats)
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(categoryIcon(c.icon), color: scheme.onPrimaryContainer),
                  ),
                  title: Text(c.name(lang)),
                  subtitle: Text(c.name(lang.other)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(SectionRoute(context, builder: (_) => ChapterListScreen(category: c))),
                ),
            ],
          ),
        );
      },
    );
  }
}

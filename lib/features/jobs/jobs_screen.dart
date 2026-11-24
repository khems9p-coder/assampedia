import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/jobs_models.dart';
import '../../data/models.dart';
import '../reader/reader_screen.dart';
import 'vacancy_detail_screen.dart';
import 'vacancy_widgets.dart';

/// The Jobs tab: government vacancies and current affairs.
class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.jobsTitle),
          actions: const [Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch())],
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.work_outline), text: s.vacanciesTab),
              Tab(icon: const Icon(Icons.newspaper_outlined), text: s.newsTab),
            ],
          ),
        ),
        body: const TabBarView(children: [VacancyList(), NewsList()]),
      ),
    );
  }
}

enum _Show { open, closed, saved }

class VacancyList extends StatefulWidget {
  const VacancyList({super.key});

  @override
  State<VacancyList> createState() => _VacancyListState();
}

class _VacancyListState extends State<VacancyList> with AutomaticKeepAliveClientMixin {
  Future<List<Vacancy>>? _future;
  _Show _show = _Show.open;
  JobCategory? _category;
  String? _state;
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  Future<List<Vacancy>>? _fetch() {
    final f = context.services.content?.vacancies();
    f?.then(context.services.savedJobs.refreshFrom).catchError((_) {});
    return f;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _fetch();
  }

  List<Vacancy> _filter(List<Vacancy> all) {
    final list = all.where((v) {
      final st = v.status();
      final inTab = switch (_show) {
        _Show.open => st.canApply,
        _Show.closed => !st.canApply,
        _Show.saved => true,
      };
      return inTab &&
          (_category == null || v.category == _category) &&
          (_state == null || v.state == _state) &&
          (_query.trim().isEmpty || v.matches(_query.trim()));
    }).toList();
    // Open jobs: soonest deadline first. Closed: most recent first.
    list.sort((a, b) => _show == _Show.closed ? b.closingDate.compareTo(a.closingDate) : a.closingDate.compareTo(b.closingDate));
    return list;
  }

  void _open(Vacancy v) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => VacancyDetailScreen(vacancy: v)));

  Widget _filters(List<Vacancy> all) {
    final s = context.s;
    final states = {for (final v in all) ?v.state}.toList()..sort();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<_Show>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: _Show.open, label: Text(s.openNow)),
              ButtonSegment(value: _Show.closed, label: Text(s.closedAndResults)),
              ButtonSegment(value: _Show.saved, label: Text(s.saved)),
            ],
            selected: {_show},
            onSelectionChanged: (v) => setState(() => _show = v.first),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: s.searchJobs,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              DropdownButton<JobCategory?>(
                value: _category,
                hint: Text(s.allCategories),
                onChanged: (c) => setState(() => _category = c),
                items: [
                  DropdownMenuItem(value: null, child: Text(s.allCategories)),
                  for (final c in JobCategory.values) DropdownMenuItem(value: c, child: Text(c.name(context.lang))),
                ],
              ),
              if (states.length > 1)
                DropdownButton<String?>(
                  value: _state,
                  hint: Text(s.allStates),
                  onChanged: (v) => setState(() => _state = v),
                  items: [
                    DropdownMenuItem(value: null, child: Text(s.allStates)),
                    for (final st in states) DropdownMenuItem(value: st, child: Text(st)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = context.s;
    if (_future == null) return Center(child: Text(s.notConnected));
    return ListenableBuilder(
      listenable: context.services.savedJobs,
      builder: (context, _) => FutureBuilder<List<Vacancy>>(
        future: _future,
        builder: (context, snap) {
          final saved = context.services.savedJobs.items;
          if (snap.hasError && _show != _Show.saved) {
            return LoadError(message: s.loadFailed, onRetry: () => setState(() => _future = _fetch()));
          }
          if (!snap.hasData && !snap.hasError) return const Center(child: CircularProgressIndicator());
          final all = _show == _Show.saved ? saved : (snap.data ?? const <Vacancy>[]);
          final list = _filter(all);
          return RefreshIndicator(
            onRefresh: () async => setState(() => _future = _fetch()),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    _filters(snap.data ?? saved),
                    if (list.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Center(child: Text(_show == _Show.saved ? s.noSavedJobs : s.noVacancies)),
                      ),
                    for (final v in list)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: VacancyCard(vacancy: v, onTap: () => _open(v)),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with AutomaticKeepAliveClientMixin {
  Future<(List<NewsItem>, List<Category>)>? _future;
  NewsPeriod _period = NewsPeriod.week;
  String? _group;

  @override
  bool get wantKeepAlive => true;

  Future<(List<NewsItem>, List<Category>)>? _fetch() {
    final repo = context.services.content;
    if (repo == null) return null;
    return Future.wait([repo.currentAffairs(), repo.categories(section: 'ca')]).then((r) => (r[0] as List<NewsItem>, r[1] as List<Category>));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _fetch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    if (_future == null) return Center(child: Text(s.notConnected));
    return FutureBuilder<(List<NewsItem>, List<Category>)>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _future = _fetch()));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final (items, groups) = snap.data!;
        final today = DateTime.now();
        final list = [
          for (final n in items)
            if (inPeriod(n.date, _period, today) && (_group == null || n.categoryId == _group)) n,
        ];
        final children = <Widget>[];
        String? lastHeader;
        for (final n in list) {
          final header = n.date == null ? '' : formatDate(n.date!);
          if (header != lastHeader) {
            children.add(
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(header, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
              ),
            );
            lastHeader = header;
          }
          final group = groups.where((g) => g.id == n.categoryId);
          children.add(
            ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(n.title(lang)),
              subtitle: group.isEmpty ? null : Text(group.first.name(lang)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReaderScreen(contentId: n.id))),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => setState(() => _future = _fetch()),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: SegmentedButton<NewsPeriod>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(value: NewsPeriod.today, label: Text(s.periodToday)),
                        ButtonSegment(value: NewsPeriod.week, label: Text(s.periodWeek)),
                        ButtonSegment(value: NewsPeriod.month, label: Text(s.periodMonth)),
                        ButtonSegment(value: NewsPeriod.all, label: Text(s.periodAll)),
                      ],
                      selected: {_period},
                      onSelectionChanged: (v) => setState(() => _period = v.first),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        for (final g in [null, ...groups])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(g == null ? s.allGroups : g.name(lang)),
                              selected: _group == g?.id,
                              onSelected: (_) => setState(() => _group = g?.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (list.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(s.noNews))),
                  ...children,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

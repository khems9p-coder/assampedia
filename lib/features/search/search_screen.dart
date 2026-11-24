import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/section_theme.dart';

import '../../core/app_scope.dart';
import '../../data/models.dart';
import '../dictionary/term_sheet.dart';
import '../reader/reader_screen.dart';

/// Search chapters (both languages) and dictionary terms.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _box = TextEditingController();
  Timer? _debounce;
  Future<SearchResults>? _results;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _box.dispose();
    super.dispose();
  }

  void _changed(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _run(v));
  }

  void _run(String v) {
    final q = cleanQuery(v);
    final repo = context.services.content;
    setState(() {
      _query = q;
      _results = (q.length < 2 || repo == null) ? null : repo.search(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _box,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(hintText: s.searchHint, border: InputBorder.none),
          onChanged: _changed,
          onSubmitted: _run,
        ),
        actions: [
          if (_box.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _box.clear();
                _run('');
              },
            ),
        ],
      ),
      body: _results == null
          ? Center(child: Text(_query.isEmpty ? s.searchHint : s.typeMore, style: theme.textTheme.bodyLarge))
          : FutureBuilder<SearchResults>(
              future: _results,
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text(s.loadFailed));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final r = snap.data!;
                if (r.chapters.isEmpty && r.terms.isEmpty) {
                  return Center(child: Text(r.offline ? '${s.noResults}\n${s.searchOffline}' : s.noResults, textAlign: TextAlign.center));
                }
                // Show matches in the reading language first.
                final hits = [...r.chapters]..sort((a, b) => (a.lang == lang ? 0 : 1).compareTo(b.lang == lang ? 0 : 1));
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: ListView(
                      children: [
                        if (r.offline)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: Text(s.searchOffline, style: theme.textTheme.bodySmall),
                          ),
                        if (r.terms.isNotEmpty) ...[
                          _Heading(s.dictionary),
                          for (final t in r.terms)
                            ListTile(
                              leading: const Icon(Icons.menu_book_outlined),
                              title: Text(t.name(lang)),
                              subtitle: Text(
                                t.meaningIn(lang) ?? t.meaningIn(lang.other) ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () => showTermSheet(context, term: t),
                            ),
                        ],
                        if (hits.isNotEmpty) ...[
                          _Heading(s.chaptersHeading),
                          for (final h in hits)
                            ListTile(
                              leading: const Icon(Icons.article_outlined),
                              title: Text(h.title(lang)),
                              subtitle: Text(h.snippet, maxLines: 3, overflow: TextOverflow.ellipsis),
                              trailing: h.lang == lang ? null : Text(h.lang.label, style: theme.textTheme.labelSmall),
                              onTap: () => Navigator.of(context).push(
                                SectionRoute(
                                  context,
                                  builder: (_) => ReaderScreen(contentId: h.contentId, initialBlockKey: h.blockKey),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
  );
}

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/widgets/line_art.dart';
import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/bookmark_store.dart';
import '../../data/cached_content_repository.dart';
import '../../data/models.dart';
import '../dictionary/term_sheet.dart';
import '../premium/paywall_screen.dart';
import 'block_view.dart';
import 'official_info.dart';

/// One row of the reading list: a paragraph in the reading language and,
/// in side-by-side mode, the same paragraph in the other language.
class ReaderRow {
  ReaderRow(this.primary, this.secondary);
  final Block? primary;
  final Block? secondary;
  Block get anchor => (primary ?? secondary)!;
  String get key => anchor.key;
}

/// Builds the rows for [lang]. With [side], paragraphs are paired by their
/// shared key; paragraphs only in the other language go at the end.
List<ReaderRow> buildReaderRows(Chapter ch, AppLang lang, bool side) {
  final main = ch.versions[lang]?.blocks ?? const <Block>[];
  if (!side || !ch.has(lang.other)) return [for (final b in main) ReaderRow(b, null)];
  final other = ch.versions[lang.other]!.blocks;
  final byKey = {for (final b in other) b.key: b};
  final used = <String>{};
  final rows = <ReaderRow>[];
  for (final b in main) {
    final o = byKey[b.key];
    if (o != null) used.add(o.key);
    rows.add(ReaderRow(b, o));
  }
  for (final o in other) {
    if (!used.contains(o.key)) rows.add(ReaderRow(null, o));
  }
  return rows;
}

/// Maps a list position (0 = title, last = sources) from one set of rows to another.
int mapReaderIndex(List<ReaderRow> from, int index, List<ReaderRow> to) {
  if (index <= 0 || from.isEmpty) return 0;
  if (index > from.length) return to.length + 1;
  return matchingBlockIndex([for (final r in from) r.anchor], index - 1, [for (final r in to) r.anchor]) + 1;
}

/// The chapter reading screen. Switching language jumps to the same
/// paragraph in the other language.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, this.contentId, this.preview, this.initialBlockKey}) : assert(contentId != null || preview != null);

  final String? contentId;

  /// When set, shows this chapter directly (the admin's preview before saving).
  final Chapter? preview;

  /// Opens the chapter at this paragraph (from Saved or Search).
  final String? initialBlockKey;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _scroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  Future<Chapter>? _future;
  bool _locked = false;
  Chapter? _chapter;
  bool _offline = false;
  bool _side = false;
  Map<String, Term> _terms = const {};
  List<ReaderRow> _rows = const [];
  String? _wantKey;
  int _initialIndex = 0;

  @override
  void initState() {
    super.initState();
    _wantKey = widget.initialBlockKey;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_future == null) {
      _future = _load();
      _loadExtras();
    }
  }

  Future<void> _loadExtras() async {
    final services = context.services;
    final side = await services.sideBySide();
    if (mounted && side != _side) setState(() => _side = side);
    try {
      final list = await services.terms();
      if (mounted) setState(() => _terms = {for (final t in list) t.slug: t});
    } catch (_) {
      // Terms stay plain words until the dictionary can be loaded.
    }
  }

  Future<Chapter> _load() async {
    if (widget.preview != null) return widget.preview!;
    final services = context.services;
    final repo = services.content!;
    final ch = await repo.chapter(widget.contentId!);
    _offline = repo is CachedContentRepository && repo.lastWasOffline;
    // Premium pages come without paragraphs for free readers.
    final empty = ch.versions.values.every((v) => v.blocks.isEmpty);
    _locked = empty && !services.premium.isPremium && !await services.premium.contentIsFree(ch.id);
    if (_locked) return ch;
    final titles = _titles(ch);
    services.rememberChapter(ch.id, titles.$1, titles.$2);
    return ch;
  }

  (String, String) _titles(Chapter ch) {
    final t = {for (final e in ch.versions.entries) e.key: e.value.title};
    final fallback = t.values.isEmpty ? ch.slug : t.values.first;
    return (t[AppLang.assamese] ?? fallback, t[AppLang.english] ?? fallback);
  }

  /// The list item at the top of the screen right now.
  int _topIndex() {
    final visible = _positions.itemPositions.value.where((p) => p.itemTrailingEdge > 0.02).toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    return visible.isEmpty ? 0 : visible.first.index;
  }

  /// Rebuilds the list for a new language or layout, staying at the same paragraph.
  void _relayout(AppLang lang, bool side) {
    final ch = _chapter;
    if (ch != null) _initialIndex = mapReaderIndex(_rows, _topIndex(), buildReaderRows(ch, lang, side));
  }

  void _switchTo(AppLang target) {
    _relayout(target, _side);
    context.services.language.set(target);
  }

  void _toggleSide() {
    final on = !_side;
    _relayout(context.lang, on);
    setState(() => _side = on);
    context.services.setSideBySide(on);
  }

  Future<void> _toggleBookmark(Chapter ch) async {
    final s = context.s;
    final store = context.services.bookmarks;
    final messenger = ScaffoldMessenger.of(context);
    if (store.contains(ch.id)) {
      await store.remove(ch.id);
      messenger.showSnackBar(SnackBar(content: Text(s.removedSaved)));
      return;
    }
    final top = _topIndex();
    final key = (top >= 1 && top <= _rows.length) ? _rows[top - 1].key : null;
    final titles = _titles(ch);
    await store.save(Bookmark(contentId: ch.id, blockKey: key, titleAs: titles.$1, titleEn: titles.$2, savedAt: DateTime.now()));
    messenger.showSnackBar(SnackBar(content: Text(s.savedDone)));
  }

  void _openTerm(String slug) => showTermSheet(context, term: _terms[slug], missingSlug: slug);

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final ch = _chapter;
    final canSide = ch != null && ch.has(lang) && ch.has(lang.other);
    return Scaffold(
      appBar: AppBar(
        title: widget.preview != null ? const Text('Preview') : null,
        actions: [
          if (canSide)
            IconButton(
              tooltip: s.sideBySide,
              isSelected: _side,
              onPressed: _toggleSide,
              icon: const Icon(Icons.vertical_split_outlined),
              selectedIcon: const Icon(Icons.vertical_split),
            ),
          if (widget.preview == null && ch != null)
            ListenableBuilder(
              listenable: context.services.bookmarks,
              builder: (context, _) {
                final saved = context.services.bookmarks.contains(ch.id);
                return IconButton(
                  tooltip: s.saveChapter,
                  onPressed: () => _toggleBookmark(ch),
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LanguageSwitch(onChanged: _switchTo),
          ),
        ],
      ),
      body: FutureBuilder<Chapter>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _future = _load()));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final ch = snap.data!;
          if (_locked) return const PaywallBody(locked: true);
          if (_chapter == null) {
            _chapter = ch;
            // Show the side-by-side and bookmark buttons now that the chapter is here.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          }
          final version = ch.versions[lang];
          if (version == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.translate, size: 48, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 12),
                    Text(s.notAvailableIn(lang), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 16),
                    if (ch.has(lang.other)) FilledButton(onPressed: () => _switchTo(lang.other), child: Text(s.readIn(lang.other))),
                  ],
                ),
              ),
            );
          }
          final side = _side && ch.has(lang.other);
          final rows = _rows = buildReaderRows(ch, lang, side);
          if (_wantKey != null) {
            final i = rows.indexWhere((r) => r.key == _wantKey);
            if (i >= 0) _initialIndex = i + 1;
            _wantKey = null;
          }
          final other = side ? ch.versions[lang.other] : null;
          return Column(
            children: [
              if (_offline) MaterialBanner(content: Text(s.offlineNotice), actions: const [SizedBox.shrink()]),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    final wide = box.maxWidth >= 700;
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: side && wide ? 1200 : 760),
                        child: ScrollablePositionedList.builder(
                          key: ValueKey('${lang.code}-$side'),
                          initialScrollIndex: _initialIndex.clamp(0, rows.length + 1),
                          itemScrollController: _scroll,
                          itemPositionsListener: _positions,
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                          itemCount: rows.length + 2,
                          itemBuilder: (context, i) {
                            if (i == 0) return _Header(version: version, other: other, lang: lang, wide: wide, chapter: ch);
                            if (i == rows.length + 1) return _Footer(version: version);
                            final r = rows[i - 1];
                            final main = r.primary == null
                                ? const SizedBox.shrink()
                                : BlockView(block: r.primary!, terms: _terms, onTerm: _openTerm);
                            if (!side) return main;
                            final second = r.secondary == null
                                ? const SizedBox.shrink()
                                : BlockView(block: r.secondary!, terms: _terms, onTerm: _openTerm, lang: lang.other);
                            return _SidePair(main: main, second: second, wide: wide);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A paragraph and its translation: next to each other on wide screens,
/// one under the other on phones.
class _SidePair extends StatelessWidget {
  const _SidePair({required this.main, required this.second, required this.wide});
  final Widget main;
  final Widget second;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: main),
          const SizedBox(width: 24),
          Expanded(child: second),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        main,
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: scheme.outlineVariant, width: 3)),
          ),
          child: second,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.version, this.other, required this.lang, required this.wide, required this.chapter});
  final Chapter chapter;
  final ChapterVersion version;
  final ChapterVersion? other;
  final AppLang lang;
  final bool wide;

  Widget _one(BuildContext context, ChapterVersion v, {String? label, bool muted = false}) {
    final theme = Theme.of(context);
    final mutedColor = theme.colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
        Text(
          v.title,
          style: (muted ? theme.textTheme.titleLarge : theme.textTheme.headlineSmall)?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.3,
            color: muted ? mutedColor : null,
          ),
        ),
        if (v.summary != null && v.summary!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(v.summary!, style: theme.textTheme.titleMedium?.copyWith(color: mutedColor, height: 1.5)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = other;
    Widget body;
    if (o == null) {
      body = _one(context, version);
    } else if (wide) {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _one(context, version, label: lang.label)),
          const SizedBox(width: 24),
          Expanded(child: _one(context, o, label: lang.other.label)),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_one(context, version), const SizedBox(height: 6), _one(context, o, muted: true)],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A quiet line drawing above the title.
          Container(
            height: wide ? 150 : 120,
            margin: const EdgeInsets.only(top: 4, bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: LineArtView(LineArt.heritage, height: wide ? 120 : 96),
          ),
          body,
          if (chapter.appliesTo != null || chapter.officialUrl != null || chapter.notificationUrl != null) ...[
            const SizedBox(height: 12),
            OfficialInfo(chapter: chapter),
          ],
          const Divider(height: 28),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.version});
  final ChapterVersion version;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    if ((version.sources ?? '').isEmpty && version.lastChecked == null) return const SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          if ((version.sources ?? '').isNotEmpty) ...[
            Text(s.sources, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            SelectableText(version.sources!, style: small),
          ],
          if (version.lastChecked != null) ...[const SizedBox(height: 8), Text(s.lastChecked(version.lastChecked!), style: small)],
        ],
      ),
    );
  }
}

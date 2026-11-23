import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/cached_content_repository.dart';
import '../../data/models.dart';
import 'block_view.dart';

/// The chapter reading screen. Switching language jumps to the same
/// paragraph in the other language.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, this.contentId, this.preview}) : assert(contentId != null || preview != null);

  final String? contentId;

  /// When set, shows this chapter directly (the admin's preview before saving).
  final Chapter? preview;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _scroll = ItemScrollController();
  final _positions = ItemPositionsListener.create();
  Future<Chapter>? _future;
  Chapter? _chapter;
  bool _offline = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<Chapter> _load() async {
    if (widget.preview != null) return widget.preview!;
    final services = context.services;
    final repo = services.content!;
    final ch = await repo.chapter(widget.contentId!);
    _offline = repo is CachedContentRepository && repo.lastWasOffline;
    final titles = {for (final e in ch.versions.entries) e.key: e.value.title};
    final fallback = titles.values.isEmpty ? ch.slug : titles.values.first;
    services.rememberChapter(ch.id, titles[AppLang.assamese] ?? fallback, titles[AppLang.english] ?? fallback);
    return ch;
  }

  /// The list item at the top of the screen right now.
  int _topIndex() {
    final visible = _positions.itemPositions.value.where((p) => p.itemTrailingEdge > 0.02).toList()
      ..sort((a, b) => a.index.compareTo(b.index));
    return visible.isEmpty ? 0 : visible.first.index;
  }

  void _switchTo(AppLang target) {
    final ch = _chapter;
    final from = context.lang;
    var targetIndex = 0;
    if (ch != null && ch.has(from) && ch.has(target)) {
      final fromBlocks = ch.versions[from]!.blocks;
      final toBlocks = ch.versions[target]!.blocks;
      final top = _topIndex();
      if (top == 0) {
        targetIndex = 0;
      } else if (top > fromBlocks.length) {
        targetIndex = toBlocks.length + 1; // footer
      } else {
        targetIndex = matchingBlockIndex(fromBlocks, top - 1, toBlocks) + 1;
      }
    }
    context.services.language.set(target);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.isAttached) _scroll.jumpTo(index: targetIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return Scaffold(
      appBar: AppBar(
        title: widget.preview != null ? const Text('Preview') : null,
        actions: [Padding(padding: const EdgeInsets.only(right: 8), child: LanguageSwitch(onChanged: _switchTo))],
      ),
      body: FutureBuilder<Chapter>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: s.loadFailed, onRetry: () => setState(() => _future = _load()));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final ch = _chapter = snap.data!;
          final version = ch.versions[lang];
          if (version == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.translate, size: 48, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(s.notAvailableIn(lang), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  if (ch.has(lang.other))
                    FilledButton(onPressed: () => _switchTo(lang.other), child: Text(s.readIn(lang.other))),
                ]),
              ),
            );
          }
          final blocks = version.blocks;
          return Column(children: [
            if (_offline)
              MaterialBanner(content: Text(s.offlineNotice), actions: const [SizedBox.shrink()]),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: ScrollablePositionedList.builder(
                    key: ValueKey(lang),
                    itemScrollController: _scroll,
                    itemPositionsListener: _positions,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    itemCount: blocks.length + 2,
                    itemBuilder: (context, i) {
                      if (i == 0) return _Header(version: version);
                      if (i == blocks.length + 1) return _Footer(version: version);
                      return BlockView(block: blocks[i - 1]);
                    },
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.version});
  final ChapterVersion version;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(version.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.3)),
        if (version.summary != null && version.summary!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(version.summary!, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.5)),
        ],
        const Divider(height: 28),
      ]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        if ((version.sources ?? '').isNotEmpty) ...[
          Text(s.sources, style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          SelectableText(version.sources!, style: small),
        ],
        if (version.lastChecked != null) ...[
          const SizedBox(height: 8),
          Text(s.lastChecked(version.lastChecked!), style: small),
        ],
      ]),
    );
  }
}

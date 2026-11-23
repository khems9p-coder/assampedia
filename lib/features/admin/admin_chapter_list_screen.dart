import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import 'chapter_editor_screen.dart';

/// All chapters in a category, including drafts, with each language's status.
class AdminChapterListScreen extends StatefulWidget {
  const AdminChapterListScreen({super.key, required this.category});
  final Category category;

  @override
  State<AdminChapterListScreen> createState() => _AdminChapterListScreenState();
}

class _AdminChapterListScreenState extends State<AdminChapterListScreen> {
  late Future<List<ChapterSummary>> _list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reload();
  }

  void _reload() => setState(() => _list = context.services.admin!.chapters(widget.category.id));

  Future<void> _open({String? id, int position = 0}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChapterEditorScreen(category: widget.category, contentId: id, newPosition: position),
    ));
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.nameEn)),
      floatingActionButton: FutureBuilder<List<ChapterSummary>>(
        future: _list,
        builder: (context, snap) => FloatingActionButton.extended(
          onPressed: () => _open(position: (snap.data?.length ?? 0) + 1),
          icon: const Icon(Icons.add),
          label: const Text('New chapter'),
        ),
      ),
      body: FutureBuilder<List<ChapterSummary>>(
        future: _list,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: '${snap.error}', onRetry: _reload);
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('No chapters yet. Tap "New chapter".'));
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final c = list[i];
              return ListTile(
                title: Text(c.title(AppLang.english)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(spacing: 6, children: [
                    for (final l in AppLang.values) _StatusChip(lang: l, status: c.statuses[l]),
                  ]),
                ),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => _open(id: c.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.lang, required this.status});
  final AppLang lang;
  final String? status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      'published' => ('Published', scheme.primary),
      'draft' => ('Draft', scheme.tertiary),
      _ => ('Missing', scheme.error),
    };
    return Chip(
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      label: Text('${lang.label}: $label', style: TextStyle(color: color, fontSize: 12)),
    );
  }
}

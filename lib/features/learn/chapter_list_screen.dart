import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../reader/reader_screen.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({super.key, required this.category});
  final Category category;

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  late Future<List<ChapterSummary>> _chapters;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chapters = context.services.content!.chapters(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.name(lang))),
      body: FutureBuilder<List<ChapterSummary>>(
        future: _chapters,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(
                message: s.loadFailed,
                onRetry: () => setState(() => _chapters = context.services.content!.chapters(widget.category.id)));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = snap.data!;
          if (list.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(s.noChapters)));
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, i) {
              final c = list[i];
              final missing = !c.titles.containsKey(lang);
              return ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(c.title(lang)),
                subtitle: missing ? Text(s.notAvailableIn(lang), style: TextStyle(color: Theme.of(context).colorScheme.error)) : null,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReaderScreen(contentId: c.id))),
              );
            },
          );
        },
      ),
    );
  }
}

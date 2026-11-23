import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import 'chapter_list_screen.dart';

/// All Assam GK categories.
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  Future<List<Category>>? _cats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cats ??= context.services.content?.categories();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(title: Text(s.encyclopedia), actions: const [Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch())]),
      body: _cats == null
          ? Center(child: Text(s.notConnected))
          : FutureBuilder<List<Category>>(
              future: _cats,
              builder: (context, snap) {
                if (snap.hasError) {
                  return LoadError(message: s.loadFailed, onRetry: () => setState(() => _cats = context.services.content?.categories()));
                }
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final cats = snap.data!;
                return RefreshIndicator(
                  onRefresh: () async => setState(() => _cats = context.services.content?.categories()),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: cats.length,
                    separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
                    itemBuilder: (context, i) {
                      final c = cats[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(categoryIcon(c.icon), color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                        title: Text(c.name(context.lang)),
                        subtitle: Text(c.name(context.lang.other)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChapterListScreen(category: c))),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

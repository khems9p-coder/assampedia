import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../reader/reader_screen.dart';

/// Chapters the reader bookmarked. Opens each one at the saved paragraph.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final store = context.services.bookmarks;
    return Scaffold(
      appBar: AppBar(title: Text(s.saved)),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final items = store.items;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(s.noSaved, textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final b = items[i];
              final lang = context.lang;
              return ListTile(
                leading: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary),
                title: Text(lang == AppLang.assamese ? b.titleAs : b.titleEn),
                subtitle: Text(lang == AppLang.assamese ? b.titleEn : b.titleAs),
                trailing: IconButton(tooltip: s.remove, icon: const Icon(Icons.close), onPressed: () => store.remove(b.contentId)),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReaderScreen(contentId: b.contentId, initialBlockKey: b.blockKey),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

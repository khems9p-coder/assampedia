import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import 'term_sheet.dart';

/// Every dictionary term, with a filter box.
class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  Future<List<Term>>? _terms;
  String _filter = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _terms ??= context.services.terms();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.dictionary),
        actions: const [Padding(padding: EdgeInsets.only(right: 8), child: LanguageSwitch())],
      ),
      body: FutureBuilder<List<Term>>(
        future: _terms,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(message: s.loadFailed, onRetry: () => setState(() => _terms = context.services.terms()));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final q = _filter.trim();
          final list = [
            for (final t in snap.data!)
              if (q.isEmpty || termMatches(t, q)) t,
          ]..sort((a, b) => a.name(lang).toLowerCase().compareTo(b.name(lang).toLowerCase()));
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: s.search,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => _filter = v),
                    ),
                  ),
                  Expanded(
                    child: list.isEmpty
                        ? Center(child: Text(snap.data!.isEmpty ? s.noTerms : s.noResults))
                        : ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final t = list[i];
                              final other = t.nameIn(lang.other);
                              return ListTile(
                                title: Text(t.name(lang)),
                                subtitle: Text(
                                  [if (other != null && other != t.name(lang)) other, ?t.meaningIn(lang)].join(' · '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => showTermSheet(context, term: t),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

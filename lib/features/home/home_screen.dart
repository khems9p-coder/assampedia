import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../learn/chapter_list_screen.dart';
import '../reader/reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.openLearn});
  final VoidCallback openLearn;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Category>>? _cats;
  List<String>? _last;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repo = context.services.content;
    _cats ??= repo?.categories();
    _loadLast();
  }

  Future<void> _loadLast() async {
    final last = await context.services.lastChapter();
    if (mounted) setState(() => _last = last);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => _cats = context.services.content?.categories());
            await _loadLast();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(children: [
                Image.asset('assets/brand/logo.png', width: 40, height: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('ASSAMPEDIA',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary, letterSpacing: 1.2)),
                ),
                const LanguageSwitch(),
              ]),
              const SizedBox(height: 16),
              _Banner(text: s.tagline),
              const SizedBox(height: 16),
              if (_last != null) ...[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.play_circle_outline, color: scheme.primary),
                    title: Text(s.continueLearning, style: theme.textTheme.labelLarge),
                    subtitle: Text(lang.code == 'as' ? _last![1] : _last![2], maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ReaderScreen(contentId: _last![0])))
                        .then((_) => _loadLast()),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Card(
                color: scheme.primaryContainer,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Icon(Icons.auto_stories, color: scheme.onPrimaryContainer, size: 32),
                  title: Text(s.encyclopedia,
                      style: theme.textTheme.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
                  subtitle: Text(s.encyclopediaHint, style: TextStyle(color: scheme.onPrimaryContainer)),
                  trailing: Icon(Icons.chevron_right, color: scheme.onPrimaryContainer),
                  onTap: widget.openLearn,
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: Text(s.categories, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
                TextButton(onPressed: widget.openLearn, child: Text(s.seeAll)),
              ]),
              if (_cats == null)
                Padding(padding: const EdgeInsets.all(16), child: Text(s.notConnected))
              else
                FutureBuilder<List<Category>>(
                  future: _cats,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return LoadError(message: s.loadFailed, onRetry: () => setState(() => _cats = context.services.content?.categories()));
                    }
                    if (!snap.hasData) return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
                    final cats = snap.data!.take(6).toList();
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 3 : 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [for (final c in cats) _CategoryTile(category: c)],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF1E6B3C), Color(0xFF1B5E8C)]),
      ),
      child: Row(children: [
        Expanded(
          child: Text(text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, height: 1.4)),
        ),
        const SizedBox(width: 12),
        Icon(Icons.water, color: scheme.tertiary, size: 36),
      ]),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChapterListScreen(category: category))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Icon(categoryIcon(category.icon), color: scheme.primary, size: 28),
            Text(category.name(context.lang),
                maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
          ]),
        ),
      ),
    );
  }
}

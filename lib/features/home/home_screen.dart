import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import '../dictionary/dictionary_screen.dart';
import '../learn/chapter_list_screen.dart';
import '../practice/daily_question_card.dart';
import '../practice/practice_screen.dart';
import '../reader/reader_screen.dart';
import '../saved/saved_screen.dart';
import '../search/search_screen.dart';

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
              Row(
                children: [
                  Image.asset('assets/brand/logo.png', width: 40, height: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ASSAMPEDIA',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary, letterSpacing: 1.2),
                    ),
                  ),
                  IconButton(
                    tooltip: s.search,
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
                  ),
                  const LanguageSwitch(),
                ],
              ),
              const SizedBox(height: 16),
              _Banner(text: s.tagline),
              const SizedBox(height: 16),
              const DailyQuestionCard(),
              if (_last != null) ...[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.play_circle_outline, color: scheme.primary),
                    title: Text(s.continueLearning, style: theme.textTheme.labelLarge),
                    subtitle: Text(lang.code == 'as' ? _last![1] : _last![2], maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () =>
                        Navigator.of(context)
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
                  title: Text(
                    s.encyclopedia,
                    style: theme.textTheme.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(s.encyclopediaHint, style: TextStyle(color: scheme.onPrimaryContainer)),
                  trailing: Icon(Icons.chevron_right, color: scheme.onPrimaryContainer),
                  onTap: widget.openLearn,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Icon(Icons.quiz_outlined, color: scheme.primary, size: 30),
                  title: Text(s.practiceZone, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text(s.practiceHint),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PracticeScreen())),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _QuickTile(
                      icon: Icons.translate,
                      title: s.dictionary,
                      subtitle: s.dictionaryHint,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DictionaryScreen())),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickTile(
                      icon: Icons.bookmarks_outlined,
                      title: s.saved,
                      subtitle: s.savedHint,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(s.categories, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  TextButton(onPressed: widget.openLearn, child: Text(s.seeAll)),
                ],
              ),
              if (_cats == null)
                Padding(padding: const EdgeInsets.all(16), child: Text(s.notConnected))
              else
                FutureBuilder<List<Category>>(
                  future: _cats,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return LoadError(
                        message: s.loadFailed,
                        onRetry: () => setState(() => _cats = context.services.content?.categories()),
                      );
                    }
                    if (!snap.hasData) {
                      return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
                    }
                    final cats = snap.data!.take(6).toList();
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: MediaQuery.sizeOf(context).width > 900 ? 4 : (MediaQuery.sizeOf(context).width > 600 ? 3 : 2),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: MediaQuery.sizeOf(context).width > 600 ? 2.2 : 1.5,
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
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.water, color: scheme.tertiary, size: 36),
        ],
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(categoryIcon(category.icon), color: scheme.primary, size: 28),
              Text(
                category.name(context.lang),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

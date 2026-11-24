import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import 'admin_chapter_list_screen.dart';
import 'admin_import_screen.dart';
import 'admin_practice_screen.dart';
import 'admin_terms_screen.dart';
import 'admin_vacancies_screen.dart';

/// Admin start page: pick a category to manage its chapters.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  late Future<List<Category>> _cats;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cats = context.services.admin!.categories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Categories')),
      body: FutureBuilder<List<Category>>(
        future: _cats,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(message: '${snap.error}', onRetry: () => setState(() => _cats = context.services.admin!.categories()));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(children: [
            Card(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: ListTile(
                leading: const Icon(Icons.download_for_offline_outlined),
                title: const Text('Import chapters'),
                subtitle: const Text('Add ready-made GK chapters as drafts, with one tap'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminImportScreen())),
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: ListTile(
                leading: const Icon(Icons.translate),
                title: const Text('Dictionary terms'),
                subtitle: const Text('Words readers can tap inside chapters'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminTermsScreen())),
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: ListTile(
                leading: const Icon(Icons.work_outline),
                title: const Text('Job vacancies'),
                subtitle: const Text('Recruitment notices from official notifications'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminVacanciesScreen())),
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: ListTile(
                leading: const Icon(Icons.quiz_outlined),
                title: const Text('Practice Zone'),
                subtitle: const Text('Quizzes, mock tests and the daily question'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminPracticeScreen())),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Choose a group to add or edit its pages.'),
            ),
            for (final (section, label) in const [
              ('gk', 'Assam GK encyclopedia'),
              ('exam', 'Exam syllabus library'),
              ('job', 'Government careers'),
              ('ca', 'Current affairs'),
            ]) ...[
              if (snap.data!.any((c) => c.section == section))
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
                ),
              for (final c in snap.data!.where((c) => c.section == section))
                ListTile(
                  leading: Icon(categoryIcon(c.icon)),
                  title: Text(c.nameEn),
                  subtitle: Text(c.nameAs),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminChapterListScreen(category: c))),
                ),
            ],
          ]);
        },
      ),
    );
  }
}

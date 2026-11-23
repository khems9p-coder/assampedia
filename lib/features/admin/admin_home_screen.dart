import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/models.dart';
import 'admin_chapter_list_screen.dart';

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
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Choose a category to add or edit its chapters.'),
            ),
            for (final c in snap.data!)
              ListTile(
                leading: Icon(categoryIcon(c.icon)),
                title: Text(c.nameEn),
                subtitle: Text(c.nameAs),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminChapterListScreen(category: c))),
              ),
          ]);
        },
      ),
    );
  }
}

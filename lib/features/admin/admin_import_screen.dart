import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';

/// Where the ready-made chapter files live (the app's own GitHub repository).
const contentBaseUrl = 'https://raw.githubusercontent.com/khems9p-coder/assampedia/main/supabase/content/json/';

/// Admin screen that adds ready-made chapters with one tap, instead of
/// pasting SQL into Supabase. Everything comes in as drafts.
class AdminImportScreen extends StatefulWidget {
  const AdminImportScreen({super.key, this.baseUrl = contentBaseUrl, this.httpClient});
  final String baseUrl;
  final http.Client? httpClient;

  @override
  State<AdminImportScreen> createState() => _AdminImportScreenState();
}

enum _Status { waiting, working, done, failed }

class _AdminImportScreenState extends State<AdminImportScreen> {
  late final http.Client _http = widget.httpClient ?? http.Client();
  late Future<List<Map<String, dynamic>>> _groups = _loadIndex();
  final _status = <String, _Status>{};
  final _message = <String, String>{};
  bool _busy = false;

  Future<Map<String, dynamic>> _getJson(String file) async {
    // A fresh query string avoids an old cached copy after the files change.
    final url = Uri.parse('${widget.baseUrl}$file?t=${DateTime.now().millisecondsSinceEpoch}');
    final res = await _http.get(url);
    if (res.statusCode != 200) throw Exception('Could not download $file (error ${res.statusCode}).');
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> _loadIndex() async {
    final index = await _getJson('index.json');
    return [for (final g in index['groups'] as List) g as Map<String, dynamic>];
  }

  Future<void> _import(Map<String, dynamic> g) async {
    final file = g['file'] as String;
    final admin = context.services.admin!;
    setState(() => _status[file] = _Status.working);
    try {
      final data = await _getJson(file);
      final r = await admin.importGroup(data);
      final pics = r.pictures == 0 ? '' : '${r.pictures} new picture${r.pictures == 1 ? '' : 's'}';
      _message[file] = r.added == 0
          ? (pics.isEmpty ? 'Already added. Nothing new.' : 'Already added. Added $pics.')
          : 'Added ${r.added} chapter${r.added == 1 ? '' : 's'} as drafts'
                '${r.skipped > 0 ? ' (${r.skipped} were already there)' : ''}'
                '${pics.isEmpty ? '' : ', and $pics'}.';
      _status[file] = _Status.done;
    } catch (e) {
      _message[file] = '$e';
      _status[file] = _Status.failed;
    }
    if (mounted) setState(() {});
  }

  Future<void> _importAll(List<Map<String, dynamic>> groups) async {
    setState(() => _busy = true);
    // In order: later groups reuse dictionary words from earlier ones.
    for (final g in groups) {
      if (!mounted) return;
      await _import(g);
    }
    if (!mounted) return;
    context.services.refreshTerms();
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Import chapters')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _groups,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(message: '${snap.error}', onRetry: () => setState(() => _groups = _loadIndex()));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final groups = snap.data!;
          final total = groups.fold<int>(0, (n, g) => n + (g['chapters'] as int));
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  '$total ready-made chapters and exam syllabus pages in ${groups.length} groups, in English and Assamese. '
                  'They are added as drafts, so readers will not see them until you check and publish each one. '
                  'Chapters you already have keep your edits: only new pictures are added to them.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FilledButton.icon(
                  onPressed: _busy ? null : () => _importAll(groups),
                  icon: _busy
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.download),
                  label: Text(_busy ? 'Importing…' : 'Import all groups'),
                ),
              ),
              const Divider(),
              for (final g in groups) _groupTile(g),
            ],
          );
        },
      ),
    );
  }

  Widget _groupTile(Map<String, dynamic> g) {
    final file = g['file'] as String;
    final status = _status[file] ?? _Status.waiting;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(g['name'] as String),
      subtitle: Text(
        _message[file] ?? '${g['chapters']} chapters · ${g['terms']} dictionary words',
        style: status == _Status.failed ? TextStyle(color: scheme.error) : null,
      ),
      trailing: switch (status) {
        _Status.working => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        _Status.done => Icon(Icons.check_circle, color: scheme.primary),
        _ => TextButton(
          onPressed: _busy ? null : () => _import(g),
          child: Text(status == _Status.failed ? 'Retry' : 'Import'),
        ),
      },
    );
  }
}

/// Where the ready-made mock tests live.
const mockBaseUrl = 'https://raw.githubusercontent.com/khems9p-coder/assampedia/main/supabase/content/mock/';

/// Admin screen that adds ready-made mock tests with one tap. They come in
/// hidden, so readers see them only after the admin checks and publishes them.
class AdminImportMockScreen extends StatefulWidget {
  const AdminImportMockScreen({super.key, this.baseUrl = mockBaseUrl, this.httpClient});
  final String baseUrl;
  final http.Client? httpClient;

  @override
  State<AdminImportMockScreen> createState() => _AdminImportMockScreenState();
}

class _AdminImportMockScreenState extends State<AdminImportMockScreen> {
  late final http.Client _http = widget.httpClient ?? http.Client();
  late Future<List<Map<String, dynamic>>> _tests = _loadIndex();
  final _status = <String, _Status>{};
  final _message = <String, String>{};

  Future<Map<String, dynamic>> _getJson(String file) async {
    final url = Uri.parse('${widget.baseUrl}$file?t=${DateTime.now().millisecondsSinceEpoch}');
    final res = await _http.get(url);
    if (res.statusCode != 200) throw Exception('Could not download $file (error ${res.statusCode}).');
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> _loadIndex() async {
    final index = await _getJson('index.json');
    return [for (final t in index['tests'] as List) t as Map<String, dynamic>];
  }

  Future<void> _import(Map<String, dynamic> t) async {
    final file = t['file'] as String;
    setState(() => _status[file] = _Status.working);
    try {
      final added = await context.services.admin!.importMockTest(await _getJson(file));
      _message[file] = added
          ? 'Added as a hidden draft. Check it in Admin > Practice Zone, then turn on "Show to readers".'
          : 'Already added. Nothing new.';
      _status[file] = _Status.done;
    } catch (e) {
      _message[file] = '$e';
      _status[file] = _Status.failed;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin · Import mock tests')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tests,
        builder: (context, snap) {
          if (snap.hasError) {
            return LoadError(message: '${snap.error}', onRetry: () => setState(() => _tests = _loadIndex()));
          }
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Ready-made mock tests in English and Assamese, with marks, negative marking and a topic for every question. '
                  'They are added hidden, so check every question before you show a test to readers.',
                ),
              ),
              const Divider(),
              for (final t in snap.data!)
                Builder(
                  builder: (context) {
                    final file = t['file'] as String;
                    final status = _status[file] ?? _Status.waiting;
                    return ListTile(
                      leading: const Icon(Icons.timer_outlined),
                      title: Text(t['name'] as String),
                      subtitle: Text(
                        _message[file] ?? '${t['questions']} questions',
                        style: status == _Status.failed ? TextStyle(color: scheme.error) : null,
                      ),
                      trailing: switch (status) {
                        _Status.working => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                        _Status.done => Icon(Icons.check_circle, color: scheme.primary),
                        _ => TextButton(onPressed: () => _import(t), child: Text(status == _Status.failed ? 'Retry' : 'Import')),
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

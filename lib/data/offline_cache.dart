import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Saves downloaded content as small files on the phone so it can be read
/// without internet. (On the web version nothing is saved.)
class OfflineCache {
  Directory? _dir;

  Future<Directory?> _folder() async {
    if (kIsWeb) return null;
    if (_dir != null) return _dir;
    final base = await getApplicationSupportDirectory();
    _dir = Directory('${base.path}/content_cache');
    await _dir!.create(recursive: true);
    return _dir;
  }

  String _safe(String key) => key.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

  Future<void> write(String key, Object json) async {
    final dir = await _folder();
    if (dir == null) return;
    await File('${dir.path}/${_safe(key)}.json').writeAsString(jsonEncode(json));
  }

  Future<dynamic> read(String key) async {
    final dir = await _folder();
    if (dir == null) return null;
    final f = File('${dir.path}/${_safe(key)}.json');
    if (!await f.exists()) return null;
    return jsonDecode(await f.readAsString());
  }
}

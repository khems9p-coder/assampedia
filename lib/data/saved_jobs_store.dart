import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jobs_models.dart';

/// Vacancies the reader saved, kept on the phone with a copy of their
/// details so they can be read offline.
class SavedJobsStore extends ChangeNotifier {
  static const _key = 'saved_jobs';
  final List<Vacancy> _items = [];

  List<Vacancy> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(_key);
    _items.clear();
    if (raw != null) {
      try {
        _items.addAll([for (final j in jsonDecode(raw) as List) Vacancy.fromJson(j as Map<String, dynamic>)]);
      } catch (_) {
        // Ignore a damaged list rather than crash.
      }
    }
    notifyListeners();
  }

  Future<void> _persist() async =>
      (await SharedPreferences.getInstance()).setString(_key, jsonEncode([for (final v in _items) v.toJson()]));

  bool contains(String? id) => id != null && _items.any((v) => v.id == id);

  Future<void> toggle(Vacancy v) async {
    if (contains(v.id)) {
      _items.removeWhere((x) => x.id == v.id);
    } else {
      _items.insert(0, v);
    }
    notifyListeners();
    await _persist();
  }

  /// Replaces saved copies with fresher details after a download.
  void refreshFrom(List<Vacancy> latest) {
    var changed = false;
    for (var i = 0; i < _items.length; i++) {
      final fresh = latest.where((v) => v.id == _items[i].id);
      if (fresh.isNotEmpty) {
        _items[i] = fresh.first;
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
      _persist();
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmark {
  Bookmark({required this.contentId, this.blockKey, required this.titleAs, required this.titleEn, required this.savedAt});

  final String contentId;

  /// The paragraph the reader was on when saving.
  final String? blockKey;
  final String titleAs;
  final String titleEn;
  final DateTime savedAt;

  Map<String, dynamic> toJson() => {
    'content_id': contentId,
    'block_key': blockKey,
    'title_as': titleAs,
    'title_en': titleEn,
    'saved_at': savedAt.toIso8601String(),
  };

  factory Bookmark.fromJson(Map<String, dynamic> j) => Bookmark(
    contentId: j['content_id'] as String,
    blockKey: j['block_key'] as String?,
    titleAs: j['title_as'] as String? ?? '',
    titleEn: j['title_en'] as String? ?? '',
    savedAt: DateTime.tryParse(j['saved_at'] as String? ?? '') ?? DateTime.now(),
  );
}

/// Chapters the reader saved. Kept on the phone, so it works without
/// internet and without signing in.
class BookmarkStore extends ChangeNotifier {
  static const _key = 'bookmarks';
  final List<Bookmark> _items = [];

  /// Newest first.
  List<Bookmark> get items => List.unmodifiable(_items);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    _items.clear();
    if (raw != null) {
      try {
        _items.addAll([for (final j in jsonDecode(raw) as List) Bookmark.fromJson(j as Map<String, dynamic>)]);
      } catch (_) {
        // Ignore a damaged list rather than crash.
      }
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode([for (final b in _items) b.toJson()]));
  }

  Bookmark? find(String contentId) {
    for (final b in _items) {
      if (b.contentId == contentId) return b;
    }
    return null;
  }

  bool contains(String contentId) => find(contentId) != null;

  /// Saves the chapter (or moves it to the top with the new place).
  Future<void> save(Bookmark b) async {
    _items.removeWhere((x) => x.contentId == b.contentId);
    _items.insert(0, b);
    notifyListeners();
    await _persist();
  }

  Future<void> remove(String contentId) async {
    _items.removeWhere((x) => x.contentId == contentId);
    notifyListeners();
    await _persist();
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// How many pages of each group, and quizzes of each type, are free.
/// Must match the database rules in 0007_premium.sql.
const freePerGroup = 3;

/// Premium subscription: whether this reader has it, and buying it through
/// Google Play. The database decides what a reader may read; this class only
/// keeps the app's locks and buttons in step with it.
class PremiumService extends ChangeNotifier {
  PremiumService([this.client]);

  /// The subscription's ID in Play Console (Monetize > Subscriptions).
  static const productId = 'assampedia_premium';
  static const packageName = 'com.assampedia.app';

  final SupabaseClient? client;
  InAppPurchase? _store;
  StreamSubscription<List<PurchaseDetails>>? _purchases;
  StreamSubscription<AuthState>? _auth;

  bool _premium = false;
  DateTime? _expiresAt;
  bool _storeAvailable = false;
  ProductDetails? _product;
  bool _busy = false;
  String? _error;

  bool get isPremium => _premium;
  DateTime? get expiresAt => _expiresAt;

  /// True only in the Android app installed from Google Play (or a test track).
  bool get storeAvailable => _storeAvailable;

  /// Price as Google Play shows it, for example "₹49.00".
  String? get price => _product?.price;
  bool get busy => _busy;
  String? get error => _error;

  String get manageUrl => 'https://play.google.com/store/account/subscriptions?sku=$productId&package=$packageName';

  /// Call once at app start (Android only).
  Future<void> start() async {
    if (client == null) return;
    _auth = client!.auth.onAuthStateChange.listen((_) => refresh());
    await refresh();
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      _store = InAppPurchase.instance;
      _purchases = _store!.purchaseStream.listen(_onPurchases, onError: (Object e) => _fail('$e'));
      _storeAvailable = await _store!.isAvailable();
      if (_storeAvailable) {
        final r = await _store!.queryProductDetails({productId});
        if (r.productDetails.isNotEmpty) _product = r.productDetails.first;
      }
    } catch (e) {
      _storeAvailable = false;
    }
    notifyListeners();
  }

  /// Asks the database whether the signed-in reader has Premium now.
  Future<void> refresh() async {
    final c = client;
    final user = c?.auth.currentUser;
    var premium = false;
    DateTime? until;
    if (c != null && user != null) {
      try {
        premium = await c.rpc('has_premium') == true;
        final row = await c.from('premium_access').select('expires_at').eq('user_id', user.id).maybeSingle();
        until = DateTime.tryParse(row?['expires_at'] as String? ?? '')?.toLocal();
      } catch (_) {
        // Keep the last known state when offline.
        premium = _premium;
        until = _expiresAt;
      }
    }
    _premium = premium;
    _expiresAt = until;
    notifyListeners();
  }

  /// Whether a page can be opened. Pages in the first [freePerGroup] of their
  /// group always can; the database also checks.
  bool canOpen({required int indexInGroup}) => _premium || indexInGroup < freePerGroup;

  /// Asks the database whether one page is free (used when a page is opened
  /// from search, bookmarks or links and its place in the group is unknown).
  Future<bool> contentIsFree(String contentId) async {
    if (client == null || _premium) return true;
    try {
      return await client!.rpc('content_is_free', params: {'cid': contentId}) == true;
    } catch (_) {
      return true;
    }
  }

  Future<void> buy() async {
    final user = client?.auth.currentUser;
    if (_store == null || _product == null || user == null) return;
    _error = null;
    _busy = true;
    notifyListeners();
    try {
      // applicationUserName ties the purchase to this account (checked on the server).
      await _store!.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: _product!, applicationUserName: user.id),
      );
    } catch (e) {
      _fail('$e');
    }
  }

  /// Finds an earlier purchase made with this Google account.
  Future<void> restore() async {
    final user = client?.auth.currentUser;
    if (_store == null || user == null) return;
    _error = null;
    _busy = true;
    notifyListeners();
    try {
      await _store!.restorePurchases(applicationUserName: user.id);
    } catch (e) {
      _fail('$e');
    }
    // If nothing is found, no purchase event arrives.
    Future.delayed(const Duration(seconds: 8), () {
      if (_busy) {
        _busy = false;
        notifyListeners();
      }
    });
  }

  Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list) {
      if (p.productID != productId) continue;
      switch (p.status) {
        case PurchaseStatus.pending:
          _busy = true;
          notifyListeners();
        case PurchaseStatus.canceled:
          _busy = false;
          notifyListeners();
        case PurchaseStatus.error:
          _fail(p.error?.message ?? 'Purchase failed');
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final ok = await _verify(p.verificationData.serverVerificationData);
          // Only confirm the purchase to Google once our server has recorded it;
          // unconfirmed purchases are refunded by Google after 3 days.
          if (ok && p.pendingCompletePurchase) await _store?.completePurchase(p);
          _busy = false;
          notifyListeners();
      }
    }
  }

  Future<bool> _verify(String token) async {
    try {
      final res = await client!.functions.invoke('verify-purchase', body: {'purchaseToken': token});
      final data = res.data;
      await refresh();
      if (data is Map && data['premium'] == true) return true;
      _error = data is Map ? (data['error'] as String? ?? 'Subscription not active') : 'Subscription not active';
      return data is Map && data['error'] == null;
    } on FunctionException catch (e) {
      final d = e.details;
      _error = d is Map ? (d['error'] as String? ?? '$d') : '${e.status}';
      return false;
    } catch (e) {
      _error = '$e';
      return false;
    }
  }

  void _fail(String message) {
    _error = message;
    _busy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _purchases?.cancel();
    _auth?.cancel();
    super.dispose();
  }
}

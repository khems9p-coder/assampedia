import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sign in, sign out, and whether the signed-in person is an admin.
class AuthService extends ChangeNotifier {
  AuthService(this.client) {
    if (client != null) {
      _sub = client!.auth.onAuthStateChange.listen((_) => _refresh());
      _refresh();
    }
  }

  final SupabaseClient? client;
  StreamSubscription<AuthState>? _sub;
  bool _isAdmin = false;

  bool get available => client != null;
  User? get user => client?.auth.currentUser;
  bool get isSignedIn => user != null;
  bool get isAdmin => _isAdmin;

  Future<void> _refresh() async {
    final u = user;
    var admin = false;
    if (u != null) {
      try {
        final row = await client!.from('profiles').select('role').eq('id', u.id).maybeSingle();
        admin = row?['role'] == 'admin';
      } catch (_) {
        admin = false;
      }
    }
    _isAdmin = admin;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await client!.auth.signInWithPassword(email: email.trim(), password: password);
  }

  /// Returns true when the account is ready, false when email confirmation is needed.
  Future<bool> signUp(String email, String password) async {
    final res = await client!.auth.signUp(email: email.trim(), password: password);
    return res.session != null;
  }

  Future<void> signOut() => client!.auth.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

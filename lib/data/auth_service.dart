import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'student_profile.dart';

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

  /// The signed-in student's profile, or null if it couldn't be loaded.
  StudentProfile? get profile => _profile;
  StudentProfile? _profile;

  /// True when a signed-in student still has to fill in their profile.
  /// (If the profile can't be loaded, for example offline, nobody is held up.)
  bool get needsProfile => isSignedIn && _profile != null && !_profile!.isComplete;

  /// The security question the student chose, or null.
  SecurityQuestion? get securityQuestion => _securityQuestion;
  SecurityQuestion? _securityQuestion;
  bool _securityChecked = false;

  /// True when a signed-in student has not chosen a security question yet.
  /// (If it can't be checked, for example offline, nobody is held up.)
  bool get needsSecurityQuestion => isSignedIn && _securityChecked && _securityQuestion == null;

  /// True just after signing in, while the account details are still loading.
  bool get checking => isSignedIn && _checkedFor != user!.id;
  String? _checkedFor;

  /// Why the admin check failed last time, if it did (shown on the Me tab).
  String? get adminCheckError => _adminCheckError;
  String? _adminCheckError;

  /// Checks again whether the signed-in account is an admin.
  Future<void> refresh() => _refresh();

  Future<void> _refresh() async {
    // Tell the app straight away that someone signed in or out; the admin check follows.
    notifyListeners();
    final u = user;
    var admin = false;
    String? error;
    if (u != null) {
      try {
        // Ask the database directly; this works even if the profile row is hidden.
        admin = await client!.rpc('is_admin') == true;
      } catch (e) {
        try {
          final row = await client!.from('profiles').select('role').eq('id', u.id).maybeSingle();
          admin = row?['role'] == 'admin';
        } catch (e2) {
          error = '$e2';
        }
      }
    }
    StudentProfile? profile;
    if (u != null) {
      try {
        final row = await client!.from('profiles').select('full_name, education, exams, district').eq('id', u.id).maybeSingle();
        profile = row == null ? null : StudentProfile.fromRow(row);
      } catch (_) {
        // Columns missing (0008 not run yet) or offline: don't block the student.
      }
    }
    SecurityQuestion? question;
    var securityChecked = false;
    if (u != null) {
      try {
        question = SecurityQuestion.fromCode(await client!.rpc('my_security_question') as String?);
        securityChecked = true;
      } catch (_) {
        // 0009 not run yet, or offline.
      }
    }
    if (user?.id != u?.id) return; // Someone else signed in meanwhile.
    _securityQuestion = question;
    _securityChecked = securityChecked;
    _isAdmin = admin;
    _adminCheckError = error;
    _profile = profile;
    _checkedFor = u?.id;
    notifyListeners();
  }

  /// Saves the signed-in student's profile.
  Future<void> saveProfile(StudentProfile p) async {
    await client!.from('profiles').update(p.toRow()).eq('id', user!.id);
    _profile = p;
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

  /// Saves the signed-in student's security question and answer.
  Future<void> setSecurityQuestion(SecurityQuestion q, String answer) async {
    await client!.rpc('set_security_question', params: {'q': q.code, 'answer': answer});
    _securityQuestion = q;
    _securityChecked = true;
    notifyListeners();
  }

  /// The security question for an email address, or null if there is none.
  Future<SecurityQuestion?> securityQuestionFor(String email) async =>
      SecurityQuestion.fromCode(await client!.rpc('security_question_for', params: {'email': email.trim()}) as String?);

  /// Sets a new password if the answer is right.
  /// Returns 'ok', 'wrong', 'locked', 'weak' or 'none'.
  Future<String> resetPasswordWithAnswer(String email, String answer, String newPassword) async =>
      '${await client!.rpc('reset_password_with_answer', params: {'email': email.trim(), 'answer': answer, 'new_password': newPassword})}';

  /// Confirms a new account with the code from the email.
  Future<void> verifySignUpCode(String email, String code) async {
    await client!.auth.verifyOTP(type: OtpType.email, email: email.trim(), token: code.trim());
  }

  /// Sends the sign-up code again.
  Future<void> resendSignUpCode(String email) async {
    await client!.auth.resend(type: OtpType.signup, email: email.trim());
  }

  /// Emails a code for setting a new password.
  Future<void> sendPasswordResetCode(String email) async {
    await client!.auth.resetPasswordForEmail(email.trim());
  }

  /// Checks the reset code (this signs the student in) and sets the new password.
  Future<void> resetPassword(String email, String code, String newPassword) async {
    await client!.auth.verifyOTP(type: OtpType.recovery, email: email.trim(), token: code.trim());
    await client!.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> signOut() => client!.auth.signOut();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

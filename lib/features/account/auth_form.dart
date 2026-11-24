import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/strings.dart';
import '../../data/student_profile.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// A problem with an email address, or null.
String? checkEmail(S s, String email) {
  if (email.trim().isEmpty) return s.enterEmailPassword;
  if (!_emailPattern.hasMatch(email.trim())) return s.badEmail;
  return null;
}

/// A new password must have at least 8 characters, with letters, numbers and
/// a special character. Returns the problem, or null.
String? checkNewPassword(S s, String password, String again) {
  final strong =
      password.length >= 8 &&
      RegExp(r'[A-Za-z]').hasMatch(password) &&
      RegExp(r'[0-9]').hasMatch(password) &&
      RegExp(r'[^A-Za-z0-9]').hasMatch(password);
  if (!strong) return s.strongPasswordRule;
  if (password != again) return s.passwordsDiffer;
  return null;
}

/// A security question must be chosen and answered (2+ letters).
String? checkSecurityAnswer(S s, SecurityQuestion? q, String answer) => q == null || answer.trim().length < 2 ? s.answerNeeded : null;

/// Shared behaviour for the sign-in, sign-up, code and password screens:
/// a busy flag, one message line, and plain wording for server errors.
mixin AuthFormMixin<T extends StatefulWidget> on State<T> {
  bool busy = false;
  String? message;
  bool messageIsError = true;

  void showMessage(String text, {bool error = true}) => setState(() {
    message = text;
    messageIsError = error;
  });

  String _authMessage(AuthException e) {
    final s = context.s;
    final network = e.message.contains('SocketException') || e.message.contains('ClientException');
    if (network) return s.loadFailed;
    return switch (e.code) {
      'invalid_credentials' => s.wrongLogin,
      'user_already_exists' || 'email_exists' => s.accountExists,
      'email_not_confirmed' => s.emailNotConfirmed,
      'weak_password' => s.strongPasswordRule,
      'email_address_invalid' || 'validation_failed' => s.badEmail,
      'otp_expired' || 'otp_disabled' => s.badCode,
      'over_email_send_rate_limit' || 'over_request_rate_limit' => s.tooManyTries,
      _ => e.message,
    };
  }

  /// Runs [action] unless [problem] is set, and shows any error.
  Future<void> run(Future<void> Function() action, {String? problem}) async {
    if (problem != null) {
      showMessage(problem);
      return;
    }
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await action();
    } on AuthRetryableFetchException {
      if (mounted) showMessage(context.s.loadFailed);
    } on AuthException catch (e) {
      if (mounted) showMessage(_authMessage(e));
    } catch (e) {
      if (mounted) showMessage(context.s.loadFailed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  /// The message line under the fields.
  Widget messageLine() {
    if (message == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(message!, style: TextStyle(color: messageIsError ? scheme.error : scheme.primary)),
    );
  }
}

/// A text field in the style used on every account screen.
class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.label,
    this.password = false,
    this.email = false,
    this.hints,
    this.helper,
    this.keyboard,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final bool password;
  final bool email;
  final Iterable<String>? hints;
  final String? helper;
  final TextInputType? keyboard;
  final int? maxLength;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      obscureText: password,
      maxLength: maxLength,
      keyboardType: keyboard ?? (email ? TextInputType.emailAddress : null),
      autofillHints: hints,
      decoration: InputDecoration(labelText: label, helperText: helper, helperMaxLines: 3, border: const OutlineInputBorder()),
    ),
  );
}

/// A screen with a title and a narrow centred column, for the account steps.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children)],
          ),
        ),
      ),
    ),
  );
}

/// Goes back to the app's first screen, which by then shows the right step
/// (profile setup or the content).
void backToStart(BuildContext context) => Navigator.of(context).popUntil((r) => r.isFirst);

/// Pick a security question and write the answer.
class SecurityQuestionFields extends StatelessWidget {
  const SecurityQuestionFields({super.key, required this.question, required this.answer, required this.onQuestion, this.answerHint});
  final SecurityQuestion? question;
  final TextEditingController answer;
  final ValueChanged<SecurityQuestion?> onQuestion;
  final String? answerHint;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(s.securityQuestion, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 4),
        Text(s.securityQuestionHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        DropdownButtonFormField<SecurityQuestion>(
          initialValue: question,
          isExpanded: true,
          decoration: InputDecoration(labelText: s.chooseQuestion, border: const OutlineInputBorder()),
          items: [
            for (final q in SecurityQuestion.values)
              DropdownMenuItem(
                value: q,
                child: Text(q.text(lang), overflow: TextOverflow.ellipsis),
              ),
          ],
          onChanged: onQuestion,
        ),
        const SizedBox(height: 12),
        AuthField(controller: answer, label: s.yourAnswer, helper: answerHint, maxLength: 60),
      ],
    );
  }
}

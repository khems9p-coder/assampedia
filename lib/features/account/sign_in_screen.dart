import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/student_profile.dart';
import 'auth_form.dart';

/// Sign in from inside the app (for example from the Premium page).
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => AuthPage(
    title: context.s.signIn,
    children: [SignInForm(onDone: () => Navigator.of(context).pop())],
  );
}

/// Email and password with Sign in, plus links to "Forgot password?" and
/// "Create account". [onDone] runs once the account is signed in.
class SignInForm extends StatefulWidget {
  const SignInForm({super.key, this.onDone});
  final VoidCallback? onDone;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> with AuthFormMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _open(Widget screen) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final auth = context.services.auth;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthField(controller: _email, label: s.email, email: true, hints: const [AutofillHints.email]),
          AuthField(controller: _password, label: s.password, password: true, hints: const [AutofillHints.password]),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _open(ForgotPasswordScreen(email: _email.text)),
              child: Text(s.forgotPassword),
            ),
          ),
          messageLine(),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: busy
                ? null
                : () => run(problem: _password.text.isEmpty ? s.enterEmailPassword : checkEmail(s, _email.text), () async {
                    await auth.signIn(_email.text, _password.text);
                    widget.onDone?.call();
                  }),
            child: Text(s.signIn),
          ),
          const SizedBox(height: 20),
          Text(s.noAccountYet, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: busy ? null : () => _open(const CreateAccountScreen()),
            child: Text(s.createAccount),
          ),
        ],
      ),
    );
  }
}

/// New account: email, password and the password again. Then a code is
/// emailed to confirm the address.
class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> with AuthFormMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _again = TextEditingController();
  final _answer = TextEditingController();
  SecurityQuestion? _question;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _again.dispose();
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final auth = context.services.auth;
    return AuthPage(
      title: s.createAccount,
      children: [
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthField(controller: _email, label: s.email, email: true, hints: const [AutofillHints.email]),
              AuthField(
                controller: _password,
                label: s.password,
                password: true,
                hints: const [AutofillHints.newPassword],
                helper: s.strongPasswordRule,
              ),
              AuthField(controller: _again, label: s.confirmPassword, password: true, hints: const [AutofillHints.newPassword]),
            ],
          ),
        ),
        SecurityQuestionFields(question: _question, answer: _answer, onQuestion: (q) => setState(() => _question = q)),
        messageLine(),
        const SizedBox(height: 12),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: busy
              ? null
              : () => run(
                  problem:
                      checkEmail(s, _email.text) ??
                      checkNewPassword(s, _password.text, _again.text) ??
                      checkSecurityAnswer(s, _question, _answer.text),
                  () async {
                    final email = _email.text.trim();
                    final question = _question!;
                    final answer = _answer.text;
                    final ready = await auth.signUp(email, _password.text);
                    if (!mounted) return;
                    if (ready) {
                      // Email confirmation is switched off in Supabase: already signed in.
                      await auth.setSecurityQuestion(question, answer);
                      if (mounted) backToStart(this.context);
                    } else {
                      await Navigator.of(this.context).push(
                        MaterialPageRoute(
                          builder: (_) => VerifyCodeScreen(email: email, question: question, answer: answer),
                        ),
                      );
                    }
                  },
                ),
          child: Text(s.createAccount),
        ),
      ],
    );
  }
}

/// Enter the code that was emailed after creating an account. The security
/// question is saved once the account is confirmed.
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key, required this.email, this.question, this.answer});
  final String email;
  final SecurityQuestion? question;
  final String? answer;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> with AuthFormMixin, _ResendTimer {
  final _code = TextEditingController();

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final auth = context.services.auth;
    return AuthPage(
      title: s.enterCode,
      children: [
        Text(s.codeSentTo(widget.email)),
        const SizedBox(height: 16),
        _CodeField(controller: _code, label: s.code),
        messageLine(),
        const SizedBox(height: 12),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: busy
              ? null
              : () => run(problem: _checkCode(context, _code.text), () async {
                  await auth.verifySignUpCode(widget.email, _code.text);
                  if (widget.question != null) await auth.setSecurityQuestion(widget.question!, widget.answer ?? '');
                  if (mounted) backToStart(this.context);
                }),
          child: Text(s.confirm),
        ),
        const SizedBox(height: 8),
        resendButton(() => auth.resendSignUpCode(widget.email)),
      ],
    );
  }
}

enum _ResetStep { email, question, code }

/// Forgotten password: answer the security question (or use an email code),
/// then choose a new password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.email = ''});
  final String email;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with AuthFormMixin, _ResendTimer {
  late final _email = TextEditingController(text: widget.email.trim());
  final _code = TextEditingController();
  final _answer = TextEditingController();
  final _password = TextEditingController();
  final _again = TextEditingController();
  _ResetStep _step = _ResetStep.email;
  SecurityQuestion? _question;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _answer.dispose();
    _password.dispose();
    _again.dispose();
    super.dispose();
  }

  Future<void> _sendEmailCode() async {
    await context.services.auth.sendPasswordResetCode(_email.text);
    setState(() => _step = _ResetStep.code);
    startResendTimer();
  }

  void _done() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.s.passwordChanged)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final auth = context.services.auth;
    const full = Size.fromHeight(48);
    final newPassword = [
      AuthField(controller: _password, label: s.newPassword, password: true, helper: s.strongPasswordRule),
      AuthField(controller: _again, label: s.confirmPassword, password: true),
    ];
    return AuthPage(
      title: s.resetPasswordTitle,
      children: [
        switch (_step) {
          _ResetStep.email => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.resetPasswordHint),
              const SizedBox(height: 16),
              AuthField(controller: _email, label: s.email, email: true, hints: const [AutofillHints.email]),
              messageLine(),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: full),
                onPressed: busy
                    ? null
                    : () => run(problem: checkEmail(s, _email.text), () async {
                        final q = await auth.securityQuestionFor(_email.text);
                        if (q != null) {
                          setState(() {
                            _question = q;
                            _step = _ResetStep.question;
                          });
                        } else {
                          await _sendEmailCode();
                        }
                      }),
                child: Text(s.next),
              ),
            ],
          ),
          _ResetStep.question => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.answerYourQuestion),
              const SizedBox(height: 12),
              Text(_question!.text(lang), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              AuthField(controller: _answer, label: s.yourAnswer),
              ...newPassword,
              messageLine(),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: full),
                onPressed: busy
                    ? null
                    : () => run(
                        problem: _answer.text.trim().isEmpty ? s.answerNeeded : checkNewPassword(s, _password.text, _again.text),
                        () async {
                          final r = await auth.resetPasswordWithAnswer(_email.text, _answer.text, _password.text);
                          if (!mounted) return;
                          switch (r) {
                            case 'ok':
                              _done();
                            case 'wrong':
                              showMessage(s.wrongAnswer);
                            case 'locked':
                              showMessage(s.answerLocked);
                            case 'weak':
                              showMessage(s.strongPasswordRule);
                            default:
                              showMessage(s.loadFailed);
                          }
                        },
                      ),
                child: Text(s.save),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: busy ? null : () => run(_sendEmailCode), child: Text(s.useEmailCode)),
            ],
          ),
          _ResetStep.code => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.codeSentTo(_email.text.trim())),
              const SizedBox(height: 16),
              _CodeField(controller: _code, label: s.code),
              ...newPassword,
              messageLine(),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: full),
                onPressed: busy
                    ? null
                    : () => run(problem: _checkCode(context, _code.text) ?? checkNewPassword(s, _password.text, _again.text), () async {
                        await auth.resetPassword(_email.text, _code.text, _password.text);
                        if (!mounted) return;
                        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text(s.passwordChanged)));
                        backToStart(this.context);
                      }),
                child: Text(s.save),
              ),
              const SizedBox(height: 8),
              resendButton(() => auth.sendPasswordResetCode(_email.text)),
            ],
          ),
        },
      ],
    );
  }
}

/// Codes are digits only; Supabase sends 6 by default (up to 10 if changed).
String? _checkCode(BuildContext context, String code) => RegExp(r'^\d{6,10}$').hasMatch(code.trim()) ? null : context.s.badCode;

class _CodeField extends StatelessWidget {
  const _CodeField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) => AuthField(
    controller: controller,
    label: label,
    keyboard: TextInputType.number,
    hints: const [AutofillHints.oneTimeCode],
    maxLength: 10,
  );
}

/// "Send the code again", available 60 seconds after the last code.
mixin _ResendTimer<T extends StatefulWidget> on AuthFormMixin<T> {
  Timer? _timer;
  int _wait = 0;

  void startResendTimer() {
    _timer?.cancel();
    setState(() => _wait = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _wait--);
      if (_wait <= 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget resendButton(Future<void> Function() send) {
    final s = context.s;
    return TextButton(
      onPressed: busy || _wait > 0
          ? null
          : () => run(() async {
              await send();
              if (!mounted) return;
              showMessage(s.codeResent, error: false);
              startResendTimer();
            }),
      child: Text(_wait > 0 ? s.resendIn(_wait) : s.resendCode),
    );
  }
}

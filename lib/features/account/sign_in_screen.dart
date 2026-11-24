import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_scope.dart';

/// Sign in from inside the app (for example from the Premium page).
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.s.signIn)),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(24),
          children: [SignInForm(onDone: () => Navigator.of(context).pop())],
        ),
      ),
    ),
  );
}

/// Email and password fields with Sign in and Create account buttons.
/// [onDone] runs once the account is signed in.
class SignInForm extends StatefulWidget {
  const SignInForm({super.key, this.onDone});
  final VoidCallback? onDone;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
    } on AuthRetryableFetchException {
      // Network problem (no internet / server unreachable).
      if (mounted) setState(() => _message = context.s.loadFailed);
    } on AuthException catch (e) {
      final network = e.message.contains('SocketException') || e.message.contains('ClientException');
      if (mounted) setState(() => _message = network ? context.s.loadFailed : e.message);
    } catch (e) {
      if (mounted) setState(() => _message = context.s.loadFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final auth = context.services.auth;
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(labelText: s.email, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(labelText: s.password, border: const OutlineInputBorder()),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_message!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _busy
                ? null
                : () => _run(() async {
                    await auth.signIn(_email.text, _password.text);
                    widget.onDone?.call();
                  }),
            child: Text(s.signIn),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: _busy
                ? null
                : () => _run(() async {
                    final ready = await auth.signUp(_email.text, _password.text);
                    if (!mounted) return;
                    if (ready) {
                      widget.onDone?.call();
                    } else {
                      setState(() => _message = context.s.checkEmail);
                    }
                  }),
            child: Text(s.createAccount),
          ),
        ],
      ),
    );
  }
}

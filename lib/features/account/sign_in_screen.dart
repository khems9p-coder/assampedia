import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_scope.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _message;

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
    } on AuthException catch (e) {
      setState(() => _message = e.message);
    } catch (e) {
      setState(() => _message = context.s.loadFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final auth = context.services.auth;
    return Scaffold(
      appBar: AppBar(title: Text(s.signIn)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
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
                          if (context.mounted) Navigator.of(context).pop();
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
                          if (!context.mounted) return;
                          if (ready) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() => _message = context.s.checkEmail);
                          }
                        }),
                child: Text(s.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

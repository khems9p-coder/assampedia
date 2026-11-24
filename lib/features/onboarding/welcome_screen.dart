import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../account/sign_in_screen.dart';

/// The first screen after installing: the app icon, a welcome, an
/// encouraging line and sign-in. Readers reach the content after signing in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              children: [
                const Align(alignment: Alignment.centerRight, child: LanguageSwitch()),
                const SizedBox(height: 16),
                Center(child: Image.asset('assets/brand/logo.png', width: 112, height: 112)),
                const SizedBox(height: 12),
                Text(
                  'ASSAMPEDIA',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: scheme.primary, letterSpacing: 1.5),
                ),
                const SizedBox(height: 20),
                Text(
                  s.welcome,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  s.inspiration,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: scheme.onSurfaceVariant, height: 1.5),
                ),
                const SizedBox(height: 24),
                Text(s.signInToStart, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                // Signing in rebuilds the app's first screen, which then shows the content.
                SignInForm(onDone: () => context.services.language.set(context.lang)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

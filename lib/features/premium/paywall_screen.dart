import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/premium_service.dart';
import '../account/sign_in_screen.dart';
import '../jobs/vacancy_widgets.dart';
import '../reader/official_info.dart';

/// Opens [screen] if the reader may, otherwise the Premium page.
void openOrPaywall(BuildContext context, {required bool allowed, required Widget Function() screen}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => allowed ? screen() : const PaywallScreen()));
}

/// A small lock shown next to Premium-only items in lists.
class LockIcon extends StatelessWidget {
  const LockIcon({super.key});

  @override
  Widget build(BuildContext context) => Icon(Icons.lock_outline, size: 20, color: Theme.of(context).colorScheme.tertiary);
}

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.s.premium)),
    body: const PaywallBody(),
  );
}

/// What Premium includes, its price and the Subscribe button.
class PaywallBody extends StatelessWidget {
  const PaywallBody({super.key, this.locked = false});

  /// Shown in place of a locked page.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([services.premium, services.auth]),
      builder: (context, _) {
        final p = services.premium;
        Widget benefit(IconData icon, String text) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(text, style: theme.textTheme.bodyLarge),
        );
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Icon(p.isPremium ? Icons.workspace_premium : Icons.lock_outline, size: 56, color: theme.colorScheme.tertiary),
            const SizedBox(height: 8),
            Text(
              s.premiumTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (locked && !p.isPremium) ...[
              const SizedBox(height: 8),
              Text(s.lockedPage, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
            ],
            const SizedBox(height: 16),
            if (p.isPremium) ...[
              Text(s.youArePremium, textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
              if (p.expiresAt != null) Text(s.premiumUntil(formatDate(p.expiresAt!)), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => openLink(context, p.manageUrl),
                icon: const Icon(Icons.open_in_new),
                label: Text(s.manageSubscription),
              ),
            ] else ...[
              benefit(Icons.menu_book_outlined, s.benefitAll),
              benefit(Icons.quiz_outlined, s.benefitQuizzes),
              benefit(Icons.newspaper_outlined, s.benefitNews),
              benefit(Icons.work_outline, s.benefitFree),
              const SizedBox(height: 8),
              Text(s.freeNote, style: theme.textTheme.bodySmall),
              const SizedBox(height: 20),
              if (p.price != null)
                Text(
                  s.perYear(p.price!),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              const SizedBox(height: 12),
              if (!services.auth.isSignedIn) ...[
                Text(s.signInToSubscribe, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
                  icon: const Icon(Icons.login),
                  label: Text(s.signIn),
                ),
              ] else if (!p.storeAvailable || p.price == null)
                Text(s.storeUnavailable, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium)
              else ...[
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: p.busy ? null : p.buy,
                  icon: p.busy
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.workspace_premium),
                  label: Text(s.subscribe),
                ),
                TextButton(onPressed: p.busy ? null : p.restore, child: Text(s.restorePurchase)),
              ],
              if (p.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    p.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              const SizedBox(height: 12),
              Text(s.cancelAnytime, textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
            ],
          ],
        );
      },
    );
  }
}

/// Keeps "first 3 free" in one place for lists sorted the way readers see them.
bool isFreeIndex(int i) => i < freePerGroup;

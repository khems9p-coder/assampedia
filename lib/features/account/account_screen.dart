import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../admin/admin_home_screen.dart';
import '../jobs/vacancy_widgets.dart';
import '../premium/paywall_screen.dart';
import 'sign_in_screen.dart';

/// "Me" tab: language, light/dark mode, account and (for admins) the admin panel.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.navMe)),
      body: ListenableBuilder(
        listenable: Listenable.merge([services.auth, services.theme, services.premium]),
        builder: (context, _) {
          final auth = services.auth;
          return RefreshIndicator(
            onRefresh: () async {
              await auth.refresh();
              await services.premium.refresh();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _Section(s.language),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<AppLang>(
                    segments: [for (final l in AppLang.values) ButtonSegment(value: l, label: Text(l.label))],
                    selected: {context.lang},
                    onSelectionChanged: (v) => services.language.set(v.first),
                  ),
                ),
                _Section(s.appearance),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(value: ThemeMode.system, label: Text(s.followPhone)),
                      ButtonSegment(value: ThemeMode.light, label: Text(s.light)),
                      ButtonSegment(value: ThemeMode.dark, label: Text(s.dark)),
                    ],
                    selected: {services.theme.mode},
                    onSelectionChanged: (v) => services.theme.setMode(v.first),
                  ),
                ),
                _Section(s.premium),
                ListTile(
                  leading: Icon(
                    services.premium.isPremium ? Icons.workspace_premium : Icons.lock_open_outlined,
                    color: theme.colorScheme.tertiary,
                  ),
                  title: Text(services.premium.isPremium ? s.premiumTitle : s.freePlan),
                  subtitle: Text(
                    services.premium.isPremium
                        ? (services.premium.expiresAt == null ? s.youArePremium : s.premiumUntil(formatDate(services.premium.expiresAt!)))
                        : s.seePremium,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaywallScreen())),
                ),
                _Section(s.account),
                if (!auth.available)
                  ListTile(leading: const Icon(Icons.cloud_off_outlined), title: Text(s.notConnected))
                else if (!auth.isSignedIn)
                  ListTile(
                    leading: Icon(Icons.login, color: theme.colorScheme.primary),
                    title: Text(s.signIn),
                    subtitle: Text(s.signInHint),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
                  )
                else ...[
                  ListTile(leading: const Icon(Icons.account_circle_outlined), title: Text(s.signedInAs(auth.user!.email ?? ''))),
                  if (auth.isAdmin)
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings_outlined, color: theme.colorScheme.primary),
                      title: Text(s.adminPanel),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminHomeScreen())),
                    ),
                  if (auth.adminCheckError != null)
                    ListTile(
                      leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
                      title: const Text("Couldn't check admin access"),
                      subtitle: Text(auth.adminCheckError!, maxLines: 4, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(tooltip: s.retry, icon: const Icon(Icons.refresh), onPressed: auth.refresh),
                    ),
                  ListTile(leading: const Icon(Icons.logout), title: Text(s.signOut), onTap: auth.signOut),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
  );
}

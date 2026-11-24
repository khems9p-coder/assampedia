import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_scope.dart';
import '../account/profile_screen.dart';
import '../dictionary/dictionary_screen.dart';
import '../notifications/notifications_screen.dart';
import '../practice/practice_screen.dart';
import '../premium/paywall_screen.dart';
import '../saved/saved_screen.dart';

/// The app's page on Google Play (works once the app is published there).
const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.assampedia.app';

/// Tab numbers in the bottom bar.
abstract final class Tabs {
  static const home = 0, learn = 1, exams = 2, jobs = 3, me = 4;
}

/// The side menu opened from the Home screen's menu button.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key, required this.openTab});
  final ValueChanged<int> openTab;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final services = context.services;
    final auth = services.auth;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = (auth.profile?.fullName ?? '').trim();

    void close() => Navigator.of(context).pop();
    void push(Widget screen) {
      close();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    }

    void tab(int i) {
      close();
      openTab(i);
    }

    Widget item(IconData icon, String label, VoidCallback onTap, {bool selected = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedTileColor: scheme.primary,
        selectedColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        onTap: onTap,
      ),
    );

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/brand/logo.png', width: 56, height: 56),
                  const SizedBox(height: 12),
                  Text(s.welcome, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                  Text(
                    name.isEmpty ? 'ASSAMPEDIA' : name,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (auth.user?.email != null)
                    Text(auth.user!.email!, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            item(Icons.home_outlined, s.navHome, close, selected: true),
            if (auth.isSignedIn) item(Icons.account_circle_outlined, s.myProfile, () => push(const ProfileScreen())),
            item(Icons.notifications_outlined, s.notifications, () => push(const NotificationsScreen())),
            item(Icons.workspace_premium_outlined, s.premium, () => push(const PaywallScreen())),
            item(Icons.quiz_outlined, s.practiceZone, () => push(const PracticeScreen())),
            item(Icons.translate, s.dictionary, () => push(const DictionaryScreen())),
            item(Icons.bookmarks_outlined, s.saved, () => push(const SavedScreen())),
            item(Icons.settings_outlined, s.settings, () => tab(Tabs.me)),
            const Divider(indent: 24, endIndent: 24),
            item(Icons.share_outlined, s.shareApp, () {
              close();
              SharePlus.instance.share(ShareParams(text: s.shareText(playStoreUrl)));
            }),
            item(Icons.star_outline, s.rateApp, () {
              close();
              launchUrl(Uri.parse(playStoreUrl), mode: LaunchMode.externalApplication);
            }),
            if (auth.isSignedIn) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: scheme.error,
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  icon: const Icon(Icons.logout),
                  label: Text(s.signOut),
                  onPressed: () {
                    close();
                    auth.signOut();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

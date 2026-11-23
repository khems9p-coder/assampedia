import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

/// Phase 1 screen: shows the brand, the colour code legend,
/// and lets you switch between light and dark mode.
/// The real home screen arrives in Phase 2.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('ASSAMPEDIA', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        actions: [
          PopupMenuButton<ThemeMode>(
            tooltip: 'Light or dark mode',
            icon: const Icon(Icons.brightness_6_outlined),
            initialValue: themeController.mode,
            onSelected: themeController.setMode,
            itemBuilder: (_) => const [
              PopupMenuItem(value: ThemeMode.system, child: Text('Follow phone')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                const SizedBox(height: 12),
                Center(child: Image.asset('assets/brand/logo.png', width: 140, height: 140)),
                const SizedBox(height: 16),
                Text('ASSAMPEDIA',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700, color: scheme.primary, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                Text('Explore Assam. Learn. Prepare. Succeed.',
                    textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('অসমীয়া | English',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(color: scheme.secondary)),
                const SizedBox(height: 28),
                Text('Colour guide', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        for (final c in ContentColor.values)
                          ListTile(
                            dense: true,
                            leading: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(color: c.of(context), borderRadius: BorderRadius.circular(6)),
                            ),
                            title: Text(c.meaningEn, style: theme.textTheme.bodyMedium),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Brand colours', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _Swatch('Tea green', AppColors.teaGreen),
                    _Swatch('Brahmaputra blue', AppColors.brahmaputraBlue),
                    _Swatch('Muga gold', AppColors.mugaGold),
                    _Swatch('Gamosa red', AppColors.gamosaRed),
                    _Swatch('Earth', AppColors.earth),
                  ],
                ),
                const SizedBox(height: 28),
                Text('Phase 1 test build. The home screen, language switch and Assam GK chapters come in Phase 2.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: Column(
        children: [
          Container(height: 48, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12))),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

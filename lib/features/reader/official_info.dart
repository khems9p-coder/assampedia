import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_scope.dart';
import '../../data/models.dart';

/// Opens an official web address in the phone's browser.
Future<void> openLink(BuildContext context, String url) async {
  final s = context.s;
  final messenger = ScaffoldMessenger.of(context);
  final uri = Uri.tryParse(url.trim());
  var ok = false;
  if (uri != null && (uri.scheme == 'https' || uri.scheme == 'http')) {
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
  }
  if (!ok) messenger.showSnackBar(SnackBar(content: Text(s.cantOpenLink)));
}

/// For exam and career pages: which version/date the page applies to, and
/// buttons to the official website and notification.
class OfficialInfo extends StatelessWidget {
  const OfficialInfo({super.key, required this.chapter});
  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chapter.appliesTo != null)
            Row(
              children: [
                Icon(Icons.event_note_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(s.appliesTo(chapter.appliesTo!), style: theme.textTheme.titleSmall)),
              ],
            ),
          if (chapter.officialUrl != null || chapter.notificationUrl != null) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (chapter.officialUrl != null)
                  FilledButton.tonalIcon(
                    onPressed: () => openLink(context, chapter.officialUrl!),
                    icon: const Icon(Icons.public, size: 18),
                    label: Text(s.officialWebsite),
                  ),
                if (chapter.notificationUrl != null)
                  FilledButton.tonalIcon(
                    onPressed: () => openLink(context, chapter.notificationUrl!),
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: Text(s.officialNotification),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(s.checkOfficial, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

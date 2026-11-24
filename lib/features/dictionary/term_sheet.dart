import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../data/models.dart';

/// Shows a dictionary word and its meaning in both languages.
Future<void> showTermSheet(BuildContext context, {Term? term, String? missingSlug}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _TermSheet(term: term, missingSlug: missingSlug),
  );
}

class _TermSheet extends StatelessWidget {
  const _TermSheet({this.term, this.missingSlug});
  final Term? term;
  final String? missingSlug;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final t = term;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: t == null
              ? Text(s.termMissing, style: theme.textTheme.titleMedium)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.name(lang), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                    if (t.nameIn(lang.other) != null && t.nameIn(lang.other) != t.name(lang))
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(t.nameIn(lang.other)!, style: theme.textTheme.titleMedium?.copyWith(color: muted)),
                      ),
                    const SizedBox(height: 16),
                    if (t.meaningIn(lang) != null) Text(t.meaningIn(lang)!, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                    if (t.meaningIn(lang.other) != null) ...[
                      const Divider(height: 32),
                      Text(lang.other.label, style: theme.textTheme.labelMedium?.copyWith(color: muted)),
                      const SizedBox(height: 4),
                      Text(t.meaningIn(lang.other)!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6, color: muted)),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

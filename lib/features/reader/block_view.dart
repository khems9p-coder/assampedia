import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../core/i18n/strings.dart';
import '../../data/models.dart';
import '../dictionary/term_text.dart';

ContentColor? contentColorFor(BlockStyle s) => switch (s) {
  BlockStyle.normal => null,
  BlockStyle.definition => ContentColor.definition,
  BlockStyle.verifiedFact => ContentColor.verifiedFact,
  BlockStyle.event => ContentColor.event,
  BlockStyle.personality => ContentColor.personality,
  BlockStyle.examFact => ContentColor.examFact,
  BlockStyle.geography => ContentColor.geography,
  BlockStyle.heritage => ContentColor.heritage,
  BlockStyle.suggested => ContentColor.suggested,
};

/// Draws one paragraph, heading, list, image or coloured fact box.
class BlockView extends StatelessWidget {
  const BlockView({super.key, required this.block, this.terms = const {}, this.onTerm, this.lang});
  final Block block;
  final Map<String, Term> terms;
  final void Function(String slug)? onTerm;
  final AppLang? lang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = theme.textTheme.bodyLarge?.copyWith(height: 1.65, fontSize: 17);
    final color = contentColorFor(block.style)?.of(context);
    final lang = this.lang ?? context.lang;
    Widget rich(String text, TextStyle? style) => TermText(text, style: style, terms: terms, onTerm: onTerm, lang: lang);

    Widget child = switch (block.type) {
      BlockType.heading => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          plainText(block.body, terms, lang),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: color ?? theme.colorScheme.primary),
        ),
      ),
      BlockType.list => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in block.body.split('\n').where((l) => l.trim().isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: color ?? theme.colorScheme.primary, shape: BoxShape.circle),
                    ),
                  ),
                  Expanded(child: rich(line.trim(), body)),
                ],
              ),
            ),
        ],
      ),
      BlockType.image => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (block.imageUrl != null && block.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                block.imageUrl!,
                errorBuilder: (_, _, _) => const SizedBox(height: 80, child: Center(child: Icon(Icons.broken_image_outlined))),
              ),
            ),
          if (block.body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(plainText(block.body, terms, lang), style: theme.textTheme.bodySmall),
            ),
        ],
      ),
      _ => rich(block.body, body),
    };

    final suggested = block.style == BlockStyle.suggested && block.type != BlockType.heading && block.type != BlockType.image;
    if (suggested) {
      // Make it impossible to mistake a preparation tip for official information.
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.lightbulb_outline, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(child: Text(S(lang).suggestedLabel, style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600))),
          ]),
          const SizedBox(height: 6),
          child,
        ],
      );
    }

    if (suggested || block.type == BlockType.factBox || (color != null && block.type == BlockType.paragraph)) {
      final c = color ?? theme.colorScheme.primary;
      child = Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: c, width: 4)),
        ),
        child: child,
      );
    }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: child);
  }
}

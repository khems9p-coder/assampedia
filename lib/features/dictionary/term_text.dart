import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../core/i18n/app_lang.dart';
import '../../data/models.dart';

/// Paragraph text in which dictionary terms are underlined and tappable.
class TermText extends StatefulWidget {
  const TermText(this.body, {super.key, this.style, this.terms = const {}, this.onTerm, this.lang});

  final String body;
  final TextStyle? style;
  final Map<String, Term> terms;
  final void Function(String slug)? onTerm;

  /// Language used for term words; defaults to the app language.
  final AppLang? lang;

  @override
  State<TermText> createState() => _TermTextState();
}

class _TermTextState extends State<TermText> {
  final _recognizers = <TapGestureRecognizer>[];

  void _clear() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  TapGestureRecognizer? _tap(String slug) {
    final onTerm = widget.onTerm;
    if (onTerm == null) return null;
    final r = TapGestureRecognizer()..onTap = () => onTerm(slug);
    _recognizers.add(r);
    return r;
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _clear();
    final parts = parseInline(widget.body);
    if (parts.every((p) => !p.isTerm)) return Text(widget.body, style: widget.style);
    final lang = widget.lang ?? context.lang;
    final scheme = Theme.of(context).colorScheme;
    return Text.rich(
      TextSpan(
        style: widget.style,
        children: [
          for (final p in parts)
            if (!p.isTerm)
              TextSpan(text: p.text)
            else
              TextSpan(
                text: p.text ?? widget.terms[p.termSlug]?.name(lang) ?? p.termSlug!.replaceAll('-', ' '),
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted,
                  decorationColor: scheme.primary,
                ),
                recognizer: _tap(p.termSlug!),
              ),
        ],
      ),
    );
  }
}

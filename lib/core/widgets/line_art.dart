import 'package:flutter/material.dart';

/// Small black line drawings used around the app (Home, Study, chapters,
/// mock tests). They are drawn in code, so they cost no download and follow
/// light and dark mode automatically.
enum LineArt {
  /// A namghar-style building with a flag, hills and birds.
  heritage(230, 120, [
    'M10 104h210',
    'M60 104V60l55-28 55 28v44',
    'M50 62l65-34 65 34',
    'M100 104V76c0-8 7-14 15-14s15 6 15 14v28',
    'M76 72h12v12H76z',
    'M142 72h12v12h-12z',
    'M115 32V14l14 5-14 5',
    'M14 104c6-14 14-20 22-18s8 10 4 18',
    'M196 104c4-12 12-18 18-14',
    'M20 40c6-5 12-5 18 0',
    'M180 28c5-4 10-4 15 0',
  ], [(0, 0, 0)]),

  /// A small house and a tower with a flag and the sun (Premium card).
  town(110, 100, [
    'M10 82h90',
    'M22 82V48l14-8 14 8v34',
    'M30 82V62h12v20',
    'M58 82V38c0-6 6-12 14-12s14 6 14 12v44',
    'M64 52h16',
    'M64 60h16',
    'M64 68h16',
    'M72 26v-10l8 3-8 3',
    'M14 30c4-4 8-4 12 0',
    'M18 22c3-3 6-3 9 0',
  ], [(96, 22, 7)]),

  /// A row of books on a shelf and the sun (Study).
  books(96, 80, [
    'M8 70h80',
    'M18 70V30h20v40',
    'M38 70V22h18v48',
    'M56 70V36h20v34',
    'M22 38h12',
    'M22 44h12',
    'M42 30h10',
    'M42 36h10',
    'M60 44h12',
    'M60 50h12',
  ], [(80, 16, 6)]),

  /// A student at a desk (mock tests).
  desk(160, 90, [
    'M10 84h140',
    'M40 84V56h46v28',
    'M34 56h58',
    'M104 37v22l-10 25',
    'M104 59l10 25',
    'M104 44l-16 10',
    'M104 44l14 6',
    'M50 50l8-14h14l6 14',
    'M128 20c4-6 10-6 14 0',
    'M134 12c3-3 6-3 8 0',
  ], [(104, 28, 9)]);

  const LineArt(this.width, this.height, this.paths, this.circles);
  final double width;
  final double height;
  final List<String> paths;
  final List<(double, double, double)> circles;
}

/// Draws a [LineArt] at the given height in the text colour.
class LineArtView extends StatelessWidget {
  const LineArtView(this.art, {super.key, this.height = 80, this.color});
  final LineArt art;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: height * art.width / art.height,
        child: CustomPaint(painter: _LineArtPainter(art, c)),
      ),
    );
  }
}

class _LineArtPainter extends CustomPainter {
  _LineArtPainter(this.art, this.color);
  final LineArt art;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / art.height;
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final d in art.paths) {
      canvas.drawPath(parseSvgPath(d), paint);
    }
    for (final (x, y, r) in art.circles) {
      if (r > 0) canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_LineArtPainter old) => old.art != art || old.color != color;
}

/// Reads the simple SVG path commands used above (M L H V C S Z, upper and
/// lower case). Enough for these drawings, not a full SVG reader.
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = RegExp(r'[MmLlHhVvCcSsZz]|-?\d*\.?\d+').allMatches(d).map((m) => m.group(0)!).toList();
  var i = 0;
  var cmd = 'M';
  var x = 0.0, y = 0.0, startX = 0.0, startY = 0.0;
  double? lastCx, lastCy;
  double n() => double.parse(tokens[i++]);
  bool isNum() => i < tokens.length && !RegExp(r'^[A-Za-z]$').hasMatch(tokens[i]);
  while (i < tokens.length) {
    if (!isNum()) cmd = tokens[i++];
    final rel = cmd == cmd.toLowerCase();
    final ox = rel ? x : 0.0, oy = rel ? y : 0.0;
    switch (cmd.toUpperCase()) {
      case 'M':
        x = ox + n();
        y = oy + n();
        startX = x;
        startY = y;
        path.moveTo(x, y);
        cmd = rel ? 'l' : 'L'; // more numbers after M are lines
        lastCx = null;
      case 'L':
        x = ox + n();
        y = oy + n();
        path.lineTo(x, y);
        lastCx = null;
      case 'H':
        x = ox + n();
        path.lineTo(x, y);
        lastCx = null;
      case 'V':
        y = oy + n();
        path.lineTo(x, y);
        lastCx = null;
      case 'C':
        final x1 = ox + n(), y1 = oy + n(), x2 = ox + n(), y2 = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2;
        lastCy = y2;
      case 'S':
        final x1 = lastCx == null ? x : 2 * x - lastCx;
        final y1 = lastCy == null ? y : 2 * y - lastCy;
        final x2 = ox + n(), y2 = oy + n();
        x = ox + n();
        y = oy + n();
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2;
        lastCy = y2;
      case 'Z':
        path.close();
        x = startX;
        y = startY;
        lastCx = null;
      default:
        i++;
    }
  }
  return path;
}

/// A white card with a short message and a line drawing on the right,
/// used at the top of lists (Study, mock tests and so on).
class IntroCard extends StatelessWidget {
  const IntroCard({super.key, this.title, required this.text, required this.art, this.color});
  final String? title;
  final String text;
  final LineArt art;

  /// Background; white card by default.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: color ?? scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: color == null ? Border.all(color: scheme.outlineVariant) : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(title!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                ],
                Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          LineArtView(art, height: 72),
        ],
      ),
    );
  }
}

/// Two or three tabs drawn as a pill switch: the open one is solid black.
class PillTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PillTabBar({super.key, required this.labels});
  final List<String> labels;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
        child: TabBar(
          indicator: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(9)),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: scheme.onPrimary,
          unselectedLabelColor: scheme.onSurfaceVariant,
          dividerColor: Colors.transparent,
          splashBorderRadius: BorderRadius.circular(9),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          tabs: [for (final l in labels) Tab(text: l, height: 36)],
        ),
      ),
    );
  }
}

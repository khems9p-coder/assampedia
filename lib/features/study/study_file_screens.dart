import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_scope.dart';
import '../../core/widgets/common.dart';
import '../../data/study_models.dart';

/// Asks the database for a short-lived address for the file, then shows it.
mixin _SignedUrl<T extends StatefulWidget> on State<T> {
  Future<String>? url;

  String get path;

  void fetchUrl() => url = context.services.content!.studyFileUrl(path);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (url == null) fetchUrl();
  }
}

/// Reads a PDF inside the app.
class StudyPdfScreen extends StatefulWidget {
  const StudyPdfScreen({super.key, required this.item, this.shareText});
  final StudyItem item;

  /// For free PDFs: what the Share button sends (the item's name and the app link).
  final String? shareText;

  @override
  State<StudyPdfScreen> createState() => _StudyPdfScreenState();
}

class _StudyPdfScreenState extends State<StudyPdfScreen> with _SignedUrl {
  @override
  String get path => widget.item.filePath!;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title(context.lang)),
        actions: [
          if (widget.shareText != null && widget.item.isFree)
            IconButton(
              tooltip: s.sharePdf,
              icon: const Icon(Icons.share_outlined),
              onPressed: () => SharePlus.instance.share(ShareParams(text: widget.shareText)),
            ),
        ],
      ),
      body: FutureBuilder<String>(
        future: url,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: s.fileNeedsInternet, onRetry: () => setState(fetchUrl));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return PdfViewer.uri(
            Uri.parse(snap.data!),
            params: PdfViewerParams(
              loadingBannerBuilder: (context, done, total) => const Center(child: CircularProgressIndicator()),
              errorBannerBuilder: (context, error, stack, ref) =>
                  LoadError(message: s.fileNeedsInternet, onRetry: () => setState(fetchUrl)),
            ),
          );
        },
      ),
    );
  }
}

/// Shows a picture full screen; pinch to zoom.
class StudyImageScreen extends StatefulWidget {
  const StudyImageScreen({super.key, required this.item});
  final StudyItem item;

  @override
  State<StudyImageScreen> createState() => _StudyImageScreenState();
}

class _StudyImageScreenState extends State<StudyImageScreen> with _SignedUrl {
  @override
  String get path => widget.item.filePath!;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final lang = context.lang;
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.title(lang))),
      body: FutureBuilder<String>(
        future: url,
        builder: (context, snap) {
          if (snap.hasError) return LoadError(message: s.fileNeedsInternet, onRetry: () => setState(fetchUrl));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  maxScale: 5,
                  child: Center(
                    child: Image.network(
                      snap.data!,
                      loadingBuilder: (context, child, p) => p == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, e, st) => LoadError(message: s.fileNeedsInternet, onRetry: () => setState(fetchUrl)),
                    ),
                  ),
                ),
              ),
              if (widget.item.description(lang) != null)
                Padding(padding: const EdgeInsets.all(16), child: Text(widget.item.description(lang)!)),
            ],
          );
        },
      ),
    );
  }
}

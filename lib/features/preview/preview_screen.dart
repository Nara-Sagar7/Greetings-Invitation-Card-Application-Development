import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/export_service.dart';
import '../editor/providers/editor_provider.dart';
import '../editor/widgets/canvas_renderer.dart';

/// Preview Screen - WYSIWYG core P1: preview == export 2.0
class PreviewScreen extends ConsumerStatefulWidget {
  final String? templateId;
  const PreviewScreen({super.key, this.templateId});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _exporting = false;

  Future<void> _export() async {
    setState(() => _exporting = true);
    final file = await ExportService.exportPng(
      _repaintKey,
      fileName: 'preview_${widget.templateId ?? 'export'}',
    );
    if (!mounted) return;
    setState(() => _exporting = false);
    if (file == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Export failed')));
      return;
    }
    final len = await file.length();
    if (!mounted) return;
    final sizeOk = len <= AppConstants.maxImageSizeBytes;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exported ${file.path.split('/').last} ${(len / 1024).toStringAsFixed(1)}KB • 2.0× ${sizeOk ? '✓' : 'exceeds 5MB'}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tid =
        widget.templateId ??
        GoRouterState.of(context).uri.queryParameters['templateId'] ??
        'template_diwali_1';
    final state = ref.watch(editorProvider(tid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview • Pixel-accurate'),
        actions: [
          IconButton(
            onPressed: _exporting ? null : _export,
            icon: _exporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CanvasRenderer(
                    state: state,
                    showGuides: false,
                    repaintKey: _repaintKey,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          color: AppColors.success,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This preview = what guests receive. WYSIWYG verified.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Envelope animation shown to guest on open',
                    style: AppTypography.captionMono.copyWith(
                      color: AppColors.hint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Back to Editor'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push('/guest-list'),
                    child: const Text('Next: Guests →'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

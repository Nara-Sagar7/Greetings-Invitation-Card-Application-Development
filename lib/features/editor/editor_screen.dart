import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/data_providers.dart';
import '../../services/billing_service.dart';
import '../../services/image_compress_service.dart';
import 'providers/editor_provider.dart';
import 'widgets/editor_canvas.dart';
import 'widgets/editor_controls.dart';

/// Editor Screen - P1 shared renderer + image picker + draft resume
class EditorScreen extends ConsumerStatefulWidget {
  final String templateId;
  final String? draftId;
  const EditorScreen({super.key, required this.templateId, this.draftId});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    if (widget.draftId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted)
          ref
              .read(editorProvider(widget.templateId).notifier)
              .loadDraft(widget.draftId!);
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(EditorNotifier notifier) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    final file = File(xfile.path);
    final bytes = await file.length();
    if (!ImageCompressService.isValidSize(bytes) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ImageCompressService.getCompressionNote(bytes))),
      );
    }
    final compressed = await ImageCompressService.compressXFile(xfile.path);
    if (compressed == null) return;
    final tmp = File(
      '${Directory.systemTemp.path}/cmp_${DateTime.now().millisecondsSinceEpoch}.webp',
    );
    await tmp.writeAsBytes(compressed);
    notifier.updateImagePath(tmp.path);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Photo added • WebP 1080p')));
    }
  }

  Future<void> _pickSticker(EditorNotifier notifier) async {
    const stickers = ['🪔', '🎉', '💍', '🎂', '🙏', '✨', '❤️', '🎊'];
    final s = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Pick sticker'),
        children: stickers
            .map(
              (e) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, e),
                child: Text(e, style: const TextStyle(fontSize: 28)),
              ),
            )
            .toList(),
      ),
    );
    if (s != null) notifier.updateSticker(s);
  }

  Future<void> _pickColor(EditorNotifier notifier) async {
    const colors = [
      AppColors.twilightPlum,
      AppColors.marigoldGold,
      AppColors.blushCoral,
      Colors.black,
      Colors.white,
    ];
    final c = await showDialog<Color>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Pick accent'),
        children: colors
            .map(
              (col) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, col),
                child: Container(height: 24, color: col),
              ),
            )
            .toList(),
      ),
    );
    if (c != null) notifier.updateCanvas({'accentColor': c.value});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider(widget.templateId));
    final notifier = ref.read(editorProvider(widget.templateId).notifier);
    // Template load P1-6 - skip if resuming draft
    if (widget.draftId == null) {
      final templateAsync = ref.watch(templateByIdProvider(widget.templateId));
      templateAsync.whenData((tpl) {
        if (tpl != null &&
            state.canvasJson.isEmpty &&
            tpl.canvasJson.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) notifier.updateCanvas(tpl.canvasJson);
          });
        }
      });
    }
    // Autosave debounce P1-6
    ref.listen(editorProvider(widget.templateId), (prev, next) {
      if (next.isDirty && (prev?.isDirty == false || prev == null)) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          final cur = ref.read(editorProvider(widget.templateId));
          if (cur.isDirty) notifier.saveDraft();
        });
      }
    });
    if (_titleCtrl.text != state.title) {
      _titleCtrl.value = TextEditingValue(
        text: state.title,
        selection: TextSelection.collapsed(offset: state.title.length),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editor • ${widget.templateId}',
          style: AppTypography.labelMedium,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                context.push('/preview?templateId=${widget.templateId}'),
            child: const Text('Preview'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: EditorCanvas(state: state)),
          EditorControls(
            titleCtrl: _titleCtrl,
            fontSize: state.fontSize,
            canUndo: notifier.canUndo,
            canRedo: notifier.canRedo,
            onTitleChanged: notifier.updateTitle,
            onFontSizeChanged: notifier.updateFontSize,
            onUndo: notifier.undo,
            onRedo: notifier.redo,
            onPickImage: () => _pickImage(notifier),
            onPickSticker: () => _pickSticker(notifier),
            onPickColor: () => _pickColor(notifier),
            onClearImage: () => notifier.updateImagePath(null),
            onSaveDraft: () async {
              if (!await BillingService.canCreateCard()) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Free limit 5 cards/month reached. Upgrade to Premium.',
                    ),
                  ),
                );
                return;
              }
              final id = await notifier.saveDraft();
              await BillingService.recordCard();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Draft saved ($id) — ${AppConstants.offlineLabel}',
                  ),
                ),
              );
            },
            onPreview: () =>
                context.push('/preview?templateId=${widget.templateId}'),
          ),
        ],
      ),
    );
  }
}

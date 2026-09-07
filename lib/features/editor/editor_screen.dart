import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_typography.dart';
import 'providers/editor_provider.dart';
import 'widgets/editor_canvas.dart';
import 'widgets/editor_controls.dart';

/// Editor Screen - #3 of 9 - PRD 05
/// Phase C: Riverpod undo/redo + Hive draft.
/// Same renderer as preview/export.
class EditorScreen extends ConsumerStatefulWidget {
  final String templateId;
  const EditorScreen({super.key, required this.templateId});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late TextEditingController _titleCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider(widget.templateId));
    final notifier = ref.read(editorProvider(widget.templateId).notifier);

    if (_titleCtrl.text != state.title &&
        _titleCtrl.text.isEmpty == false &&
        state.title != _titleCtrl.text) {
      // Sync only when state changes externally
    }
    // Keep controller in sync without loop
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
            onPressed: () => context.push('/preview'),
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
            onSaveDraft: () async {
              final id = await notifier.saveDraft();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Draft saved ($id) — offline ready')),
              );
            },
            onPreview: () => context.push('/preview'),
          ),
        ],
      ),
    );
  }
}

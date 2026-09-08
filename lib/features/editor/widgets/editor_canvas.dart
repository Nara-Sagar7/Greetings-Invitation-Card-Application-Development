import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/editor_provider.dart';
import '../providers/editor_state.dart';
import 'canvas_renderer.dart';

/// WYSIWYG canvas — P1 shared renderer with drag.
class EditorCanvas extends ConsumerWidget {
  final EditorState state;
  const EditorCanvas({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: CanvasRenderer(
        state: state,
        showGuides: true,
        onTitleDrag: (delta) {
          final notifier = ref.read(editorProvider(state.templateId).notifier);
          final cur = state.titleOffset;
          notifier.updateTitleOffset(cur + delta);
        },
      ),
    );
  }
}

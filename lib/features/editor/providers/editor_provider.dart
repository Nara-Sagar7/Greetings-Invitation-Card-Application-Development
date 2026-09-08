import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/data_providers.dart';
import '../../../models/event_model.dart';
import 'editor_state.dart';

/// EditorNotifier — undo/redo + Hive draft.
/// Phase C: saves via DataRepository (local).
/// Phase B: same notifier works with Firebase
/// repo (no UI change).
class EditorNotifier extends StateNotifier<EditorState> {
  final Ref _ref;
  final List<EditorState> _undo = [];
  final List<EditorState> _redo = [];

  EditorNotifier(this._ref, String templateId)
    : super(EditorState(templateId: templateId));

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;

  void _pushHistory() {
    _undo.add(state);
    if (_undo.length > 50) _undo.removeAt(0);
    _redo.clear();
  }

  void updateTitle(String v) {
    if (v == state.title) return;
    _pushHistory();
    state = state.copyWith(title: v, isDirty: true);
  }

  void updateFontSize(double v) {
    _pushHistory();
    state = state.copyWith(fontSize: v, isDirty: true);
  }

  void updateCanvas(Map<String, dynamic> j) {
    _pushHistory();
    state = state.copyWith(canvasJson: j, isDirty: true);
  }

  void updateTitleOffset(Offset o) {
    _pushHistory();
    state = state.copyWith(titleOffset: o, isDirty: true);
  }

  void updateImagePath(String? path) {
    _pushHistory();
    state = state.copyWith(imagePath: path, isDirty: true);
  }

  void updateSticker(String? s) {
    _pushHistory();
    state = state.copyWith(sticker: s, isDirty: true);
  }

  void undo() {
    if (!canUndo) return;
    _redo.add(state);
    state = _undo.removeLast();
  }

  void redo() {
    if (!canRedo) return;
    _undo.add(state);
    state = _redo.removeLast();
  }

  Future<String> saveDraft() async {
    final repo = _ref.read(dataRepositoryProvider);
    final id =
        'draft_${state.templateId}_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final event = EventModel(
      id: id,
      hostId: 'local_user',
      title: state.title,
      dateTime: now.add(const Duration(days: 7)),
      timezone: 'Asia/Kolkata',
      location: 'To be decided',
      description: 'Created in editor',
      templateId: state.templateId,
      canvasJson: {
        ...state.canvasJson,
        'title': state.title,
        'fontSize': state.fontSize,
        'titleOffsetDx': state.titleOffset.dx,
        'titleOffsetDy': state.titleOffset.dy,
        'imagePath': state.imagePath,
        'sticker': state.sticker,
      },
      status: 'draft',
      guestEmails: const [],
      createdAt: now,
      updatedAt: now,
    );
    await repo.saveDraft(event);
    // Mark clean after save but keep history.
    state = state.copyWith(isDirty: false);
    // Invalidate drafts list.
    _ref.invalidate(draftsProvider);
    return id;
  }

  Future<void> loadDraft(String draftId) async {
    final repo = _ref.read(dataRepositoryProvider);
    final d = await repo.getDraft(draftId);
    if (d == null) return;
    state = EditorState(
      templateId: d.templateId,
      title: d.title,
      fontSize: (d.canvasJson['fontSize'] as num?)?.toDouble() ?? 18,
      canvasJson: d.canvasJson,
      isDirty: false,
      titleOffset: Offset(
        (d.canvasJson['titleOffsetDx'] as num?)?.toDouble() ?? 0,
        (d.canvasJson['titleOffsetDy'] as num?)?.toDouble() ?? 0,
      ),
      imagePath: d.canvasJson['imagePath'] as String?,
      sticker: d.canvasJson['sticker'] as String?,
    );
    _undo.clear();
    _redo.clear();
  }
}

final editorProvider =
    StateNotifierProvider.family<EditorNotifier, EditorState, String>(
      (ref, templateId) => EditorNotifier(ref, templateId),
    );

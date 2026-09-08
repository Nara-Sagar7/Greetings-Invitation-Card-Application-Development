import 'dart:ui';

/// EditorState — immutable snapshot for undo/redo.
/// P1 shared renderer + drag + image.
class EditorState {
  final String templateId;
  final String title;
  final double fontSize;
  final Map<String, dynamic> canvasJson;
  final bool isDirty;
  final Offset titleOffset;
  final String? imagePath;
  final String? sticker;

  const EditorState({
    required this.templateId,
    this.title = 'You are invited!',
    this.fontSize = 18,
    this.canvasJson = const {},
    this.isDirty = false,
    this.titleOffset = Offset.zero,
    this.imagePath,
    this.sticker,
  });

  EditorState copyWith({
    String? title,
    double? fontSize,
    Map<String, dynamic>? canvasJson,
    bool? isDirty,
    Offset? titleOffset,
    String? imagePath,
    String? sticker,
  }) {
    return EditorState(
      templateId: templateId,
      title: title ?? this.title,
      fontSize: fontSize ?? this.fontSize,
      canvasJson: canvasJson ?? this.canvasJson,
      isDirty: isDirty ?? this.isDirty,
      titleOffset: titleOffset ?? this.titleOffset,
      imagePath: imagePath ?? this.imagePath,
      sticker: sticker ?? this.sticker,
    );
  }
}

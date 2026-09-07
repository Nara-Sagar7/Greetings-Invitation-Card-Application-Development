/// EditorState — immutable snapshot for
/// undo/redo. Phase C offline.
class EditorState {
  final String templateId;
  final String title;
  final double fontSize;
  final Map<String, dynamic> canvasJson;
  final bool isDirty;

  const EditorState({
    required this.templateId,
    this.title = 'You are invited!',
    this.fontSize = 18,
    this.canvasJson = const {},
    this.isDirty = false,
  });

  EditorState copyWith({
    String? title,
    double? fontSize,
    Map<String, dynamic>? canvasJson,
    bool? isDirty,
  }) {
    return EditorState(
      templateId: templateId,
      title: title ?? this.title,
      fontSize: fontSize ?? this.fontSize,
      canvasJson: canvasJson ?? this.canvasJson,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

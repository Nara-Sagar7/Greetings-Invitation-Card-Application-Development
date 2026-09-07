/// Template Model - PRD 06.4
/// Structured JSON -> Single Canvas Engine (WYSIWYG guarantee)
class TemplateModel {
  final String id;
  final String occasionId;
  final String name;
  final String category; // evergreen / indianFestival / broadFestival
  final String thumbnailUrl;
  final bool isPremium;
  final bool culturalReviewPassed;
  final Map<String, dynamic> canvasJson;
  final List<String> fonts;
  final List<String> colors;

  const TemplateModel({
    required this.id,
    required this.occasionId,
    required this.name,
    required this.category,
    required this.thumbnailUrl,
    required this.isPremium,
    this.culturalReviewPassed = false,
    required this.canvasJson,
    required this.fonts,
    required this.colors,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
        id: json['id'] as String,
        occasionId: json['occasionId'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        isPremium: json['isPremium'] as bool? ?? false,
        culturalReviewPassed: json['culturalReviewPassed'] as bool? ?? true,
        canvasJson: json['canvasJson'] as Map<String, dynamic>? ?? {},
        fonts: List<String>.from(json['fonts'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'occasionId': occasionId,
        'name': name,
        'category': category,
        'thumbnailUrl': thumbnailUrl,
        'isPremium': isPremium,
        'culturalReviewPassed': culturalReviewPassed,
        'canvasJson': canvasJson,
        'fonts': fonts,
        'colors': colors,
      };
}

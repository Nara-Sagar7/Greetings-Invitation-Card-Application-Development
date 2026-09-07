import '../core/constants/occasions.dart';
import '../models/template_model.dart';

/// Template Service - mock data for Phase A
/// Will be replaced with Firebase Storage + Firestore in Phase B/C
/// PRD 06.4: 18 occasions, 200 templates target (ship 150-180 first)
class TemplateService {
  static List<TemplateModel> getDummyTemplates() {
    final List<TemplateModel> out = [];
    for (final occasion in Occasions.all) {
      for (int i = 1; i <= 3; i++) {
        out.add(TemplateModel(
          id: 'template_${occasion.id}_$i',
          occasionId: occasion.id,
          name: '${occasion.name} Template $i',
          category: occasion.group.name,
          thumbnailUrl: '',
          isPremium: i == 3, // 1 in 3 is premium
          culturalReviewPassed: !occasion.needsCulturalReview || i <= 2,
          canvasJson: {
            'background': occasion.accentColor.value,
            'texts': [
              {'type': 'heading', 'content': '${occasion.emoji} ${occasion.name}'},
              {'type': 'body', 'content': 'You are invited!'},
            ],
            'version': 1,
          },
          fonts: ['Fraunces', 'Inter'],
          colors: ['#3B2452', '#E8A33D', '#FBF8F3'],
        ));
      }
    }
    return out; // 18 * 3 = 54 dummy (will grow to 200)
  }

  static List<TemplateModel> byOccasion(String occasionId) =>
      getDummyTemplates().where((t) => t.occasionId == occasionId).toList();
}

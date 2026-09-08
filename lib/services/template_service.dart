import '../core/constants/occasions.dart';
import '../models/template_model.dart';

/// Template Service - mock data Phase A/C
/// Firebase Storage + Firestore in Phase B
/// PRD 06.4: 18 occasions, 200 templates (11 each + 2 extra)
class TemplateService {
  static List<TemplateModel> getDummyTemplates() {
    final List<TemplateModel> out = [];
    var globalIdx = 0;
    for (final occasion in Occasions.all) {
      // 11 per occasion = 198, add 2 extra for birthday/diwali to reach 200
      final count = (occasion.id == 'birthday' || occasion.id == 'diwali')
          ? 12
          : 11;
      for (int i = 1; i <= count; i++) {
        globalIdx++;
        final isPremium = globalIdx % 3 == 0; // ~33% premium
        final thumbSeed = 'template_${occasion.id}_$i';
        out.add(
          TemplateModel(
            id: thumbSeed,
            occasionId: occasion.id,
            name: '${occasion.name} Template $i',
            category: occasion.group.name,
            thumbnailUrl: 'https://picsum.photos/seed/$thumbSeed/540/756',
            isPremium: isPremium,
            culturalReviewPassed: !occasion.needsCulturalReview || i <= 8,
            canvasJson: {
              'background': occasion.accentColor.toARGB32(),
              'texts': [
                {
                  'type': 'heading',
                  'content': '${occasion.emoji} ${occasion.name}',
                },
                {'type': 'body', 'content': 'You are invited!'},
              ],
              'version': 1,
              'accentColor': occasion.accentColor.toARGB32(),
            },
            fonts: ['Fraunces', 'Inter', 'Noto Sans Devanagari'],
            colors: ['#3B2452', '#E8A33D', '#FBF8F3'],
          ),
        );
      }
    }
    return out; // 200
  }

  static List<TemplateModel> byOccasion(String occasionId) =>
      getDummyTemplates().where((t) => t.occasionId == occasionId).toList();
}

import '../../models/event_model.dart';
import '../../models/template_model.dart';

/// DataRepository — abstraction for Phase C.
///
/// Phase C (now): LocalDataRepository (Hive + assets).
/// Phase B (later): FirebaseDataRepository will implement
/// the same interface — zero UI changes needed.
///
/// See Development_standards.md §2, §5.3.
abstract class DataRepository {
  // Templates
  Future<List<TemplateModel>> getTemplates({
    String? occasionId,
    String? search,
  });
  Future<TemplateModel?> getTemplateById(String id);

  // Drafts / Events (offline-first, Hive)
  Future<void> saveDraft(EventModel event);
  Future<EventModel?> getDraft(String id);
  Future<List<EventModel>> getDrafts();
  Future<void> deleteDraft(String id);

  // Helpers
  Future<void> queueAction(String action, Map<String, dynamic> payload);
}

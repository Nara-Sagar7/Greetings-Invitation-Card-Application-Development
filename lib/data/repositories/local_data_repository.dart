import '../../models/event_model.dart';
import '../../models/template_model.dart';
import '../datasources/local_data_source.dart';
import 'data_repository.dart';

/// LocalDataRepository — Phase C implementation.
///
/// Uses Hive + assets only. No Firebase.
/// When Firebase is available, create
/// FirebaseDataRepository implementing
/// DataRepository — UI stays unchanged.
class LocalDataRepository implements DataRepository {
  final LocalDataSource _ds;
  LocalDataRepository(this._ds);

  @override
  Future<List<TemplateModel>> getTemplates({
    String? occasionId,
    String? search,
  }) async {
    var list = await _ds.loadTemplates(occasionId: occasionId);
    if (search != null && search.trim().isNotEmpty) {
      final q = search.toLowerCase();
      list = list
          .where(
            (t) =>
                t.name.toLowerCase().contains(q) ||
                t.occasionId.toLowerCase().contains(q),
          )
          .toList();
    }
    return list;
  }

  @override
  Future<TemplateModel?> getTemplateById(String id) => _ds.loadTemplateById(id);

  @override
  Future<void> saveDraft(EventModel event) => _ds.saveDraft(event);

  @override
  Future<EventModel?> getDraft(String id) => _ds.getDraft(id);

  @override
  Future<List<EventModel>> getDrafts() => _ds.getDrafts();

  @override
  Future<void> deleteDraft(String id) => _ds.deleteDraft(id);

  @override
  Future<void> queueAction(String action, Map<String, dynamic> payload) =>
      _ds.queueAction(action, payload);
}

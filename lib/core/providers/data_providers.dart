import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/data_repository.dart';
import '../../data/repositories/local_data_repository.dart';
import '../../models/event_model.dart';
import '../../models/template_model.dart';

/// Core data providers — Phase C (offline).
///
/// Single switch point for Phase B: replace
/// dataRepositoryProvider impl with
/// FirebaseDataRepository when Firebase is ready.

final localDataSourceProvider = Provider<LocalDataSource>(
  (ref) => LocalDataSource(),
);

final dataRepositoryProvider = Provider<DataRepository>(
  (ref) => LocalDataRepository(ref.read(localDataSourceProvider)),
);

// Templates

final templatesProvider = FutureProvider.family<List<TemplateModel>, String?>(
  (ref, occasionId) =>
      ref.read(dataRepositoryProvider).getTemplates(occasionId: occasionId),
);

final templateByIdProvider = FutureProvider.family<TemplateModel?, String>(
  (ref, id) => ref.read(dataRepositoryProvider).getTemplateById(id),
);

// Drafts / Events

final draftsProvider = FutureProvider<List<EventModel>>(
  (ref) => ref.read(dataRepositoryProvider).getDrafts(),
);

final draftByIdProvider = FutureProvider.family<EventModel?, String>(
  (ref, id) => ref.read(dataRepositoryProvider).getDraft(id),
);

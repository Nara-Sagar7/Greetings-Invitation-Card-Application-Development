import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/data_repository.dart';
import '../../data/repositories/firebase_data_repository.dart';
import '../../data/repositories/local_data_repository.dart';
import '../../models/event_model.dart';
import '../../models/template_model.dart';
import 'auth_provider.dart';

/// Core data providers — Phase C (offline) -> Phase B Firebase.
/// Single switch point: FirebaseDataRepository when logged in,
/// else LocalDataRepository. PRD local wins.

final localDataSourceProvider = Provider<LocalDataSource>(
  (ref) => LocalDataSource(),
);

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  final user = ref.watch(authStateProvider).value;
  final local = ref.read(localDataSourceProvider);
  if (user != null) {
    return FirebaseDataRepository(local);
  }
  return LocalDataRepository(local);
});

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

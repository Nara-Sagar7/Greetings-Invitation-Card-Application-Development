import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firebase_data_repository.dart';
import '../../services/connectivity_service.dart';
import '../../services/offline_queue_service.dart';
import 'data_providers.dart';

/// Provides ConnectivityService singleton P0-2 -> P0-3 sync
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final svc = ConnectivityService();
  ref.onDispose(svc.dispose);
  svc.init(
    onReconnect: () async {
      final pending = await OfflineQueueService.flushQueue();
      if (pending.isNotEmpty) {
        // pending flushed - now push drafts via Firebase with local wins
      }
      final repo = ref.read(dataRepositoryProvider);
      if (repo is FirebaseDataRepository) {
        await repo.syncPending();
      }
    },
  );
  return svc;
});

/// Stream of connectivity results for UI banners
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) {
  final svc = Connectivity();
  return svc.onConnectivityChanged;
});

/// Simple online check
final isOnlineProvider = Provider<bool>((ref) {
  final async = ref.watch(connectivityStreamProvider);
  return async.when(
    data: (results) => results.any((r) => r != ConnectivityResult.none),
    loading: () => true,
    error: (_, __) => true,
  );
});

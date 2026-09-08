import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'offline_queue_service.dart';

/// ConnectivityService - PRD 06.7 offline-first
/// Listens to connectivity changes and replays queued actions
/// when back online. Conflict rule: local wins.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  /// Start listening. Call from Provider or main.
  /// [onReconnect] is called when device regains connection.
  Future<void> init({required Future<void> Function() onReconnect}) async {
    // Initial check
    try {
      final results = await _connectivity.checkConnectivity();
      _isOnline = results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      _isOnline = true;
    }
    // Listen for changes
    _sub = _connectivity.onConnectivityChanged.listen((results) async {
      final nowOnline = results.any((r) => r != ConnectivityResult.none);
      final wasOffline = !_isOnline && nowOnline;
      _isOnline = nowOnline;
      if (wasOffline) {
        debugPrint('Connectivity: back online - flushing queue');
        try {
          await onReconnect();
        } catch (e) {
          debugPrint('Connectivity flush failed: $e');
        }
      }
    });
  }

  Future<List<Map>> flushQueue() => OfflineQueueService.flushQueue();

  void dispose() {
    _sub?.cancel();
  }
}

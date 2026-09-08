import 'package:hive_flutter/hive_flutter.dart';

import '../models/event_model.dart';

/// Offline Queue Service - PRD 06.7
/// Create/edit offline using cached templates. Actions auto-queue.
/// Status label: “Saved — will send when you’re back online”
/// Conflict rule: Local timestamp wins. Server silently overwritten.
class OfflineQueueService {
  static const _boxName = 'offline_queue';
  static const _draftsBox = 'drafts';

  static Future<Box> _queueBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return Hive.openBox(_boxName);
  }

  static Future<Box<EventModel>> _drafts() async {
    if (Hive.isBoxOpen(_draftsBox)) {
      return Hive.box<EventModel>(_draftsBox);
    }
    return Hive.openBox<EventModel>(_draftsBox);
  }

  // Save draft locally - typed P0-1
  static Future<void> saveDraft(String id, Map<String, dynamic> data) async {
    final box = await _drafts();
    final event = EventModel.fromJson({'id': id, ...data});
    await box.put(id, event);
  }

  // Queue action for when back online
  static Future<void> queueAction(
    String action,
    Map<String, dynamic> payload,
  ) async {
    final box = await _queueBox();
    await box.add({
      'action': action,
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Flush queue when connectivity returns
  static Future<List<Map>> flushQueue() async {
    final box = await _queueBox();
    final items = box.values.map((e) => Map.from(e as Map)).toList();
    await box.clear();
    return items.cast<Map>();
  }

  static Future<List<EventModel>> getPendingDrafts() async {
    final box = await _drafts();
    return box.values.toList();
  }

  static Future<EventModel?> getDraft(String id) async {
    final box = await _drafts();
    return box.get(id);
  }
}

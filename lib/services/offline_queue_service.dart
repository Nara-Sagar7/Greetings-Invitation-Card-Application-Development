import 'package:hive_flutter/hive_flutter.dart';

/// Offline Queue Service - PRD 06.7
/// Create/edit offline using cached templates. Actions auto-queue.
/// Status label: “Saved — will send when you’re back online”
/// Conflict rule: Local timestamp wins. Server silently overwritten.
class OfflineQueueService {
  static const _boxName = 'offline_queue';
  static const _draftsBox = 'drafts';

  static Future<Box> _queueBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  static Future<Box> _drafts() async {
    if (!Hive.isBoxOpen(_draftsBox)) {
      return await Hive.openBox(_draftsBox);
    }
    return Hive.box(_draftsBox);
  }

  // Save draft locally
  static Future<void> saveDraft(String id, Map<String, dynamic> data) async {
    final box = await _drafts();
    await box.put(id, {
      ...data,
      'localTimestamp': DateTime.now().toIso8601String(),
      'syncStatus': 'pending',
    });
  }

  // Queue action for when back online
  static Future<void> queueAction(String action, Map<String, dynamic> payload) async {
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

  static Future<List<Map>> getPendingDrafts() async {
    final box = await _drafts();
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/occasions.dart';
import '../../models/event_model.dart';
import '../../models/template_model.dart';
import '../../services/template_service.dart';

/// LocalDataSource — Hive + assets for Phase C.
///
/// No Firebase required. Will be wrapped by
/// LocalDataRepository.
class LocalDataSource {
  static const _draftsBox = 'drafts';
  static const _queueBox = 'offline_queue';

  Future<Box> _draftsBoxOpen() async {
    if (!Hive.isBoxOpen(_draftsBox)) {
      return Hive.openBox(_draftsBox);
    }
    return Hive.box(_draftsBox);
  }

  Future<Box> _queueBoxOpen() async {
    if (!Hive.isBoxOpen(_queueBox)) {
      return Hive.openBox(_queueBox);
    }
    return Hive.box(_queueBox);
  }

  // Templates: try bundled JSON, fallback to
  // TemplateService dummy (54 templates).
  Future<List<TemplateModel>> loadTemplates({String? occasionId}) async {
    final List<TemplateModel> out = [];
    // Try to load sample_diwali.json as proof of
    // asset pipeline; ignore failures gracefully.
    try {
      final raw = await rootBundle.loadString(
        'assets/templates/sample_diwali.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      out.add(TemplateModel.fromJson(json));
    } catch (_) {
      // No asset or malformed — fallback below.
    }

    final dummy = TemplateService.getDummyTemplates();
    for (final t in dummy) {
      if (out.any((e) => e.id == t.id)) continue;
      out.add(t);
    }

    if (occasionId == null || occasionId.isEmpty) return out;
    return out.where((t) => t.occasionId == occasionId).toList();
  }

  Future<TemplateModel?> loadTemplateById(String id) async {
    final all = await loadTemplates();
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Occasion> get occasions => Occasions.all;

  // Drafts — stored as EventModel JSON maps
  Future<void> saveDraft(EventModel event) async {
    final box = await _draftsBoxOpen();
    await box.put(event.id, {
      ...event.toJson(),
      'localTimestamp': DateTime.now().toIso8601String(),
      'syncStatus': 'pending',
    });
  }

  Future<EventModel?> getDraft(String id) async {
    final box = await _draftsBoxOpen();
    final raw = box.get(id);
    if (raw == null) return null;
    return _eventFromMap(Map<String, dynamic>.from(raw as Map));
  }

  Future<List<EventModel>> getDrafts() async {
    final box = await _draftsBoxOpen();
    return box.values
        .map((e) => _eventFromMap(Map<String, dynamic>.from(e as Map)))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> deleteDraft(String id) async {
    final box = await _draftsBoxOpen();
    await box.delete(id);
  }

  Future<void> queueAction(String action, Map<String, dynamic> payload) async {
    final box = await _queueBoxOpen();
    await box.add({
      'action': action,
      'payload': payload,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  EventModel _eventFromMap(Map<String, dynamic> j) {
    return EventModel(
      id: j['id'] as String,
      hostId: j['hostId'] as String? ?? 'local_user',
      title: j['title'] as String? ?? '',
      dateTime:
          DateTime.tryParse(j['dateTime'] as String? ?? '') ?? DateTime.now(),
      timezone: j['timezone'] as String? ?? 'Asia/Kolkata',
      location: j['location'] as String? ?? '',
      description: j['description'] as String? ?? '',
      templateId: j['templateId'] as String? ?? '',
      canvasJson: Map<String, dynamic>.from(j['canvasJson'] as Map? ?? {}),
      status: j['status'] as String? ?? 'draft',
      guestEmails: List<String>.from(j['guestEmails'] ?? []),
      createdAt:
          DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(j['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

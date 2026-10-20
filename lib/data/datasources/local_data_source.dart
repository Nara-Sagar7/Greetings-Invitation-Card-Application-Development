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

  Future<Box<EventModel>> _draftsBoxOpen() async {
    if (Hive.isBoxOpen(_draftsBox)) {
      return Hive.box<EventModel>(_draftsBox);
    }
    return Hive.openBox<EventModel>(_draftsBox);
  }

  Future<Box> _queueBoxOpen() async {
    if (Hive.isBoxOpen(_queueBox)) {
      return Hive.box(_queueBox);
    }
    return Hive.openBox(_queueBox);
  }

  // Templates: try bundled catalog.json (Template
  // Factory output), fallback to TemplateService
  // dummy. Entries with backgroundImagePath render
  // real art; CanvasRenderer supports it.
  Future<List<TemplateModel>> loadTemplates({String? occasionId}) async {
    final List<TemplateModel> out = [];
    // Preferred: catalog.json produced by
    // tools/template_factory/generate.js.
    try {
      final raw = await rootBundle.loadString('assets/templates/catalog.json');
      final json = jsonDecode(raw) as List<dynamic>;
      out.addAll(
        json.whereType<Map<String, dynamic>>().map(TemplateModel.fromJson),
      );
    } catch (_) {
      // No catalog or malformed — fallback below.
    }
    // Legacy single-sample asset kept until fully
    // replaced by factory output.
    try {
      final raw = await rootBundle.loadString(
        'assets/templates/sample_diwali.json',
      );
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (!out.any((e) => e.id == json['id'])) {
        out.add(TemplateModel.fromJson(json));
      }
    } catch (_) {
      // No asset or malformed — ignore.
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

  // Drafts — typed Hive box P0-1
  Future<void> saveDraft(EventModel event) async {
    final box = await _draftsBoxOpen();
    await box.put(event.id, event);
  }

  Future<EventModel?> getDraft(String id) async {
    final box = await _draftsBoxOpen();
    return box.get(id);
  }

  Future<List<EventModel>> getDrafts() async {
    final box = await _draftsBoxOpen();
    final list = box.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../models/event_model.dart';
import '../../models/template_model.dart';
import '../datasources/local_data_source.dart';
import 'data_repository.dart';

/// FirebaseDataRepository - P0-3 Phase B
/// Implements DataRepository with Firestore + Hive offline-first.
/// Local wins: Hive write first, then Firestore overwrite server.
/// Schema: templates (public), users/{uid}/drafts, users/{uid}/events
class FirebaseDataRepository implements DataRepository {
  final LocalDataSource _local;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseDataRepository(
    this._local, {
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? 'local_user';
  bool get _isLoggedIn => _auth.currentUser != null;

  CollectionReference<Map<String, dynamic>> get _templatesCol =>
      _firestore.collection('templates');

  CollectionReference<Map<String, dynamic>> get _draftsCol =>
      _firestore.collection('users').doc(_uid).collection('drafts');

  // ignore: unused_element
  CollectionReference<Map<String, dynamic>> get _eventsCol =>
      _firestore.collection('users').doc(_uid).collection('events');

  @override
  Future<List<TemplateModel>> getTemplates({
    String? occasionId,
    String? search,
  }) async {
    // Try Firestore first, fallback to local
    try {
      Query<Map<String, dynamic>> q = _templatesCol;
      if (occasionId != null && occasionId.isNotEmpty) {
        q = q.where('occasionId', isEqualTo: occasionId);
      }
      final snap = await q.get(const GetOptions(source: Source.serverAndCache));
      var list = snap.docs.map((d) {
        final data = d.data();
        data['id'] = d.id;
        return TemplateModel.fromJson(data);
      }).toList();
      // Client search filter
      if (search != null && search.trim().isNotEmpty) {
        final s = search.toLowerCase();
        list = list
            .where(
              (t) =>
                  t.name.toLowerCase().contains(s) ||
                  t.occasionId.toLowerCase().contains(s),
            )
            .toList();
      }
      if (list.isNotEmpty) return list;
    } catch (e) {
      debugPrint('Firebase getTemplates fallback: $e');
    }
    // Local fallback
    return _local.loadTemplates(occasionId: occasionId).then((list) {
      if (search == null || search.trim().isEmpty) return list;
      final s = search.toLowerCase();
      return list
          .where(
            (t) =>
                t.name.toLowerCase().contains(s) ||
                t.occasionId.toLowerCase().contains(s),
          )
          .toList();
    });
  }

  @override
  Future<TemplateModel?> getTemplateById(String id) async {
    try {
      final doc = await _templatesCol.doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return TemplateModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('Firebase getTemplateById fallback: $e');
    }
    return _local.loadTemplateById(id);
  }

  @override
  Future<void> saveDraft(EventModel event) async {
    // Local first - always
    await _local.saveDraft(event);
    if (!_isLoggedIn) return;
    // Firestore overwrite - local wins
    try {
      await _draftsCol.doc(event.id).set(event.toJson());
    } catch (e) {
      debugPrint('Firebase saveDraft queued offline: $e');
      await _local.queueAction('saveDraft', event.toJson());
    }
  }

  @override
  Future<EventModel?> getDraft(String id) async {
    // Local first
    final local = await _local.getDraft(id);
    if (local != null) return local;
    if (!_isLoggedIn) return null;
    try {
      final doc = await _draftsCol.doc(id).get();
      if (doc.exists && doc.data() != null) {
        return EventModel.fromJson(doc.data()!);
      }
    } catch (e) {
      debugPrint('Firebase getDraft error: $e');
    }
    return null;
  }

  @override
  Future<List<EventModel>> getDrafts() async {
    final local = await _local.getDrafts();
    if (!_isLoggedIn) return local;
    try {
      final snap = await _draftsCol.get();
      final remote = snap.docs
          .map((d) => EventModel.fromJson(d.data()))
          .toList();
      // Merge local wins: local overwrites remote if same id
      final merged = <String, EventModel>{
        for (final r in remote) r.id: r,
        for (final l in local) l.id: l,
      };
      final list = merged.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list;
    } catch (e) {
      debugPrint('Firebase getDrafts fallback: $e');
      return local;
    }
  }

  @override
  Future<void> deleteDraft(String id) async {
    await _local.deleteDraft(id);
    if (!_isLoggedIn) return;
    try {
      await _draftsCol.doc(id).delete();
    } catch (e) {
      debugPrint('Firebase deleteDraft queued: $e');
      await _local.queueAction('deleteDraft', {'id': id});
    }
  }

  @override
  Future<void> queueAction(String action, Map<String, dynamic> payload) async {
    await _local.queueAction(action, payload);
    if (!_isLoggedIn) return;
    try {
      await _firestore.collection('users').doc(_uid).collection('queue').add({
        'action': action,
        'payload': payload,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Keep locally queued
    }
  }

  /// Replay pending queue when back online - local wins
  Future<void> syncPending() async {
    if (!_isLoggedIn) return;
    // For now just push drafts again
    final drafts = await _local.getDrafts();
    for (final d in drafts) {
      try {
        await _draftsCol.doc(d.id).set(d.toJson());
      } catch (e) {
        debugPrint('syncPending draft ${d.id} failed: $e');
      }
    }
  }
}

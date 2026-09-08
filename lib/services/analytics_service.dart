import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// AnalyticsService - PRD 11
/// 7 KPIs: activation 24h, 0 preview≠sent, RSVP rate, D7/D30, conversion, 4.5+, deflection
/// Logs to debugPrint + Firestore analytics collection for companion spec
class AnalyticsService {
  static Future<void> log(String event, [Map<String, dynamic>? params]) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anon';
    final data = {
      'event': event,
      'uid': uid,
      'params': params ?? {},
      'timestamp': FieldValue.serverTimestamp(),
      'platform': defaultTargetPlatform.name,
    };
    debugPrint('Analytics: $event $params');
    try {
      await FirebaseFirestore.instance.collection('analytics').add(data);
    } catch (e) {
      debugPrint('Analytics Firestore skip: $e');
    }
  }

  static Future<void> activation(String templateId) =>
      log('activation_24h', {'templateId': templateId});
  static Future<void> previewVerified(String templateId) => log(
    'reliability_preview_verified',
    {'templateId': templateId, 'pixelRatio': 2.0},
  );
  static Future<void> rsvpResponse(String eventId, String rsvp) =>
      log('rsvp_response', {'eventId': eventId, 'rsvp': rsvp});
  static Future<void> retentionD7() => log('retention_d7');
  static Future<void> retentionD30() => log('retention_d30');
  static Future<void> conversionPremium(String product) =>
      log('conversion_premium', {'product': product});
  static Future<void> ratingPrompt(double rating) =>
      log('app_store_rating', {'rating': rating});
  static Future<void> chatbotDeflected(String question) =>
      log('chatbot_deflected', {'question': question});
  static Future<void> chatbotEscalated(String question) =>
      log('chatbot_escalated', {'question': question});
}

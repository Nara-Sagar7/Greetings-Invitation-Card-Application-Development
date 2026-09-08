import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// TrackingService - PRD 6.3 opened pixel
/// Records when guest opens card via link
class TrackingService {
  static Future<void> trackOpened({
    required String eventId,
    required String guestEmail,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('opens')
          .doc(guestEmail.toLowerCase())
          .set({
            'email': guestEmail,
            'openedAt': FieldValue.serverTimestamp(),
            'userAgent': 'mobile',
          }, SetOptions(merge: true));
      await FirebaseFirestore.instance.collection('events').doc(eventId).update(
        {
          'lastOpenedAt': FieldValue.serverTimestamp(),
          'openedCount': FieldValue.increment(1),
        },
      );
    } catch (e) {
      debugPrint('Tracking opened failed: $e');
    }
  }

  static Future<void> trackRsvp({
    required String eventId,
    required String email,
    required String rsvp,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('rsvps')
          .doc(email.toLowerCase())
          .set({
            'email': email,
            'rsvp': rsvp,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Tracking RSVP failed: $e');
    }
  }
}

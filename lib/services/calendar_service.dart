import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/event_model.dart';

/// CalendarService - PRD 6.6
/// Host: Google OAuth (placeholder) - guest: .ics for all
class CalendarService {
  /// Generate .ics file for guest - works with Google/Outlook/Apple
  static Future<File> generateIcs(EventModel event) async {
    final dtStart = _formatIcs(event.dateTime);
    final dtEnd = _formatIcs(event.dateTime.add(const Duration(hours: 2)));
    final dtStamp = _formatIcs(DateTime.now().toUtc());
    final uid = '${event.id}@greetings.app';
    final ics =
        '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Greetings//Invitation//EN
CALSCALE:GREGORIAN
METHOD:PUBLISH
BEGIN:VEVENT
UID:$uid
DTSTAMP:$dtStamp
DTSTART:$dtStart
DTEND:$dtEnd
SUMMARY:${_esc(event.title)}
DESCRIPTION:${_esc(event.description)}
LOCATION:${_esc(event.location)}
STATUS:CONFIRMED
END:VEVENT
END:VCALENDAR
''';
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invite_${event.id}.ics');
    await file.writeAsString(ics);
    return file;
  }

  static String _formatIcs(DateTime dt) {
    final utc = dt.toUtc();
    final f = DateFormat("yyyyMMdd'T'HHmmss'Z'");
    return f.format(utc);
  }

  static String _esc(String s) =>
      s.replaceAll('\n', '\\n').replaceAll(',', '\\,').replaceAll(';', '\\;');

  static Future<void> shareIcs(EventModel event) async {
    try {
      final file = await generateIcs(event);
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Add to Calendar: ${event.title}');
    } catch (e) {
      debugPrint('Calendar share failed: $e');
    }
  }

  /// Host Google Calendar OAuth placeholder PRD 6.6
  /// Real impl: google_sign_in with https://www.googleapis.com/auth/calendar
  /// then googleapis calendar.events.insert
  static Future<bool> syncToGoogleCalendar(EventModel event) async {
    debugPrint(
      'CalendarService: Google OAuth sync placeholder for ${event.id}',
    );
    // TODO: Implement with googleapis + google_sign_in
    // For now generate .ics as fallback
    await shareIcs(event);
    return true;
  }
}

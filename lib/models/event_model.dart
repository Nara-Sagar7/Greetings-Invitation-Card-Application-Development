/// Event Model - PRD 06.2
/// Timezone-aware event with guest list & RSVP
class EventModel {
  final String id;
  final String hostId;
  final String title;
  final DateTime dateTime;
  final String timezone;
  final String location;
  final String description;
  final String templateId;
  final Map<String, dynamic> canvasJson;
  final String status; // draft / sent
  final List<String> guestEmails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.hostId,
    required this.title,
    required this.dateTime,
    required this.timezone,
    required this.location,
    required this.description,
    required this.templateId,
    required this.canvasJson,
    required this.status,
    required this.guestEmails,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'hostId': hostId,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'timezone': timezone,
        'location': location,
        'description': description,
        'templateId': templateId,
        'canvasJson': canvasJson,
        'status': status,
        'guestEmails': guestEmails,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class GuestModel {
  final String email;
  final String name;
  final String rsvp; // yes / no / maybe
  final String? customAnswer;
  final bool reminderSent;

  const GuestModel({
    required this.email,
    required this.name,
    this.rsvp = 'maybe',
    this.customAnswer,
    this.reminderSent = false,
  });
}

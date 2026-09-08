import 'package:hive/hive.dart';

part 'event_model.g.dart';

/// Event Model - PRD 06.2
/// Timezone-aware event with guest list & RSVP
@HiveType(typeId: 1)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String hostId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final String timezone;
  @HiveField(5)
  final String location;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final String templateId;
  @HiveField(8)
  final Map<String, dynamic> canvasJson;
  @HiveField(9)
  final String status; // draft / sent
  @HiveField(10)
  final List<String> guestEmails;
  @HiveField(11)
  final DateTime createdAt;
  @HiveField(12)
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

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id'] as String,
    hostId: json['hostId'] as String,
    title: json['title'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    timezone: json['timezone'] as String? ?? 'Asia/Kolkata',
    location: json['location'] as String? ?? '',
    description: json['description'] as String? ?? '',
    templateId: json['templateId'] as String,
    canvasJson: Map<String, dynamic>.from(json['canvasJson'] as Map? ?? {}),
    status: json['status'] as String? ?? 'draft',
    guestEmails: List<String>.from(json['guestEmails'] ?? []),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

@HiveType(typeId: 2)
class GuestModel {
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String rsvp; // yes / no / maybe
  @HiveField(3)
  final String? customAnswer;
  @HiveField(4)
  final bool reminderSent;

  const GuestModel({
    required this.email,
    required this.name,
    this.rsvp = 'maybe',
    this.customAnswer,
    this.reminderSent = false,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'rsvp': rsvp,
    'customAnswer': customAnswer,
    'reminderSent': reminderSent,
  };

  factory GuestModel.fromJson(Map<String, dynamic> json) => GuestModel(
    email: json['email'] as String,
    name: json['name'] as String,
    rsvp: json['rsvp'] as String? ?? 'maybe',
    customAnswer: json['customAnswer'] as String?,
    reminderSent: json['reminderSent'] as bool? ?? false,
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventModelAdapter extends TypeAdapter<EventModel> {
  @override
  final int typeId = 1;

  @override
  EventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventModel(
      id: fields[0] as String,
      hostId: fields[1] as String,
      title: fields[2] as String,
      dateTime: fields[3] as DateTime,
      timezone: fields[4] as String,
      location: fields[5] as String,
      description: fields[6] as String,
      templateId: fields[7] as String,
      canvasJson: (fields[8] as Map).cast<String, dynamic>(),
      status: fields[9] as String,
      guestEmails: (fields[10] as List).cast<String>(),
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EventModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hostId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.timezone)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.templateId)
      ..writeByte(8)
      ..write(obj.canvasJson)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.guestEmails)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GuestModelAdapter extends TypeAdapter<GuestModel> {
  @override
  final int typeId = 2;

  @override
  GuestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestModel(
      email: fields[0] as String,
      name: fields[1] as String,
      rsvp: fields[2] as String,
      customAnswer: fields[3] as String?,
      reminderSent: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GuestModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.rsvp)
      ..writeByte(3)
      ..write(obj.customAnswer)
      ..writeByte(4)
      ..write(obj.reminderSent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

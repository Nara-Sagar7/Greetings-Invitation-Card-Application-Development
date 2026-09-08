// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TemplateModelAdapter extends TypeAdapter<TemplateModel> {
  @override
  final int typeId = 0;

  @override
  TemplateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TemplateModel(
      id: fields[0] as String,
      occasionId: fields[1] as String,
      name: fields[2] as String,
      category: fields[3] as String,
      thumbnailUrl: fields[4] as String,
      isPremium: fields[5] as bool,
      culturalReviewPassed: fields[6] as bool,
      canvasJson: (fields[7] as Map).cast<String, dynamic>(),
      fonts: (fields[8] as List).cast<String>(),
      colors: (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TemplateModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.occasionId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.thumbnailUrl)
      ..writeByte(5)
      ..write(obj.isPremium)
      ..writeByte(6)
      ..write(obj.culturalReviewPassed)
      ..writeByte(7)
      ..write(obj.canvasJson)
      ..writeByte(8)
      ..write(obj.fonts)
      ..writeByte(9)
      ..write(obj.colors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

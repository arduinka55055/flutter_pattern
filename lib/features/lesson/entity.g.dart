// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 3;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      id: fields[0] as String,
      name: fields[1] as String,
      teacher: fields[2] as String,
      room: fields[3] as String,
      notes: fields[4] as String,
      type: fields[5] as LessonType,
      color: fields[6] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.teacher)
      ..writeByte(3)
      ..write(obj.room)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LessonTypeAdapter extends TypeAdapter<LessonType> {
  @override
  final int typeId = 2;

  @override
  LessonType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LessonType.lecture;
      case 1:
        return LessonType.practice;
      default:
        return LessonType.lecture;
    }
  }

  @override
  void write(BinaryWriter writer, LessonType obj) {
    switch (obj) {
      case LessonType.lecture:
        writer.writeByte(0);
        break;
      case LessonType.practice:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

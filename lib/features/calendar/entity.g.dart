// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarAdapter extends TypeAdapter<Calendar> {
  @override
  final int typeId = 4;

  @override
  Calendar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calendar(
      id: fields[0] as String,
      name: fields[1] as String,
      weekCount: fields[2] as int,
      timetableId: fields[3] as String,
      schedule: (fields[4] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as int,
          (v as Map).map((dynamic k, dynamic v) =>
              MapEntry(k as int, (v as List).cast<String?>())))),
    );
  }

  @override
  void write(BinaryWriter writer, Calendar obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.weekCount)
      ..writeByte(3)
      ..write(obj.timetableId)
      ..writeByte(4)
      ..write(obj.schedule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 5;

  @override
  Day read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Day.monday;
      case 1:
        return Day.tuesday;
      case 2:
        return Day.wednesday;
      case 3:
        return Day.thursday;
      case 4:
        return Day.friday;
      case 5:
        return Day.saturday;
      case 6:
        return Day.sunday;
      default:
        return Day.monday;
    }
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    switch (obj) {
      case Day.monday:
        writer.writeByte(0);
        break;
      case Day.tuesday:
        writer.writeByte(1);
        break;
      case Day.wednesday:
        writer.writeByte(2);
        break;
      case Day.thursday:
        writer.writeByte(3);
        break;
      case Day.friday:
        writer.writeByte(4);
        break;
      case Day.saturday:
        writer.writeByte(5);
        break;
      case Day.sunday:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

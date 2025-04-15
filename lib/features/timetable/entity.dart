import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'entity.g.dart';

@HiveType(typeId: 0)
class Timetable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<TimeRange> timeSlots;

  Timetable({
    required this.id,
    required this.name,
    required this.timeSlots,
  });
}

@HiveType(typeId: 1)
class TimeRange {
  @HiveField(0)
  final TimeOfDay start;
  @HiveField(1)
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
}

extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, hour, minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }
}
import 'package:flutter/material.dart';

class Timetable {
  final String id;
  final String name;
  final List<TimeRange> timeSlots;

  Timetable({
    required this.id,
    required this.name,
    required this.timeSlots,
  });
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
}

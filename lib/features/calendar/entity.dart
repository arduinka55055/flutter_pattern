import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'presenter.dart';

part 'entity.g.dart';

@HiveType(typeId: 4)
class Calendar {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int weekCount;

  @HiveField(3)
  final String timetableId;

  @HiveField(4)
  final Map<int, Map<int, List<String?>>> schedule;

  Calendar({
    required this.id,
    required this.name,
    required this.weekCount,
    required this.timetableId,
    required this.schedule,
  });

  // Helper method to convert Day enum to index
  Map<int, Map<Day, List<String?>>> get scheduleWithDays {
    return schedule.map((week, days) => MapEntry(
          week,
          days.map((dayIndex, lessons) => MapEntry(
                Day.values[dayIndex],
                lessons,
              )),
        ));
  }
}

@HiveType(typeId: 5)
enum Day {
  @HiveField(0)
  monday,
  @HiveField(1)
  tuesday,
  @HiveField(2)
  wednesday,
  @HiveField(3)
  thursday,
  @HiveField(4)
  friday,
  @HiveField(5)
  saturday,
  @HiveField(6)
  sunday,
}

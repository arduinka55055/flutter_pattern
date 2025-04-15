import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'entity.g.dart';

@HiveType(typeId: 2)
enum LessonType {
  @HiveField(0)
  lecture,
  @HiveField(1)
  practice
}

@HiveType(typeId: 3)
class Lesson {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String teacher;
  @HiveField(3)
  final String room;
  @HiveField(4)
  final String notes;
  @HiveField(5)
  final LessonType type;
  @HiveField(6)
  final Color color;

  Lesson({
    required this.id,
    required this.name,
    required this.teacher,
    required this.room,
    required this.notes,
    required this.type,
    required this.color,
  });
}

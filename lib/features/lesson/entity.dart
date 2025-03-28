import 'package:flutter/material.dart';

enum LessonType { lecture, practice }

class Lesson {
  final String id;
  final String name;
  final String teacher;
  final String room;
  final String notes;
  final LessonType type;
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

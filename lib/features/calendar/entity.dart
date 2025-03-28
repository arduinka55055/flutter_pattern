import 'package:flutter/material.dart';

import 'presenter.dart';

class Calendar {
  final String id;
  final String name;
  final int weekCount;
  final Map<int, Map<Day, List<String?>>> schedule;

  Calendar({
    required this.id,
    required this.name,
    required this.weekCount,
    required this.schedule,
  });

  get timetableId => null;
}

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }


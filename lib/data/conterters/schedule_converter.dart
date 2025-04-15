// lib/features/calendar/viper/entity/schedule_converter.dart
import 'package:flutter_application_1/features/calendar/entity.dart';

class ScheduleConverter {
  static Map<int, Map<int, List<String?>>> toHiveFormat(
      Map<int, Map<Day, List<String?>>> schedule) {
    return schedule.map((week, days) => MapEntry(
          week,
          days.map((day, lessons) => MapEntry(day.index, lessons)),
        ));
  }

  static Map<int, Map<Day, List<String?>>> fromHiveFormat(
      Map<int, Map<int, List<String?>>> hiveSchedule) {
    return hiveSchedule.map((week, days) => MapEntry(
          week,
          days.map(
              (dayIndex, lessons) => MapEntry(Day.values[dayIndex], lessons)),
        ));
  }
}

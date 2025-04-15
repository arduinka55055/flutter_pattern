// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/listView.dart';
import 'package:flutter_application_1/features/export/view.dart';
import 'package:flutter_application_1/features/timetable/createView.dart';
import 'package:flutter_application_1/features/timetable/listView.dart';

import 'Common/Navigation.dart';
import 'features/calendar/createView.dart';
import 'features/lesson/createView.dart';
import 'features/lesson/listView.dart';

class AppRouter {
  static const String home = '/';
  static const String timetableList = '/timetables';
  static const String createTimetable = '/timetables/create';
  static const String editTimetable = '/timetables/edit';
  static const String lessonList = '/lessons';
  static const String createLesson = '/lessons/create';
  static const String editLesson = '/lessons/edit';
  static const String calendarList = '/calendars';
  static const String createCalendar = '/calendars/create';
  static const String editCalendar = '/calendars/edit';
  static const String exportCalendar = '/export';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainWrapper());
      case timetableList:
        return MaterialPageRoute(
            builder: (_) => const MainWrapper(child: TimetableListScreen()));
      case createTimetable:
        return MaterialPageRoute(builder: (_) => const CreateTimetableScreen());
      case editTimetable:
        return MaterialPageRoute(
            builder: (_) => const CreateTimetableScreen(editMode: true),
            settings: settings);
      case lessonList:
        return MaterialPageRoute(
            builder: (_) => const MainWrapper(child: LessonListScreen()));
      case createLesson:
        return MaterialPageRoute(builder: (_) => const CreateLessonScreen());
      case editLesson:
        return MaterialPageRoute(
            builder: (_) => const CreateLessonScreen(editMode: true),
            settings: settings);
      case calendarList:
        return MaterialPageRoute(
            builder: (_) => const MainWrapper(child: CalendarListScreen()));
      case createCalendar:
        return MaterialPageRoute(builder: (_) => const CreateCalendarScreen());
      case editCalendar:
        return MaterialPageRoute(
            builder: (_) => const CreateCalendarScreen(editMode: true),
            settings: settings);
      case exportCalendar:
        return MaterialPageRoute(
            builder: (_) => const ExportScreen(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/listView.dart';
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
  static const String lessonList = '/lessons';
  static const String createLesson = '/lessons/create';
  static const String calendarList = '/calendars';
  static const String createCalendar = '/calendars/create';
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
      case lessonList:
        return MaterialPageRoute(
            builder: (_) => const MainWrapper(child: LessonListScreen()));
      case createLesson:
        return MaterialPageRoute(builder: (_) => const CreateLessonScreen());
      case calendarList:
        return MaterialPageRoute(
            builder: (_) => const MainWrapper(child: CalendarListScreen()));
      case createCalendar:
        return MaterialPageRoute(builder: (_) => const CreateCalendarScreen());
      //case exportCalendar:
      //  return MaterialPageRoute(builder: (_) => MainWrapper(child: _getScreen(settings.name!)));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static Widget _getScreen(String route) {
    switch (route) {
      case timetableList:
        return const TimetableListScreen();
      case lessonList:
        return const LessonListScreen();
      case calendarList:
        return const CalendarListScreen();
      //case export: return const ExportScreen();
      default:
        return const SizedBox.shrink();
    }
  }
}

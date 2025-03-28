import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/abstract/calendar.dart';
import 'package:flutter_application_1/data/abstract/lesson.dart';
import 'package:flutter_application_1/data/sqlite/calendar.dart';
import 'package:flutter_application_1/data/sqlite/lesson.dart';
import 'package:flutter_application_1/data/sqlite/timetable.dart';
import 'package:flutter_application_1/features/calendar/interactor.dart';
import 'package:flutter_application_1/features/lesson/presenter.dart';
import 'package:flutter_application_1/features/timetable/interactor.dart';
import 'package:flutter_application_1/features/timetable/presenter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/data/abstract/timetable.dart';
import 'package:flutter_application_1/features/calendar/presenter.dart';
import 'package:flutter_application_1/features/lesson/interactor.dart';

import 'router.dart';

final getIt = GetIt.instance;

void main() {
  setupDependencies();
  runApp(const MyApp());
}

void setupDependencies() {
  // Register Repositories
  getIt.registerLazySingleton<TimetableRepository>(
      () => MockTimetableRepository());
  getIt.registerLazySingleton<LessonRepository>(() => MockLessonRepository());
  getIt.registerLazySingleton<CalendarRepository>(
      () => MockCalendarRepository());

  // Register Interactors
  getIt.registerLazySingleton(
      () => TimetableInteractor(getIt<TimetableRepository>()));
  getIt
      .registerLazySingleton(() => LessonInteractor(getIt<LessonRepository>()));
  getIt.registerLazySingleton(
      () => CalendarInteractor(getIt<CalendarRepository>()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => TimetablePresenter(getIt<TimetableInteractor>())),
        ChangeNotifierProvider(
            create: (_) => LessonPresenter(getIt<LessonInteractor>())),
        ChangeNotifierProvider(
          create: (_) => CalendarPresenter(
            getIt<CalendarInteractor>(),
            getIt<LessonInteractor>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'University Calendar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRouter.timetableList,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

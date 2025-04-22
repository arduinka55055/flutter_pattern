import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/abstract/calendar.dart';
import 'package:flutter_application_1/data/abstract/lesson.dart';
import 'package:flutter_application_1/data/sqlite/calendar.dart';
import 'package:flutter_application_1/data/sqlite/lesson.dart';
import 'package:flutter_application_1/data/sqlite/timetable.dart';
import 'package:flutter_application_1/features/calendar/entity.dart';
import 'package:flutter_application_1/features/calendar/interactor.dart';
import 'package:flutter_application_1/features/lesson/entity.dart';
import 'package:flutter_application_1/features/lesson/presenter.dart';
import 'package:flutter_application_1/features/timetable/interactor.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';
import 'package:flutter_application_1/features/timetable/presenter.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/data/abstract/timetable.dart';
import 'package:flutter_application_1/features/calendar/presenter.dart';
import 'package:flutter_application_1/features/lesson/interactor.dart';

import 'router.dart';

final getIt = GetIt.instance;

void main() async {
  await setupHive();
  setupDependencies();
  runApp(const MyApp());
}

Future<void> setupHive() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this
  await Hive.initFlutter();

  // Register all adapters you've generated
  Hive.registerAdapter(CalendarAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(TimetableAdapter());
  Hive.registerAdapter(TimeRangeAdapter());
  Hive.registerAdapter(LessonAdapter());
  Hive.registerAdapter(LessonTypeAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  // Open boxes (add these)
  await Hive.openBox<Calendar>('calendars');
  await Hive.openBox<Timetable>('timetables');
  await Hive.openBox<Lesson>('lessons');
}

void setupDependencies() {
  // Register Repositories
  getIt.registerLazySingleton<TimetableRepository>(
      () => TimetableRepositoryImpl());
  getIt.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl());
  getIt.registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl());

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
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

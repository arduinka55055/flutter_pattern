import 'package:flutter_application_1/features/timetable/entity.dart';

abstract class TimetableRepository {
  Future<List<Timetable>> getAll();
  Future<void> save(Timetable timetable);
  Future<void> delete(String id);
  Future<Timetable?> getById(String id);
}

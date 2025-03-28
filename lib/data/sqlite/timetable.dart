import 'package:flutter_application_1/features/timetable/entity.dart';
import '../abstract/timetable.dart';

class MockTimetableRepository implements TimetableRepository {
  final List<Timetable> _timetables = [];

  @override
  Future<List<Timetable>> getAll() async => _timetables;

  @override
  Future<void> save(Timetable timetable) async {
    _timetables.removeWhere((t) => t.id == timetable.id);
    _timetables.add(timetable);
  }

  @override
  Future<void> delete(String id) async {
    _timetables.removeWhere((t) => t.id == id);
  }
}

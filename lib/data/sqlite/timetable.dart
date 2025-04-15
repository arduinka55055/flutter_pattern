import 'package:flutter_application_1/features/timetable/entity.dart';
import 'package:hive/hive.dart';
import '../abstract/timetable.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final Box<Timetable> _box = Hive.box<Timetable>('timetables');

  @override
  Future<List<Timetable>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(Timetable timetable) async {
    await _box.put(timetable.id, timetable);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<Timetable?> getById(String id) async {
    return _box.get(id);
  }
}
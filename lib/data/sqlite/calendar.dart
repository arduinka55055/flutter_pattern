import 'package:flutter_application_1/features/calendar/entity.dart';
import 'package:hive/hive.dart';
import '../abstract/calendar.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final Box<Calendar> _box = Hive.box<Calendar>('calendars');

  @override
  Future<List<Calendar>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(Calendar calendar) async {
    await _box.put(calendar.id, calendar);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<Calendar?> getById(String id) async {
    return _box.get(id);
  }
}

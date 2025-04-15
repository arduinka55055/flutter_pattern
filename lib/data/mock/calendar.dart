import 'package:flutter_application_1/features/calendar/entity.dart';
import '../abstract/calendar.dart';

class MockCalendarRepository implements CalendarRepository {
  final List<Calendar> _calendars = [];

  @override
  Future<List<Calendar>> getAll() async => List.from(_calendars);

  @override
  Future<void> save(Calendar calendar) async {
    _calendars.removeWhere((c) => c.id == calendar.id);
    _calendars.add(calendar);
  }

  @override
  Future<void> delete(String id) async {
    _calendars.removeWhere((c) => c.id == id);
  }
  
  @override
  Future<Calendar?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
 
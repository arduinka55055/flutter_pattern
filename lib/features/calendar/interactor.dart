import 'package:flutter_application_1/data/abstract/calendar.dart';

import 'entity.dart';

class CalendarInteractor {
  final CalendarRepository _repository;

  CalendarInteractor(this._repository);

  Future<List<Calendar>> getCalendars() async {
    return await _repository.getAll();
  }

  Future<void> saveCalendar(Calendar calendar) async {
    // Basic validation
    if (calendar.weekCount < 1 || calendar.weekCount > 4) {
      throw Exception('Invalid week count');
    }

    if (calendar.schedule.length != calendar.weekCount) {
      throw Exception('Schedule weeks mismatch with week count');
    }

    await _repository.save(calendar);
  }

  Future<void> deleteCalendar(String id) async {
    await _repository.delete(id);
  }

  Future<Calendar?> getCalendarById(String id) async {
    final calendars = await _repository.getAll();
    return calendars.firstWhere((c) => c.id == id);
  }
}

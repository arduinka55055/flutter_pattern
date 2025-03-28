import 'package:flutter_application_1/features/calendar/entity.dart';

abstract class CalendarRepository {
  Future<List<Calendar>> getAll();
  Future<void> save(Calendar calendar);
  Future<void> delete(String id);
}

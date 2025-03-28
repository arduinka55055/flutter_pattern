import 'package:flutter_application_1/data/abstract/timetable.dart';

import 'entity.dart';

class TimetableInteractor {
  final TimetableRepository _repository;

  TimetableInteractor(this._repository);

  Future<List<Timetable>> getTimetables() => _repository.getAll();
  Future<void> saveTimetable(Timetable timetable) =>
      _repository.save(timetable);
  Future<void> deleteTimetable(String id) => _repository.delete(id);
}

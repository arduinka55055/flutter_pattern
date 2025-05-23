import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';

import 'interactor.dart';

class TimetablePresenter extends ChangeNotifier {
  final TimetableInteractor _interactor;
  List<Timetable> _timetables = [];
  bool _isLoading = false;

  List<Timetable> get timetables => _timetables;
  bool get isLoading => _isLoading;

  TimetablePresenter(this._interactor) {
    loadTimetables();
  }

  Future<void> loadTimetables() async {
    _isLoading = true;
    notifyListeners();

    _timetables = await _interactor.getTimetables();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTimetable(String name, List<TimeRange> slots) async {
    final newTimetable = Timetable(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      timeSlots: slots,
    );

    await _interactor.saveTimetable(newTimetable);
    await loadTimetables();
  }

  void deleteTimetable(String id) async {
    await _interactor.deleteTimetable(id);
    await loadTimetables();
  }

  void updateTimetable(String id, String name, List<TimeRange> slots) async {
    deleteTimetable(id);
    final newTimetable = Timetable(
      id: id,
      name: name,
      timeSlots: slots,
    );

    await _interactor.saveTimetable(newTimetable);
    await loadTimetables();
  }
}

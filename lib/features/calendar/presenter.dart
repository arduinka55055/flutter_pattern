import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/lesson/entity.dart';

import '../lesson/interactor.dart';
import 'entity.dart';
import 'interactor.dart';

class CalendarPresenter extends ChangeNotifier {
  final CalendarInteractor _interactor;
  final LessonInteractor _lessonInteractor;
  List<Calendar> _calendars = [];
  List<Lesson> _availableLessons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Lesson> get availableLessons => _availableLessons;
  List<Calendar> get calendars => _calendars;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CalendarPresenter(this._interactor, this._lessonInteractor);

  Future<void> initialize() async {
    _calendars = await _interactor.getCalendars();
    _availableLessons = await _lessonInteractor.getLessons();
    notifyListeners();
  }

  Future<void> createCalendar({
    required String name,
    required int weekCount,
    required Map<int, Map<Day, List<String?>>> schedule,
  }) async {
    final newCalendar = Calendar(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      weekCount: weekCount,
      schedule: schedule,
    );

    await _interactor.saveCalendar(newCalendar);
    await initialize();
  }

  Future<void> deleteCalendar(String id) async {
    try {
      await _interactor.deleteCalendar(id);
      await initialize();
    } catch (e) {
      _errorMessage = 'Failed to delete calendar: ${e.toString()}';
      notifyListeners();
    }
  }
}

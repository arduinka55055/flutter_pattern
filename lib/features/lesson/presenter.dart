import 'package:flutter/material.dart';

import 'entity.dart';
import 'interactor.dart';

class LessonPresenter extends ChangeNotifier {
  final LessonInteractor _interactor;
  List<Lesson> _lessons = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LessonPresenter(this._interactor);

  Future<void> loadLessons() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lessons = await _interactor.getLessons();
    } catch (e) {
      _errorMessage = 'Failed to load lessons: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createLesson({
    required String name,
    required String teacher,
    required String room,
    required LessonType type,
    required Color color,
    String notes = '',
  }) async {
    final newLesson = Lesson(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      teacher: teacher,
      room: room,
      notes: notes,
      type: type,
      color: color,
    );

    try {
      await _interactor.saveLesson(newLesson);
      await loadLessons();
    } catch (e) {
      _errorMessage = 'Failed to create lesson: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> updateLesson(Lesson updatedLesson) async {
    try {
      await _interactor.saveLesson(updatedLesson);
      await loadLessons();
    } catch (e) {
      _errorMessage = 'Failed to update lesson: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteLesson(String id) async {
    try {
      await _interactor.deleteLesson(id);
      await loadLessons();
    } catch (e) {
      _errorMessage = 'Failed to delete lesson: ${e.toString()}';
      notifyListeners();
    }
  }
}

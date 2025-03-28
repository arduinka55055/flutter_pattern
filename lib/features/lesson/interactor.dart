import 'package:flutter_application_1/data/abstract/lesson.dart';

import 'entity.dart';

class LessonInteractor {
  final LessonRepository _repository;

  LessonInteractor(this._repository);

  Future<List<Lesson>> getLessons() => _repository.getAll();
  Future<void> saveLesson(Lesson lesson) => _repository.save(lesson);
  Future<void> deleteLesson(String id) => _repository.delete(id);
}

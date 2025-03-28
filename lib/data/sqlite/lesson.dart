import 'package:flutter_application_1/features/lesson/entity.dart';
import '../abstract/lesson.dart';

class MockLessonRepository implements LessonRepository {
  final List<Lesson> _lessons = [];

  @override
  Future<List<Lesson>> getAll() async => List.from(_lessons);

  @override
  Future<void> save(Lesson lesson) async {
    _lessons.removeWhere((l) => l.id == lesson.id);
    _lessons.add(lesson);
  }

  @override
  Future<void> delete(String id) async {
    _lessons.removeWhere((l) => l.id == id);
  }
}

import 'package:flutter_application_1/features/lesson/entity.dart';

abstract class LessonRepository {
  Future<List<Lesson>> getAll();
  Future<void> save(Lesson lesson);
  Future<void> delete(String id);
}

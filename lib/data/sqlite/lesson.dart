import 'package:flutter_application_1/features/lesson/entity.dart';
import 'package:hive/hive.dart';
import '../abstract/lesson.dart';

class LessonRepositoryImpl implements LessonRepository {
  final Box<Lesson> _box = Hive.box<Lesson>('lessons');

  @override
  Future<List<Lesson>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> save(Lesson lesson) async {
    await _box.put(lesson.id, lesson);
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<Lesson?> getById(String id) async {
    return _box.get(id);
  }
}

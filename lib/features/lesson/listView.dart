import 'package:flutter/material.dart';
import 'package:flutter_application_1/Common/LessonListItem.dart';
import 'package:flutter_application_1/router.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<LessonPresenter>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.calendarList),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.createLesson),
        child: const Icon(Icons.add),
      ),
      body: presenter.isLoading
          ? const Center(child: CircularProgressIndicator())
          : presenter.lessons.isEmpty
              ? const Center(child: Text('No lessons created yet!'))
              : ListView.builder(
                  itemCount: presenter.lessons.length,
                  itemBuilder: (context, index) => LessonListItem(
                    lesson: presenter.lessons[index],
                    onEdit: () =>
                        _editLesson(context, presenter.lessons[index]),
                    onDelete: () =>
                        _confirmDelete(context, presenter.lessons[index]),
                    isSelected: false, // Optional parameter
                  ),
                ),
    );
  }

  void _editLesson(BuildContext context, Lesson lesson) {
    // Implement edit navigation TODO:
    /*Navigator.pushNamed(
      context,
      AppRouter.editLesson,
      arguments: lesson.id,
    );*/
  }

  void _confirmDelete(BuildContext context, Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson?'),
        content: Text('Are you sure you want to delete ${lesson.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<LessonPresenter>().deleteLesson(lesson.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

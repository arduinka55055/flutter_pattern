import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class CreateLessonScreen extends StatefulWidget {
  final bool editMode;

  const CreateLessonScreen({super.key, this.editMode = false});

  @override
  State<CreateLessonScreen> createState() => _CreateLessonScreenState();
}

class _CreateLessonScreenState extends State<CreateLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();
  final _roomController = TextEditingController();
  final _notesController = TextEditingController();
  LessonType _selectedType = LessonType.lecture;
  Color _selectedColor = Colors.blue;
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  String get actionName =>
      widget.editMode ? 'Change Timetable' : 'Create Timetable';

  String? _updateId;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (!widget.editMode) {
        context.read<LessonPresenter>().createLesson(
              name: _nameController.text,
              teacher: _teacherController.text,
              room: _roomController.text,
              notes: _notesController.text,
              type: _selectedType,
              color: _selectedColor,
            );
      }
      else {
        context.read<LessonPresenter>().updateLesson(
              id: _updateId!,
              name: _nameController.text,
              teacher: _teacherController.text,
              room: _roomController.text,
              notes: _notesController.text,
              type: _selectedType,
              color: _selectedColor,
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editMode && _updateId == null) {
      final routeSetting = ModalRoute.of(context)?.settings.arguments;
      if (routeSetting != null) {
        final lessonId = routeSetting as String;
        final lesson = context
            .read<LessonPresenter>()
            .lessons
            .firstWhere((l) => l.id == lessonId);

        _updateId = lesson.id;
        _nameController.text = lesson.name;
        _teacherController.text = lesson.teacher;
        _roomController.text = lesson.room;
        _notesController.text = lesson.notes;
        _selectedType = lesson.type;
        _selectedColor = lesson.color;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Lesson Name',
                  icon: Icon(Icons.subject),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _teacherController,
                decoration: const InputDecoration(
                    labelText: 'Teacher', icon: Icon(Icons.person)),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(
                    labelText: 'Room', icon: Icon(Icons.room)),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<LessonType>(
                value: _selectedType,
                decoration: const InputDecoration(
                    labelText: 'Type', icon: Icon(Icons.category)),
                items: LessonType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Color:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _colorOptions
                          .map(
                            (color) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedColor = color),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: _selectedColor == color
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 2),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Notes', icon: Icon(Icons.notes)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Create Lesson')),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/features/lesson/viper/view/components/lesson_list_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/lesson/entity.dart';


class LessonListItem extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isSelected;

  const LessonListItem({
    super.key,
    required this.lesson,
    required this.onEdit,
    required this.onDelete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 1,
      color: isSelected ? Colors.blue.shade50 : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: _buildColorIndicator(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildActionButtons(),
        onTap: onEdit,
      ),
    );
  }

  Widget _buildColorIndicator() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: lesson.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lesson.color.withOpacity(0.5), width: 2),
      ),
      child: Center(
        child: Text(
          lesson.name.substring(0, 1).toUpperCase(),
          style: TextStyle(
            color: lesson.color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            lesson.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text(
            lesson.type.toString().split('.').last,
            style: TextStyle(
              color: lesson.type == LessonType.lecture
                  ? Colors.blue.shade800
                  : Colors.green.shade800,
            ),
          ),
          backgroundColor: lesson.type == LessonType.lecture
              ? Colors.blue.shade100
              : Colors.green.shade100,
          side: BorderSide.none,
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        if (lesson.teacher.isNotEmpty)
          _buildInfoRow(Icons.person_outline, lesson.teacher),
        if (lesson.room.isNotEmpty)
          _buildInfoRow(Icons.room_outlined, lesson.room),
        if (lesson.notes.isNotEmpty)
          _buildInfoRow(Icons.note_outlined, lesson.notes),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue.shade600),
            onPressed: onEdit,
            tooltip: 'Edit lesson',
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade600),
            onPressed: onDelete,
            tooltip: 'Delete lesson',
          ),
        ],
      ),
    );
  }
}

// lib/features/calendar/viper/view/components/week_schedule_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/entity.dart';
import 'package:flutter_application_1/features/lesson/entity.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';

class WeekScheduleCard extends StatelessWidget {
  final int weekNumber;
  final List<TimeRange> timetableSlots;
  final List<Lesson> availableLessons;
  final Map<Day, List<String?>> currentSchedule;
  final Function(Day day, int slotIndex, String? lessonId) onLessonSelected;

  const WeekScheduleCard({
    super.key,
    required this.weekNumber,
    required this.timetableSlots,
    required this.availableLessons,
    required this.currentSchedule,
    required this.onLessonSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildScheduleTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Week $weekNumber',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Icon(Icons.calendar_view_week, size: 20, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildScheduleTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: _buildColumnWidths(),
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          _buildTableHeader(context),
          ...Day.values.map((day) => _buildDayRow(day, context)),
        ],
      ),
    );
  }

  Map<int, TableColumnWidth> _buildColumnWidths() {
    return {
      0: const FixedColumnWidth(120),
      for (int i = 1; i <= timetableSlots.length; i++)
        i: const FixedColumnWidth(180),
    };
  }

  TableRow _buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[100]),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text('Day')),
        ),
        ...timetableSlots.map((slot) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Center(
                child: Text(
                  '${slot.start.format(context)} - ${slot.end.format(context)}',
                ),
              ),
            )),
      ],
    );
  }

  TableRow _buildDayRow(Day day, BuildContext context) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              _getDayName(day),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
        ...List.generate(timetableSlots.length,
            (slotIndex) => _buildLessonDropdown(day, slotIndex)),
      ],
    );
  }

  String _getDayName(Day day) {
    return day.toString().split('.').last[0].toUpperCase() +
        day.toString().split('.').last.substring(1);
  }

  Widget _buildLessonDropdown(Day day, int slotIndex) {
    final currentLessonId = currentSchedule[day]?[slotIndex];
    final currentLesson = availableLessons.firstWhere(
      (lesson) => lesson.id == currentLessonId,
      orElse: () => Lesson(
        id: '',
        name: '',
        teacher: '',
        room: '',
        notes: '',
        type: LessonType.lecture,
        color: Colors.transparent,
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DropdownButtonFormField<String?>(
        value: currentLessonId,
        decoration: InputDecoration(
          filled: true,
          fillColor: currentLesson.color.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        items: [
          DropdownMenuItem(
            value: null,
            child: Text(
              'Select lesson',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ...availableLessons.map((lesson) => DropdownMenuItem(
                value: lesson.id,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: lesson.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(lesson.name),
                  ],
                ),
              )),
        ],
        onChanged: (value) => onLessonSelected(day, slotIndex, value),
        selectedItemBuilder: (context) => [
          ...availableLessons.map((lesson) => Center(
                child: Text(
                  lesson.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
      ),
    );
  }
}

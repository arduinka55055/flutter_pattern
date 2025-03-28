import 'package:flutter/material.dart';
import 'package:flutter_application_1/Common/weekScheduleCard.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';
import 'package:flutter_application_1/features/timetable/presenter.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class CreateCalendarScreen extends StatefulWidget {
  const CreateCalendarScreen({super.key});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedWeekCount = 1;
  Timetable? _selectedTimetable;
  final Map<int, Map<Day, List<String?>>> _schedule = {};

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedTimetable != null) {
      context.read<CalendarPresenter>().createCalendar(
            name: 'New Calendar', // Add proper name field in UI
            weekCount: _selectedWeekCount,
            //timetableId: _selectedTimetable!.id, //TODO:
            schedule: _schedule,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendarPresenter = context.watch<CalendarPresenter>();
    final timetablePresenter = context.watch<TimetablePresenter>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Timetable Selector
              DropdownButtonFormField<Timetable>(
                value: _selectedTimetable,
                decoration:
                    const InputDecoration(labelText: 'Select Timetable'),
                items: timetablePresenter.timetables.map((timetable) {
                  return DropdownMenuItem<Timetable>(
                    value: timetable,
                    child: Text(timetable.name),
                  );
                }).toList(),
                onChanged: (timetable) =>
                    setState(() => _selectedTimetable = timetable),
                validator: (value) => value == null ? 'Required' : null,
              ),

              // Week Count Selector
              DropdownButtonFormField<int>(
                value: _selectedWeekCount,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('1 Week')),
                  DropdownMenuItem(value: 2, child: Text('2 Weeks')),
                  DropdownMenuItem(value: 4, child: Text('4 Weeks')),
                ],
                onChanged: (value) =>
                    setState(() => _selectedWeekCount = value!),
                validator: (value) => value == null ? 'Required' : null,
              ),

              Expanded(
                child: _selectedTimetable == null
                    ? const Center(child: Text('Please select a timetable'))
                    : ListView.builder(
                        itemCount: _selectedWeekCount,
                        itemBuilder: (context, weekIndex) => WeekScheduleCard(
                          weekNumber: weekIndex + 1,
                          timetableSlots: _selectedTimetable!.timeSlots,
                          availableLessons: calendarPresenter.availableLessons,
                          currentSchedule: _schedule[weekIndex + 1] ?? {},
                          onLessonSelected: (day, slotIndex, lessonId) {
                            setState(() {
                              _schedule[weekIndex + 1] ??= {};
                              _schedule[weekIndex + 1]![day] ??= List.filled(
                                _selectedTimetable!.timeSlots.length,
                                null,
                              );
                              _schedule[weekIndex + 1]![day]![slotIndex] =
                                  lessonId;
                            });
                          },
                        ),
                      ),
              ),
              ElevatedButton(
                  onPressed: _submit, child: const Text('Create Calendar')),
            ],
          ),
        ),
      ),
    );
  }
}

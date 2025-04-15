import 'package:flutter/material.dart';
import 'package:flutter_application_1/Common/weekScheduleCard.dart';
import 'package:flutter_application_1/data/conterters/schedule_converter.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';
import 'package:flutter_application_1/features/timetable/presenter.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class CreateCalendarScreen extends StatefulWidget {
  final bool editMode;

  const CreateCalendarScreen({super.key, this.editMode = false});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedWeekCount = 1;
  Timetable? _selectedTimetable;
  Map<int, Map<Day, List<String?>>> _schedule = {};

  String get actionName =>
      widget.editMode ? 'Change Calendar' : 'Create Calendar';

  String? _updateId = null;

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedTimetable != null) {
      if (!widget.editMode) {
        context.read<CalendarPresenter>().createCalendar(
              name: 'New Calendar',
              weekCount: _selectedWeekCount,
              timetableId: _selectedTimetable!.id,
              schedule: _schedule,
            );
      } else {
        context.read<CalendarPresenter>().updateCalendar(
              id: _updateId!,
              name: 'Change Calendar',
              weekCount: _selectedWeekCount,
              timetableId: _selectedTimetable!.id,
              schedule: _schedule,
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
        final calendarId = routeSetting as String;
        final calendar = context
            .read<CalendarPresenter>()
            .calendars
            .firstWhere((c) => c.id == calendarId);
        _updateId = calendar.id;
        _selectedWeekCount = calendar.weekCount;
        _selectedTimetable = context
            .read<TimetablePresenter>()
            .timetables
            .firstWhere((t) => t.id == calendar.timetableId);
        _schedule = ScheduleConverter.fromHiveFormat(calendar.schedule);
      }
    }

    final calendarPresenter = context.watch<CalendarPresenter>();
    final timetablePresenter = context.watch<TimetablePresenter>();

    return Scaffold(
      appBar: AppBar(title: Text(actionName)),
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
                          weekNumber: weekIndex,
                          timetableSlots: _selectedTimetable!.timeSlots,
                          availableLessons: calendarPresenter.availableLessons,
                          currentSchedule: _schedule[weekIndex] ?? {},
                          onLessonSelected: (day, slotIndex, lessonId) {
                            setState(() {
                              _schedule[weekIndex] ??= {};
                              _schedule[weekIndex]![day] ??= List.filled(
                                _selectedTimetable!.timeSlots.length,
                                null,
                              );
                              _schedule[weekIndex]![day]![slotIndex] = lessonId;
                            });
                          },
                        ),
                      ),
              ),
              ElevatedButton(onPressed: _submit, child: Text(actionName)),
            ],
          ),
        ),
      ),
    );
  }
}

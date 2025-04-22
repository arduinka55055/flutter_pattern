// features/export/viper/view/export_screen.dart
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/entity.dart';
import 'package:flutter_application_1/features/lesson/entity.dart';
import 'package:flutter_application_1/features/lesson/presenter.dart';
import 'package:flutter_application_1/features/timetable/entity.dart';
import 'package:flutter_application_1/features/timetable/presenter.dart';
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:ical/serializer.dart';
import 'package:provider/provider.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  late Calendar _calendar;

  String _timeZone = 'UTC';
  int _alertOffset = 30;
  int? _startingWeekIndex;
  final List<int> _alertOptions = [0, 15, 30, 60];
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = _startDate.add(const Duration(days: 30));
    _initTimeZone();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Calendar? cal = ModalRoute.of(context)?.settings.arguments as Calendar?;
    if (cal == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _calendar = cal;
    });
  }

  Future<void> _initTimeZone() async {
    final String currentTimeZone = "EET";
    //await FlutterNativeTimezone.getLocalTimezone();
    setState(() => _timeZone = currentTimeZone);
  }

  Future<void> _generateICS() async {
    final calendar = await _buildICalendar();
    final fileName = '${_calendar.name}_${_dateFormat.format(_startDate)}.ics';

    await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(calendar.serialize().codeUnits),
        mimeType: MimeType.text,
        ext: 'ics');
  }

  Future<ICalendar> _buildICalendar() async {
    final calendar = ICalendar();
    final weekCycle = _calendar.weekCount;
    final timetable = context
        .read<TimetablePresenter>()
        .timetables
        .firstWhere((timetable) => timetable.id == _calendar.timetableId);

    // Convert dates to UTC
    final startUtc = _startDate.toUtc();
    final endUtc = _endDate.toUtc();

    // Generate events for one full cycle
    final cycleDays = weekCycle * 7;
    final initialPeriodEnd = _startDate.add(Duration(days: cycleDays));

    for (var date = _startDate;
        date.isBefore(initialPeriodEnd);
        date = date.add(const Duration(days: 1))) {
      final weekIndex = (date.difference(_startDate).inDays ~/ 7) % weekCycle;
      final day = _convertToAppDay(date.weekday);

      final lessons = _calendar.schedule[weekIndex]?[date.weekday] ?? [];

      for (int slotIndex = 0; slotIndex < lessons.length; slotIndex++) {
        final lessonId = lessons[slotIndex];
        if (lessonId == null) continue;

        final lesson = context
            .read<LessonPresenter>()
            .lessons
            .firstWhere((lesson) => lesson.id == lessonId);
        final timeSlot = timetable.timeSlots[slotIndex];

        // Convert to UTC times
        final startDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          timeSlot.start.hour,
          timeSlot.start.minute,
        ).toUtc();

        final endDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          timeSlot.end.hour,
          timeSlot.end.minute,
        ).toUtc();

        // Create recurrence rule
        final rrule = IRecurrenceRule(
          frequency: IRecurrenceFrequency.WEEKLY, //TODO: it doesn't work
          interval: weekCycle,
          untilDate: endUtc,
          weekday: date.weekday,
        );

        // Create event with lesson-specific color
        final event = IEvent(
          uid: '${lesson.id}-${date.millisecondsSinceEpoch}',
          start: startDateTime,
          end: endDateTime,
          summary: lesson.name,
          description: '${lesson.teacher}\n${lesson.room}\n${lesson.notes}',
          location: lesson.room,
          categories: [lesson.type.toString()],
          rrule: rrule,
          alarm: _alertOffset > 0
              ? IAlarm.display(
                  duration: Duration(minutes: _alertOffset),
                  description: 'Reminder: ${lesson.name}')
              : null,
        );

        // Set color from lesson entity
        //event.extraParams['X-APPLE-CALENDAR-COLOR'] =
        //  ContentLine('COLOR:${_colorToHex(lesson.color)}');

        calendar.addElement(event);
      }
    }

    return calendar;
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  IEvent _createEvent(DateTime date, TimeRange slot, Lesson lesson) {
    final startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      slot.start.hour,
      slot.start.minute,
    );

    final endDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      slot.end.hour,
      slot.end.minute,
    );

    return IEvent(
      uid: '${lesson.id}-${date.millisecondsSinceEpoch}',
      start: startDateTime,
      end: endDateTime,
      summary: lesson.name,
      description: 'Teacher: ${lesson.teacher}\n'
          'Room: ${lesson.room}\n'
          'Notes: ${lesson.notes}',
      location: lesson.room,
      status: IEventStatus.CONFIRMED,
      categories: [lesson.type.toString()],
      // alarms: _alertOffset > 0
      //     ? [
      //         IAlarm.display(
      //             trigger: Duration(minutes: _alertOffset),
      //             description: 'Reminder: ${lesson.name} starts soon')
      //       ]
      //     : [],
    );
  }

  Day _convertToAppDay(int weekday) {
    const days = {
      1: Day.monday,
      2: Day.tuesday,
      3: Day.wednesday,
      4: Day.thursday,
      5: Day.friday,
      6: Day.saturday,
      7: Day.sunday,
    };
    return days[weekday]!;
  }

  String _convertWeekDay(int weekday) {
    const days = {
      1: 'MO',
      2: 'TU',
      3: 'WE',
      4: 'TH',
      5: 'FR',
      6: 'SA',
      7: 'SU',
    };
    return days[weekday]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Calendar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDatePicker('Start Date', _startDate,
                (date) => setState(() => _startDate = date!)),
            _buildDatePicker('End Date', _endDate,
                (date) => setState(() => _endDate = date!)),
            if (_calendar.weekCount > 1)
              DropdownButtonFormField<int>(
                value: _startingWeekIndex,
                hint: const Text('Starting Week Index'),
                items: List.generate(
                    _calendar.weekCount,
                    (i) => DropdownMenuItem(
                        value: i, child: Text('Week ${i + 1}'))),
                onChanged: (value) =>
                    setState(() => _startingWeekIndex = value),
              ),
            DropdownButtonFormField<int>(
              value: _alertOffset,
              items: _alertOptions
                  .map((mins) => DropdownMenuItem(
                        value: mins,
                        child: Text(
                            mins == 0 ? 'No alert' : '$mins minutes before'),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _alertOffset = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateICS,
              child: const Text('Generate ICS File'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime date, ValueChanged<DateTime?> onChanged) {
    return ListTile(
      title: Text(label),
      subtitle: Text(_dateFormat.format(date)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (selected != null) onChanged(selected);
      },
    );
  }
}

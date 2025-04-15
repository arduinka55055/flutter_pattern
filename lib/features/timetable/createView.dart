import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class CreateTimetableScreen extends StatefulWidget {
  final bool editMode;

  const CreateTimetableScreen({super.key, this.editMode = false});

  @override
  State<CreateTimetableScreen> createState() => _CreateTimetableScreenState();
}

class _CreateTimetableScreenState extends State<CreateTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<TimeRange> _timeSlots = [];

  String get actionName =>
      widget.editMode ? 'Change Timetable' : 'Create Timetable';

  String? _updateId = null;

  Future<void> _editTimeSlot(int index) async {
    final originalSlot = _timeSlots[index];
    final result = await showDialog<TimeRange?>(
      context: context,
      builder: (context) => TimeSlotDialog(
        initialStart: originalSlot.start,
        initialEnd: originalSlot.end,
      ),
    );

    if (result != null) {
      setState(() {
        _timeSlots[index] = result;
      });
    }
  }

  Future<void> _addTimeSlot() async {
    final result = await showDialog<TimeRange?>(
      context: context,
      builder: (context) => const TimeSlotDialog(),
    );

    if (result != null) {
      setState(() {
        _timeSlots.add(result);
      });
    }
  }

  void _deleteTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _timeSlots.isNotEmpty) {
      if (!widget.editMode) {
        context.read<TimetablePresenter>().createTimetable(
              _nameController.text,
              _timeSlots,
            );
      } else {
        context.read<TimetablePresenter>().updateTimetable(
              _updateId!,
              _nameController.text,
              _timeSlots,
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
        final timetableId = routeSetting as String;
        final timetable = context
            .read<TimetablePresenter>()
            .timetables
            .firstWhere((t) => t.id == timetableId);
        _updateId = timetable.id;
        _nameController.text = timetable.name;
        _timeSlots.addAll(timetable.timeSlots);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(actionName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Timetable Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addTimeSlot,
                child: const Text('Add Time Slot'),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _timeSlots.isEmpty
                    ? const Center(child: Text('No time slots added yet'))
                    : ListView.builder(
                        itemCount: _timeSlots.length,
                        itemBuilder: (context, index) {
                          final slot = _timeSlots[index];
                          return ListTile(
                            title: Text(
                                '${slot.start.format(context)} - ${slot.end.format(context)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editTimeSlot(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteTimeSlot(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: Text(actionName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeSlotDialog extends StatefulWidget {
  final TimeOfDay? initialStart;
  final TimeOfDay? initialEnd;

  const TimeSlotDialog({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  @override
  State<TimeSlotDialog> createState() => _TimeSlotDialogState();
}

class _TimeSlotDialogState extends State<TimeSlotDialog> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStart ?? TimeOfDay.now();
    _endTime = widget.initialEnd ?? TimeOfDay.now();
  }

  Future<void> _selectTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
        _validateTimes();
      });
    }
  }

  void _validateTimes() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    setState(() {
      _hasError = endMinutes <= startMinutes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialStart == null ? 'Add Time Slot' : 'Edit Time Slot'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Start Time'),
                  TextButton(
                    onPressed: () => _selectTime(true),
                    child: Text(_startTime.format(context)),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('End Time'),
                  TextButton(
                    onPressed: () => _selectTime(false),
                    child: Text(_endTime.format(context)),
                  ),
                ],
              ),
            ],
          ),
          if (_hasError)
            const Text(
              'End time must be after start time',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
            onPressed: _hasError
                ? null
                : () => Navigator.pop(
                    context,
                    TimeRange(
                      start: _startTime,
                      end: _endTime,
                    )),
            child: const Text('Save')),
      ],
    );
  }
}

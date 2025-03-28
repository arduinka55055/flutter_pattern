import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class CreateTimetableScreen extends StatefulWidget {
  const CreateTimetableScreen({super.key});

  @override
  State<CreateTimetableScreen> createState() => _CreateTimetableScreenState();
}

class _CreateTimetableScreenState extends State<CreateTimetableScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final List<TimeRange> _timeSlots = [];

  Future<void> _addTimeSlot() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _timeSlots.add(TimeRange(
          start: time,
          end: TimeOfDay(hour: time.hour + 1, minute: time.minute),
        ));
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<TimetablePresenter>().createTimetable(
            _nameController.text,
            _timeSlots,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Timetable')),
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
                child: ListView.builder(
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final slot = _timeSlots[index];
                    return ListTile(
                      title: Text(
                          '${slot.start.format(context)} - ${slot.end.format(context)}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Timetable'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

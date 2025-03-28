// lib/features/timetable/viper/view/timetable_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity.dart';
import 'presenter.dart';

class TimetableListScreen extends StatelessWidget {
  const TimetableListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<TimetablePresenter>();

    return Scaffold(
      appBar: AppBar(title: const Text('Timetables')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/timetables/create'),
        child: const Icon(Icons.add),
      ),
      body: presenter.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: presenter.timetables.length,
              itemBuilder: (context, index) {
                final timetable = presenter.timetables[index];
                return ListTile(
                  title: Text(timetable.name),
                  subtitle: Text('${timetable.timeSlots.length} time slots'),
                );
              },
            ),
    );
  }
}

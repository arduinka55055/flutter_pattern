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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pushNamed(
                            context, '/timetables/edit',
                            arguments: presenter.timetables[index].id),
                        icon: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Timetable'),
                              content: const Text(
                                  'Are you sure you want to delete this timetable?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    presenter.deleteTimetable(timetable.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

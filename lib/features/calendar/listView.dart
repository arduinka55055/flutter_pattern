// lib/features/calendar/viper/view/calendar_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/router.dart';
import 'package:provider/provider.dart';
import 'entity.dart';
import 'presenter.dart';

class CalendarListScreen extends StatefulWidget {
  const CalendarListScreen({super.key});

  @override
  State<CalendarListScreen> createState() => _CalendarListScreenState();
}

class _CalendarListScreenState extends State<CalendarListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarPresenter>().initialize();
    });
  }

  void _confirmDelete(Calendar calendar) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Calendar?'),
        content: Text('Are you sure you want to delete ${calendar.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<CalendarPresenter>().deleteCalendar(calendar.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<CalendarPresenter>();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendars')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, AppRouter.createCalendar),
      ),
      body: presenter.isLoading
          ? const Center(child: CircularProgressIndicator())
          : presenter.calendars.isEmpty
              ? const Center(child: Text('No calendars created yet!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: presenter.calendars.length,
                  itemBuilder: (context, index) => _CalendarListItem(
                    calendar: presenter.calendars[index],
                    onDelete: () => _confirmDelete(presenter.calendars[index]),
                  ),
                ),
    );
  }
}

class _CalendarListItem extends StatelessWidget {
  final Calendar calendar;
  final VoidCallback onDelete;

  const _CalendarListItem({
    required this.calendar,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(calendar.name,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${calendar.weekCount} week(s)'),
            Text('Timetable: ${calendar.timetableId}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: () {
          // TODO: Navigate to calendar detail screen
        },
      ),
    );
  }
}

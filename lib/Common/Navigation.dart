import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/calendar/listView.dart';
import 'package:flutter_application_1/features/lesson/listView.dart';
import 'package:flutter_application_1/features/timetable/listView.dart';
import 'package:flutter_application_1/router.dart';

class MainWrapper extends StatelessWidget {
  final Widget? child;

  const MainWrapper({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('University Calendar')),
      drawer: AppDrawer(),
      body: child ?? _buildDefaultBody(context),
      floatingActionButton: _getFAB(context),
    );
  }

  Widget _buildDefaultBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select a feature from the menu'),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.timetableList),
            child: const Text('Go to Timetables'),
          ),
        ],
      ),
    );
  }

  Widget? _getFAB(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name;
    switch (route) {
      case AppRouter.timetableList:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () =>
              Navigator.pushNamed(context, AppRouter.createTimetable),
        );
      case AppRouter.lessonList:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, AppRouter.createLesson),
        );
      case AppRouter.calendarList:
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () =>
              Navigator.pushNamed(context, AppRouter.createCalendar),
        );
      default:
        return null;
    }
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('University Calendar',
                  style: TextStyle(color: Colors.white, fontSize: 24))),
          _buildDrawerItem(
            context,
            icon: Icons.schedule,
            title: 'Timetables',
            route: AppRouter.timetableList,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.school,
            title: 'Lessons',
            route: AppRouter.lessonList,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.calendar_month,
            title: 'Calendars',
            route: AppRouter.calendarList,
          ),
          /*_buildDrawerItem(
            context,
            icon: Icons.import_export,
            title: 'Export',
            route: AppRouter.export,
          ),*/ //TODO:
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isCurrent = ModalRoute.of(context)?.settings.name == route;

    return ListTile(
      leading: Icon(icon, color: isCurrent ? Colors.blue : null),
      title: Text(title),
      selected: isCurrent,
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

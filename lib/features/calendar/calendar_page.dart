import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: ListView(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.background),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              // titleCentered: true,
              // formatButtonVisible: false,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).primaryColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).primaryColor,
              ),
              titleTextStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              formatButtonShowsNext: false,
            ),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
          )
        ],
      ),
    );
  }
}

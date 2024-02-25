import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late ValueNotifier<List<ListingBookings>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late List<ListingBookings>? bookingsData;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<ListingBookings> _getEventsForDay(DateTime day) {
    final events = bookingsData
        ?.where((booking) =>
            isSameDay(booking.startDate, day) ||
            isSameDay(booking.endDate, day) ||
            (booking.startDate!.isBefore(day) && booking.endDate!.isAfter(day)))
        .map((booking) => booking)
        .toList();

    return events ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    // selectedDay + 2
    final user = ref.watch(userProvider);

    return ref.watch(getAllBookingsByCoopIdProvider(user!.currentCoop!)).when(
          data: (bookings) {
            bookingsData = bookings;
            _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

            // ref.read(listBookingsProvider.notifier).setListBookings(bookings);
            return buildScaffold(user, context, bookings);
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => ErrorText(
            error: error.toString(),
            stackTrace: stack.toString(),
          ),
        );
  }

  Scaffold buildScaffold(
      UserModel? user, BuildContext context, List<ListingBookings> bookings) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Calendar', user: user),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              _onDaySelected(selectedDay, focusedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.background,
              ),
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
                color: Theme.of(context).colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary,
              ),
              titleTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              formatButtonShowsNext: false,
            ),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            startingDayOfWeek: StartingDayOfWeek.monday,
          ),
          Expanded(
            child: ValueListenableBuilder<List<ListingBookings>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final booking = value[index];

                    return ref
                        .watch(getListingProvider(booking.listingId))
                        .when(
                          data: (listing) {
                            return BookingCard(
                                booking: booking, listing: listing);
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => ErrorText(
                            error: error.toString(),
                            stackTrace: stack.toString(),
                          ),
                        );
                  },
                );
              },
            ),
          ),
          // ref.watch(getTasksByUserIdProvider(user!.uid)).when(
          //       data: (tasks) {
          //         debugPrintJson("File Name: dashboard_page.dart");
          //         return Expanded(
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: ListView.builder(
          //               itemCount: tasks.length,
          //               itemBuilder: (context, index) {
          //                 final task = tasks[index];
          //                 return TodayTaskCard(task: task);
          //               },
          //             ),
          //           ),
          //         );
          //       },
          //       loading: () => const SizedBox.shrink(),
          //       error: (error, stack) => ErrorText(
          //         error: error.toString(),
          //         stackTrace: stack.toString(),
          //       ),
          //     ),
        ],
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

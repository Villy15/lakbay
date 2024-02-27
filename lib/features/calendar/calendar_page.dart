import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/calendar/components/event_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/calendar_wrapper.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late ValueNotifier<List<CalendarEvent>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late List<CalendarEvent>? calendarEventData;
  late List<ListingBookings>? bookingsData;
  late List<EventModel>? eventsData;

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

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final events = calendarEventData
        ?.where((event) =>
            isSameDay(event.startDate, day) ||
            isSameDay(event.endDate, day) ||
            (event.startDate!.isBefore(day) && event.endDate!.isAfter(day)))
        .map((event) => event)
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
    final events =
        ref.watch(getEventsByCoopIdProvider(user!.currentCoop!)).asData?.value;

    return ref
        .watch(getAllBookingsByCoopIdProvider(user.currentCoop!))
        .maybeWhen(
          data: (bookings) {
            calendarEventData = [];
            bookingsData = bookings;
            eventsData = events;

            for (var booking in bookings) {
              calendarEventData?.add(CalendarEvent(
                type: 'booking',
                title: booking.listingTitle,
                startDate: booking.startDate,
                endDate: booking.endDate,
                guests: booking.guests.toString(),
                bookingStatus: booking.bookingStatus,
                listingId: booking.listingId,
              ));
            }

            for (var event in events!) {
              calendarEventData?.add(CalendarEvent(
                type: 'event',
                title: event.name,
                startDate: event.startDate,
                endDate: event.endDate,
                eventId: event.uid,
              ));
            }

            _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

            // ref.read(listBookingsProvider.notifier).setListBookings(bookings);
            return buildScaffold(user, context, bookings, events);
          },
          orElse: () => const Loader(),
        );
  }

  Scaffold buildScaffold(UserModel? user, BuildContext context,
      List<ListingBookings> bookings, List<EventModel>? events) {
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
            child: ValueListenableBuilder<List<CalendarEvent>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'lib/core/images/SleepingCatFromGlitch.svg',
                          height: 100, // Adjust height as desired
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No events Today!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'It looks like a great day to rest, relax,',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'and enjoy the day!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: value.length,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  itemBuilder: (context, index) {
                    final calendarEvent = value[index];

                    if (calendarEvent.type == 'booking') {
                      final booking = bookingsData!.firstWhere((element) =>
                          element.listingId == calendarEvent.listingId);
                      return ref
                          .watch(getListingProvider(booking.listingId))
                          .when(
                            data: (listing) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BookingCard(
                                  booking: booking,
                                  listing: listing,
                                ),
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => ErrorText(
                              error: error.toString(),
                              stackTrace: stack.toString(),
                            ),
                          );
                    } else {
                      final event = eventsData!.firstWhere(
                          (element) => element.uid == calendarEvent.eventId);
                      return ref.watch(getEventsProvider(event.uid!)).when(
                            data: (event) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: EventCard(
                                  event: event,
                                ),
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => ErrorText(
                              error: error.toString(),
                              stackTrace: stack.toString(),
                            ),
                          );
                    }
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

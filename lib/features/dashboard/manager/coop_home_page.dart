import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/features/tasks/widgets/today_task_card.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Home', user: user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome name
              Text(
                "Welcome, ${user!.name}!",
                // bold and large
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Upcoming bookings this week",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              ref.watch(getAllBookingsByCoopIdProvider(user.currentCoop!)).when(
                    data: (bookings) {
                      if (bookings.isEmpty) {
                        return const Text("No bookings found");
                      }
                      // make bookings appear only if they are within the next 7 days and make it ascending
                      final updatedBookings = bookings
                          .where((booking) =>
                              DateTime.now().isBefore(booking.startDate!) &&
                              DateTime.now()
                                  .add(const Duration(days: 7))
                                  .isAfter(booking.startDate!))
                          .toList()
                        ..sort((a, b) => a.startDate!.compareTo(b.startDate!));

                      return ListView.separated(
                        itemCount: updatedBookings.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        itemBuilder: (context, index) {
                          final booking = updatedBookings[index];

                          return ref
                              .watch(getListingProvider(booking.listingId))
                              .when(
                                data: (listing) {
                                  return BookingCard(
                                    booking: booking,
                                    listing: listing,
                                  );
                                },
                                loading: () =>
                                    const CircularProgressIndicator(),
                                error: (error, stack) => ErrorText(
                                  error: error.toString(),
                                  stackTrace: stack.toString(),
                                ),
                              );
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => ErrorText(
                      error: error.toString(),
                      stackTrace: stack.toString(),
                    ),
                  ),

              const SizedBox(height: 16),

              // Wide button to show Show All Bookings
              Center(
                  child: FilledButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tour_outlined),
                    SizedBox(width: 10),
                    Text('Show All bookings'),
                  ],
                ),
              )),

              const SizedBox(height: 32),

              const Text(
                "My Activities",
                // bold and large
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Tasks (Due This Week)",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ref.watch(getTasksByUserIdProvider(user.uid)).when(
                    data: (tasks) {
                      if (tasks.isEmpty) {
                        return const Text("No tasks found");
                      }
                      return ListView.builder(
                        itemCount: tasks.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TodayTaskCard(task: task);
                        },
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (error, stack) => ErrorText(
                      error: error.toString(),
                      stackTrace: stack.toString(),
                    ),
                  ),

              const SizedBox(height: 16),

              Center(
                child: FilledButton(
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt_outlined),
                      SizedBox(width: 10),
                      Text('Show All Tasks'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Events Joined",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              ref.watch(getEventsByCoopIdProvider(user.currentCoop!)).when(
                    data: (events) {
                      return ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Card(
                            borderOnForeground: true,
                            child: ListTile(
                              onTap: () {},
                              title: Text(event.name),
                              // subtitle Start Date - End Date, format it to Feb 26, 2024
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${DateFormat('MMM dd, yyyy').format(event.startDate!)} - ${DateFormat('MMM dd, yyyy').format(event.endDate!)}",
                                  ),

                                  // Customer Name
                                  // Text(
                                  //   "Customer: ${booking.customerName}",
                                  // ),

                                  // // Guests
                                  // Text(
                                  //   "Guests: ${booking.guests}",
                                  // ),
                                ],
                              ),

                              // display Image in leading
                              leading: Image.network(
                                event.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => ErrorText(
                      error: error.toString(),
                      stackTrace: stack.toString(),
                    ),
                  ),

              const SizedBox(height: 32),

              const Text(
                "Coop Activities",
                // bold and large
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Announcements",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

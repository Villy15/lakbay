import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/announcement_card.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/features/tasks/widgets/today_task_card.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  late List<CoopAnnouncements> coopAnnouncements;

  @override
  void initState() {
    super.initState();
    coopAnnouncements = [
      CoopAnnouncements(
        title:
            'Cooperative Partners with [Coop_Name] Cooperative for Sustainable Tourism',
        description:
            'We\'re excited to announce a partnership with [Coop_Name] to promote eco-conscious travel practices. Get access to training resources, best practices, and potential funding.',
        timestamp: DateTime.now(),
        category: 'Sustainability',
      ),
    ];
  }

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
                  onPressed: () {
                    showModalBottomSheet<void>(
                      showDragHandle: true,
                      context: context,
                      builder: (BuildContext context) {
                        final user = ref.read(userProvider);
                        return Consumer(builder: (context, ref, _) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: DraggableScrollableSheet(
                              builder: (BuildContext context,
                                  ScrollController scrollController) {
                                return ref
                                    .watch(getBookingTasksByMemberId(user!.uid))
                                    .when(
                                        data:
                                            (List<BookingTask>? bookingTasks) {
                                          Map<String, List<BookingTask>>?
                                              bookingTasksSorted = {};
                                          // // Build your list items here
                                          if (bookingTasks != null) {
                                            for (BookingTask task
                                                in bookingTasks) {
                                              if (bookingTasksSorted
                                                  .containsKey(
                                                      task.listingName)) {
                                                bookingTasksSorted[
                                                        task.listingName]!
                                                    .add(task);
                                              } else {
                                                bookingTasksSorted[
                                                    task.listingName] = [task];
                                              }
                                            }
                                          }
                                          return bookingTasks != null
                                              ? SizedBox(
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      ...bookingTasksSorted
                                                          .entries
                                                          .map((entry) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    10,
                                                                color: Colors
                                                                    .grey[350],
                                                                child: Text(
                                                                  entry.key,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                  physics:
                                                                      const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (builder,
                                                                          index) {
                                                                    return ListTile(
                                                                      title:
                                                                          Text(
                                                                        entry
                                                                            .value[index]
                                                                            .name,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.circle),
                                                                    );
                                                                  })
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                    ],
                                                  ))
                                              : const Center(
                                                  child: Text(
                                                  "No Tasks Assigned",
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ));
                                        },
                                        error: (error, stackTrace) => ErrorText(
                                              error: error.toString(),
                                              stackTrace: '',
                                            ),
                                        loading: () =>
                                            const CircularProgressIndicator());
                              },
                              initialChildSize:
                                  0.5, // Initial size of the bottom sheet (0.5 means half the screen height)
                              minChildSize:
                                  0.25, // Minimum size of the bottom sheet
                              maxChildSize:
                                  0.9, // Maximum size of the bottom sheet
                              expand:
                                  true, // Whether the bottom sheet should be expandable
                            ),
                          );
                        });
                      },
                    );
                  },
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
                "New Announcements",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              ListView.separated(
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: coopAnnouncements.length,
                itemBuilder: (context, index) {
                  final announcement = coopAnnouncements[index];

                  return AnnouncementCard(
                    announcement: announcement,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

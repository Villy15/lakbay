import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/calendar/components/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/cooperatives/my_coop/announcements/add_announcement.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/announcement_card.dart';
import 'package:lakbay/features/cooperatives/my_coop/goals/add_goal.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_dvidends.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_fee.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/validate_coop.dart';
import 'package:lakbay/features/cooperatives/my_coop/voting/add_vote.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  @override
  void initState() {
    super.initState();
  }

  // Map of data for cards
  List<Map<String, dynamic>> buildCards(
      BuildContext context, CooperativeModel coop) {
    return [
      {
        'title': 'Add Your Cooperative\'s Listings',
        'subtitle':
            'Add your cooperative\'s listings to start accepting bookings',
        'icon': Icons.tour,
        'onTap': () => addListing(context, coop),
      },
      {
        'title': 'Add Your Cooperative\'s Events',
        'subtitle':
            'Add your cooperative\'s events to start accepting bookings',
        'icon': Icons.event,
        'onTap': () => addEvent(context, coop),
      },
      {
        'title': 'Add Your Cooperative\'s Announcements',
        'subtitle':
            'Add your cooperative\'s announcements to keep members informed',
        'icon': Icons.announcement,
        'onTap': () => addAnnouncement(context, coop),
      },
      // Add Goals
      {
        'title': 'Add Your Cooperative\'s Goals',
        'subtitle': 'Add your cooperative\'s goals to keep members informed',
        'icon': Icons.task,
        'onTap': () => addGoal(context, coop),
      },

      // Add Voting
      {
        'title': 'Add Your Cooperative\'s Voting',
        'subtitle': 'Add your cooperative\'s voting to keep members informed',
        'icon': Icons.how_to_vote,
        'onTap': () => addVote(context, coop),
      }
    ];
  }

  // Build coopCards
  List<Map<String, dynamic>> buildCoopCards(
      BuildContext context, CooperativeModel coop) {
    return [
      {
        'title': 'Validate your cooperative',
        'subtitle':
            'Submit files to validate your cooperative to the admin for approval of your coop',
        'icon': Icons.verified,
        'onTap': () => validateCooperative(context, coop),
      },
      {
        'title': 'Set Up Your Membership Application',
        'subtitle':
            'Set up your cooperative\'s membership application to start accepting members',
        'icon': Icons.app_registration,
        'onTap': () => manageMemberShipFee(context, coop),
      },
      {
        'title': 'Add Your Current Members',
        'subtitle':
            'Add your cooperative\'s members to at least 15 natural persons',
        'icon': Icons.people,
        'onTap': () => joinCoopCode(context, coop)
      },
      // Set up your membership application
    ];
  }

  // Build coopCards
  List<Map<String, dynamic>> buildCoopCards2(
      BuildContext context, CooperativeModel coop) {
    return [
      {
        'title': 'Setup member dividends',
        'subtitle':
            'Setup member dividends to start paying out to your members share',
        'icon': Icons.monetization_on,
        'onTap': () => manageMemberDividends(context, coop),
      },
      // Set up your committees for member contributions
      {
        'title': 'Set Up Your Committees',
        'subtitle':
            'Set up your cooperative\'s committees for members to contribute',
        'icon': Icons.group_work,
        'onTap': () => managerTools(context, coop),
      }
    ];
  }

  void managerTools(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'manager_tools',
      extra: coop,
    );
  }

  void addListing(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_listing',
      extra: coop,
    );
  }

  void addEvent(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_event',
      extra: coop,
    );
  }

  void addAnnouncement(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddAnnouncement(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void addGoal(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddGoal(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void addVote(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return AddVote(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void joinCoopCode(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'join_coop_code',
      extra: coop,
    );
  }

  void manageMemberShipFee(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageMemberFee(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void validateCooperative(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ValidateCoop(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void manageMemberDividends(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageMemberDividends(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (user!.isManager) {
      return ref.watch(getCooperativeProvider(user.currentCoop!)).when(
            data: (coop) {
              final cards = buildCards(context, coop);
              final coopCards = buildCoopCards(context, coop);
              final coopCards2 = buildCoopCards2(context, coop);

              return managerScaffold(
                  user, context, coop, cards, coopCards, coopCards2);
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => ErrorText(
              error: error.toString(),
              stackTrace: stack.toString(),
            ),
          );
    }

    return memberScaffold(user, context);
  }

  Scaffold managerScaffold(
      UserModel? user,
      BuildContext context,
      CooperativeModel coop,
      List<Map<String, dynamic>> cards,
      List<Map<String, dynamic>> coopCards,
      List<Map<String, dynamic>> coopCards2) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home', user: user),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Before we can proceed publishing your cooperative, please complete the following:',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 32),

              // Your Next Steps
              Text(
                "Validate and start setting up your cooperative members",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              // It's time to review your cooperative details
              SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: coopCards.length,
                  itemBuilder: (context, index) {
                    final card = coopCards[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              card['onTap']();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    card['icon'],
                                    size: 30,
                                  ),

                                  const SizedBox(height: 24),

                                  // Title
                                  Text(
                                    card['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Subtitle
                                  Text(
                                    card['subtitle'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Your Next Steps
              Text(
                "Setup member dividends",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              // It's time to review your cooperative details
              SizedBox(
                height: 300,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: coopCards2.length,
                  itemBuilder: (context, index) {
                    final card = coopCards2[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              card['onTap']();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    card['icon'],
                                    size: 30,
                                  ),

                                  const SizedBox(height: 24),

                                  // Title
                                  Text(
                                    card['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Subtitle
                                  Text(
                                    card['subtitle'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Your Next Steps
              Text(
                "Add Cooperative Activities",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              Text(
                'After completing the above steps, you can add your cooperative\'s listings, events, announcements, goals, and voting',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 16),

              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];

                  return ListTile(
                    onTap: () {
                      card['onTap']();
                    },
                    title: Text(card['title']),
                    subtitle: Text(card['subtitle']),
                    leading: Icon(card['icon']),
                  );
                },
              ),

              // Add your cooperative's listings
            ],
          ),
        ),
      ),
    );
  }

  Scaffold memberScaffold(UserModel? user, BuildContext context) {
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
                "Welcome,\n${user!.name}!",
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
              // ref.watch(getTasksByUserIdProvider(user.uid)).when(
              //       data: (tasks) {
              //         if (tasks.isEmpty) {
              //           return const Text("No tasks found");
              //         }
              //         return ListView.builder(
              //           itemCount: tasks.length,
              //           shrinkWrap: true,
              //           physics: const NeverScrollableScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             final task = tasks[index];
              //             return TodayTaskCard(task: task);
              //           },
              //         );
              //       },
              //       loading: () => const SizedBox.shrink(),
              //       error: (error, stack) => ErrorText(
              //         error: error.toString(),
              //         stackTrace: stack.toString(),
              //       ),
              //     ),

              const SizedBox(height: 16),

              Center(
                child: FilledButton(
                  onPressed: () {
                    context.push('/today/tasks').then((value) =>
                        ref.read(navBarVisibilityProvider.notifier).show());
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

              ref.watch(getAllAnnouncementsProvider(user.currentCoop!)).when(
                    data: (coopAnnouncements) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: coopAnnouncements.length,
                        itemBuilder: (context, index) {
                          final announcement = coopAnnouncements[index];

                          return AnnouncementCard(
                            announcement: announcement,
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: stackTrace.toString()),
                    loading: () => const Loader(),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

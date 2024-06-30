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
import 'package:lakbay/features/cooperatives/my_coop/goals/add_goal.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_dvidends.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_member_fee.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/manage_share_capital.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/validate_coop.dart';
import 'package:lakbay/features/cooperatives/my_coop/voting/add_vote.dart';
import 'package:lakbay/features/dashboard/manager/show_all_bookings.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
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
    // final user = ref.read(userProvider)!;

    // // Temp user to edit user's cooperativesJoined.role to manager by finding its currentCoop
    // final tempUser = user.copyWith(email: 'adrianvill07@gmail.com');

    // // Update the user's cooperativesJoined.role to manager
    // ref.read(usersControllerProvider.notifier).editProfile(
    //       context,
    //       user.uid,
    //       tempUser,
    //     );
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
      // Setup Member Share Capital
      {
        'title': 'Setup Member Share Capital',
        'subtitle':
            'Setup member share capital to start paying out to your members share',
        'icon': Icons.money,
        'onTap': () => manageShareCapital(context, coop),
      },
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

  void manageShareCapital(BuildContext context, CooperativeModel coop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ManageShareCapital(
          parentContext: context,
          coop: coop,
        );
      },
    );
  }

  void showAllBookins(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return ShowAllBookings(
          parentContext: context,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    if (user.isManager) {
      return ref.watch(getCooperativeProvider(user.currentCoop!)).when(
            data: (coop) {
              final cards = buildCards(context, coop);
              final coopCards = buildCoopCards(context, coop);
              final coopCards2 = buildCoopCards2(context, coop);

              return managerScaffold(
                  user, context, coop, cards, coopCards, coopCards2);
            },
            loading: () => const Loader(),
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
                  fontSize: 20,
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
                "Setup member contributions and dividends",
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
              // 2 Carsd Row for Quick Actions to Announcements and Events
              Text(
                "Welcome, ${user!.name}!",
                // bold and large
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                // Center
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    // Width / 2
                    height: MediaQuery.sizeOf(context).height / 5.5,
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: announcementCard(),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    // Width / 2
                    height: MediaQuery.sizeOf(context).height / 5.5,
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: voteCard(),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),

              Row(
                // Center
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      // Width / 2
                      height: MediaQuery.sizeOf(context).height / 5.5,
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: goalCard()),
                  const SizedBox(width: 8),
                  SizedBox(
                    // Width / 2
                    height: MediaQuery.sizeOf(context).height / 5.5,
                    width: MediaQuery.of(context).size.width / 2 - 24,
                    child: contributeCard(),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                "Upcoming bookings",
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

                      // Take the first 3 bookings
                      if (updatedBookings.length > 3) {
                        updatedBookings.length = 3;
                      }

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
                                loading: () => const SizedBox.shrink(),
                                error: (error, stack) => ErrorText(
                                  error: error.toString(),
                                  stackTrace: stack.toString(),
                                ),
                              );
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

              // Wide button to show Show All Bookings
              Center(
                  child: FilledButton(
                onPressed: () {
                  showAllBookins(context);
                },
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
                "Booking Tasks ",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              ref.watch(getBookingTasksByMemberId(user.uid)).when(
                    data: (tasks) {
                      // Add tasks to if task is also a contributor ID
                      tasks.addAll(
                        ref
                                .watch(getBookingTasksByContributorId(user.uid))
                                .asData
                                ?.value
                                .toList() ??
                            [],
                      );

                      if (tasks.isEmpty) {
                        return const Text("No tasks found");
                      }

                      // Sort the tasks according to its booking's start date in ascending order
                      // But the tasks doesn't have the booking's start date so get it from the booking
                      tasks.sort((a, b) {
                        final bookingA = ref
                            .watch(getBookingByIdProvider(
                                (a.listingId!, a.bookingId!)))
                            .asData
                            ?.value;

                        final bookingB = ref
                            .watch(getBookingByIdProvider(
                                (b.listingId!, b.bookingId!)))
                            .asData
                            ?.value;

                        if (bookingA == null || bookingB == null) {
                          return 0;
                        }

                        return bookingA.startDate!
                            .compareTo(bookingB.startDate!);
                      });
                      final taskBookingsListings = tasks
                          .map((task) {
                            if (task.listingId == null ||
                                task.bookingId == null) {
                              return null;
                            }

                            final booking = ref
                                .watch(getBookingByIdProvider(
                                    (task.listingId!, task.bookingId!)))
                                .asData
                                ?.value;
                            final listing = ref
                                .watch(getListingProvider(task.listingId!))
                                .asData
                                ?.value;

                            if (booking == null || listing == null) {
                              return null;
                            }

                            return TaskBookingListing(
                              task: task,
                              booking: booking,
                              listing: listing,
                            );
                          })
                          .where((item) => item != null)
                          .toList();

                      taskBookingsListings.sort((a, b) {
                        if (a?.booking.startDate == null ||
                            b?.booking.startDate == null) {
                          return 0;
                        }

                        return a!.booking.startDate!
                            .compareTo(b!.booking.startDate!);
                      });

                      // Make the lenght of the list to be 3
                      if (taskBookingsListings.length > 3) {
                        taskBookingsListings.length = 3;
                      }

                      return ListView.builder(
                        itemCount: taskBookingsListings.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final task = taskBookingsListings[index];

                          return Card(
                            borderOnForeground: true,
                            child: ListTile(
                              onTap: () {
                                context.push(
                                  '/market/${task.booking.category}/booking_details',
                                  extra: {
                                    'booking': task.booking,
                                    'listing': task.listing,
                                  },
                                ).then((value) => ref
                                    .read(navBarVisibilityProvider.notifier)
                                    .show());
                              },
                              title: Text(task!.task.name),
                              // subtitle Start Date - End Date, format it to Feb 26, 2024
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ref
                                      .watch(getBookingByIdProvider((
                                        task.task.listingId!,
                                        task.task.bookingId!
                                      )))
                                      .maybeWhen(
                                        data: (booking) {
                                          return Text(
                                            "${DateFormat('MMM dd, yyyy').format(booking.startDate!)} - ${DateFormat('MMM dd, yyyy').format(booking.endDate!)}",
                                          );
                                        },
                                        orElse: () => const Text("Test"),
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
                              trailing: Text(
                                task.task.status,
                              ),

                              // display Image in leading
                              leading: Image.network(
                                task.listing.images!.first.url!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
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
                      if (events.isEmpty) {
                        return const Text("No events found");
                      }

                      // Filter events that you have joined
                      events = events
                          .where((event) => event.members.contains(user.uid))
                          .toList();

                      // Make the lenght of the list to be 3
                      if (events.length > 3) {
                        events.length = 3;
                      }

                      return ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return Card(
                            borderOnForeground: true,
                            child: ListTile(
                              onTap: () {
                                context.push("/my_coop/event/${event.uid}");
                              },
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
                    loading: () => const Loader(),
                    error: (error, stack) => ErrorText(
                      error: error.toString(),
                      stackTrace: stack.toString(),
                    ),
                  ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Card contributeCard() {
    return Card(
      surfaceTintColor: Colors.lightBlue.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context
              .go('/my_coop/listings/${ref.watch(userProvider)!.currentCoop}');
          ref.read(bottomNavBarProvider.notifier).setPosition(2);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contributions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // 2 new announcements this week
              ref
                  .watch(getAllBookingsByCoopIdProvider(
                      ref.watch(userProvider)!.currentCoop!))
                  .maybeWhen(
                      orElse: () => const Text("No contributions found"),
                      data: (bookings) {
                        int totalTasksNeedContributions = 0;

                        for (var booking in bookings) {
                          ref
                              .watch(getBookingTasksByBookingId(
                                  (booking.listingId, booking.id!)))
                              .whenData((tasks) {
                            for (var task in tasks) {
                              // Check if task is open for contributions
                              if (task.openContribution) {
                                totalTasksNeedContributions++;
                              }
                            }
                          });
                        }

                        return Text(
                          '$totalTasksNeedContributions tasks need contributions',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }

  int getNumberOfTasksThatNeedContributions(List<ListingBookings> bookings) {
    int totalTasksNeedContributions = 0;

    for (var booking in bookings) {
      totalTasksNeedContributions += booking.tasksNeedContributions;
    }

    return totalTasksNeedContributions;
  }

  Card goalCard() {
    return Card(
      surfaceTintColor: Colors.green.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context.go('/my_coop/${ref.watch(userProvider)!.currentCoop}');
          ref.read(bottomNavBarProvider.notifier).setPosition(3);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Goals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // 2 new announcements this week
              ref
                  .watch(getAllGoalsProvider(
                      ref.watch(userProvider)!.currentCoop!))
                  .maybeWhen(
                      orElse: () => const Text("No goals found"),
                      data: (goals) {
                        return Text(
                          '${goals.length} goals to achieve for this month',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Card voteCard() {
    return Card(
      surfaceTintColor: Colors.blueAccent.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context.go('/my_coop/${ref.watch(userProvider)!.currentCoop}');
          ref.read(bottomNavBarProvider.notifier).setPosition(3);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vote Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ref
                  .watch(getAllVotesProvider(
                      ref.watch(userProvider)!.currentCoop!))
                  .maybeWhen(
                      orElse: () => const Text("No votes found"),
                      data: (votes) {
                        return Text(
                          '${votes.length} candidates to vote for the next election',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }

  Card announcementCard() {
    return Card(
      surfaceTintColor: Colors.deepOrange.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          context.go('/my_coop/${ref.watch(userProvider)!.currentCoop}');
          ref.read(bottomNavBarProvider.notifier).setPosition(3);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ref
                    .watch(getAllAnnouncementsProvider(
                        ref.watch(userProvider)!.currentCoop!))
                    .maybeWhen(
                      orElse: () => const Text("No announcements found"),
                      data: (announcements) {
                        return Text(
                          '${announcements.length} new announcements this week',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskBookingListing {
  final BookingTask task;
  final ListingBookings booking;
  final ListingModel listing;

  TaskBookingListing({
    required this.task,
    required this.booking,
    required this.listing,
  });
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/bookings/widgets/booking_card.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/components/timeline_card.dart';
import 'package:lakbay/features/trips/plan/components/timeline_tile.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class TripDetailsPlan extends ConsumerStatefulWidget {
  final String planUid;
  const TripDetailsPlan({super.key, required this.planUid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TripDetailsPlanState();
}

class _TripDetailsPlanState extends ConsumerState<TripDetailsPlan> {
  // ignore: prefer_final_fields
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  onTapInfo(PlanModel plan) {
    context.push('/trips/info', extra: plan);
  }

  void onTapActivity(
    DateTime date,
    PlanModel plan,
  ) {
    ref.read(selectedDateProvider.notifier).setSelectedDate(date);
    ref.read(planLocationProvider.notifier).setLocation(plan.location);
    ref.read(planStartDateProvider.notifier).setStartDate(plan.startDate!);
    ref.read(planEndDateProvider.notifier).setEndDate(plan.endDate!);
    ref.read(currentPlanIdProvider.notifier).setCurrentPlanId(plan.uid!);
    ref.read(currentPlanGuestsProvider.notifier).setCurrentGuests(plan.guests);
    context.push('/trips/add_activity', extra: plan);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            context.pop();
            ref.read(navBarVisibilityProvider.notifier).show();
          },
          child: ref.watch(getPlanByUidProvider(widget.planUid)).when(
                data: (plan) {
                  return buildScaffold(context, plan);
                },
                error: (error, stackTrace) => ErrorText(
                    error: error.toString(), stackTrace: stackTrace.toString()),
                loading: () => const Loader(),
              ),
        ));
  }

  Scaffold buildScaffold(BuildContext context, PlanModel plan) {
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: _appBar(context, plan),
      body: TabBarView(
        children: [
          // Days Plan
          daysPlan(plan),
          // TripsDaysPlan(),

          // Reservations
          ref.watch(getAllBookingsByCustomerIdProvider(user!.uid)).when(
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No Bookings Yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      return ref
                          .watch(getListingProvider(booking.listingId))
                          .when(
                            data: (listing) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: BookingCard(
                                  booking: booking,
                                  listing: listing,
                                ),
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                              stackTrace: '',
                            ),
                            loading: () => const Loader(),
                          );
                    },
                  );
                },
                error: (error, stackTrace) => ErrorText(
                    error: error.toString(), stackTrace: stackTrace.toString()),
                loading: () => const Loader(),
              )
        ],
      ),
    );
  }

  Widget daysPlan(PlanModel plan) {
    final thisDay = DateTime.now().add(Duration(days: _selectedDayIndex));
// Filter and sort the activities list first
    var filteredAndSortedActivities = plan.activities!.where((activity) {
      if (activity.category == "Accommodation") {
        return (activity.startTime!.day == thisDay.day) ||
            (activity.endTime!.day == thisDay.day);
      }
      return activity.dateTime!.day == thisDay.day;
    }).toList(); // Convert to List for sorting

    debugPrint("filteredList: $filteredAndSortedActivities");

    // Sort the list in-place
    filteredAndSortedActivities.sort((a, b) {
      // Check if either activity does not have a startTime
      var aStartTime = a.startTime;
      var bStartTime = b.startTime;
      if (aStartTime == null && bStartTime == null) return 0;
      if (aStartTime == null) return 1;
      if (bStartTime == null) return -1;
      // If both have a startTime, compare them
      return aStartTime.compareTo(bStartTime);
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          rowDays(plan),
          const SizedBox(height: 16.0),
          Column(
            children: [
              ...filteredAndSortedActivities.map(
                (activity) => TimelineTile(
                  isActive: true,
                  title: TimelineCard(
                      plan: plan, activity: activity, thisDay: thisDay),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              children: [
                const SizedBox(width: 16.0),
                const Icon(Icons.add),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {
                    onTapActivity(
                      thisDay,
                      plan,
                    );
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    padding: const EdgeInsets.all(6),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: SizedBox(
                        height: 70,
                        // max width
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Center(
                          child: Text(
                            'Add Activity',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox rowDays(PlanModel plan) {
    int itemCount = plan.endDate!.difference(plan.startDate!).inDays + 1;
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount + 1,
        itemBuilder: (context, index) {
          if (index < itemCount) {
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;

                  debugPrint('Selected Day Index: $_selectedDayIndex');
                });
                // Add any other logic you want to execute when a day is tapped
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 3.0,
                      color: _selectedDayIndex ==
                              index // Check if the day is selected
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7) // Selected indicator color
                          : Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.05), // No indicator color
                    ),
                  ),
                ),
                width: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Day ${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(
                        plan.startDate!.add(
                          Duration(days: index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: () => (),
              child: const SizedBox(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add), // Plus icon
                    Text("Add Day"),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  PreferredSize _appBar(BuildContext context, PlanModel plan) {
    List<Widget> tabs = [
      const SizedBox(
        width: 100.0,
        child: Tab(
          // icon: Icon(Icons.travel_explore),
          child: Text('Days Plan'),
        ),
      ),
      const SizedBox(
        width: 100.0,
        child: Tab(
          // icon: Icon(Icons.location_on),
          child: Text('Reservations'),
        ),
      ),
    ];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 40),
      child: AppBar(
        title: const Text(
          'Trip Details Plan',
        ),
        actions: [
          // Details
          IconButton(
            onPressed: () {
              onTapInfo(plan);
            },
            icon: const Icon(Icons.info),
          ),
        ],
        // Add icon on the right side of the app bar of a person,
        bottom: TabBar(
          tabs: tabs,
        ),
      ),
    );
  }
}

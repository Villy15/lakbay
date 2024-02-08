import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/plan/components/timeline_card.dart';
import 'package:lakbay/features/plan/components/timeline_tile.dart';
import 'package:lakbay/features/plan/components/trip_card.dart';
import 'package:lakbay/features/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class TripDetailsPlan extends ConsumerStatefulWidget {
  final PlanModel plan;
  const TripDetailsPlan({super.key, required this.plan});

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
        child: Scaffold(
          appBar: _appBar(context),
          body: TabBarView(
            children: [
              // Days Plan
              daysPlan(),
              // TripsDaysPlan(),

              // Reservations
              ref.watch(getAllListingsProvider).when(
                    data: (listings) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 12.0,
                        ),
                        shrinkWrap: true,
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          final listing = listings[index];
                          return TripCard(
                            listing: listing,
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

  void onTapActivity(DateTime date) {
    ref.read(selectedDateProvider.notifier).setSelectedDate(date);
    context.push('/plan/add_activity');
  }

  Widget daysPlan() {
    final listPlans = ref.watch(planModelProvider);
    final thisDay = DateTime.now().add(Duration(days: _selectedDayIndex));

    return Column(
      children: [
        rowDays(),
        const SizedBox(height: 16.0),
        ...listPlans.where((plan) => plan.isSameDate(thisDay)).map(
              (plan) => Column(
                children: [
                  ...plan.activities!.map((activity) => TimelineTile(
                        leading: Text(
                          DateFormat('hh:mm a').format(activity.startTime!),
                        ),
                        isActive: true,
                        title: TimelineCard(
                          title: activity.title!,
                          subtitle: activity.description!,
                        ),
                      )),
                ],
              ),
            ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            children: [
              const SizedBox(width: 16.0),
              const Icon(Icons.add),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: () {
                  onTapActivity(
                    thisDay,
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
    );
  }

  SizedBox rowDays() {
    int itemCount =
        widget.plan.endDate!.difference(widget.plan.startDate!).inDays + 1;
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
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
                      widget.plan.startDate!.add(
                        Duration(days: index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
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
        // Add icon on the right side of the app bar of a person,
        bottom: TabBar(
          tabs: tabs,
        ),
      ),
    );
  }
}

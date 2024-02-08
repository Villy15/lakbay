import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/plan/components/timeline_card.dart';
import 'package:lakbay/features/plan/components/timeline_tile.dart';
import 'package:lakbay/features/plan/components/trip_card.dart';
import 'package:lakbay/features/plan/plan_providers.dart';

class PlanPage extends ConsumerStatefulWidget {
  const PlanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  // Fields

  @override
  Widget build(BuildContext context) {
    debugPrint("file name: plan_page.dart");
    final user = ref.watch(userProvider);
    final planLocation = ref.watch(planLocationProvider);
    final planStartDate = ref.watch(planStartDateProvider);
    final planEndDate = ref.watch(planEndDateProvider);

    final listPlans = ref.watch(planModelProvider);

    if (user?.isCoopView == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/today');
      });
    }

    void onTapDate() {
      context.push('/plan/calendar');
    }

    void onTapLocation() {
      context.push('/plan/location');
    }

    void onTapActivity(DateTime date) {
      ref.read(selectedDateProvider.notifier).setSelectedDate(date);
      context.push('/plan/add_activity');
    }

    List<Widget> generateDays(DateTime start, DateTime end) {
      List<Widget> days = [];
      for (int i = 0; i <= end.difference(start).inDays; i++) {
        DateTime thisDay = start.add(Duration(days: i));
        days.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Day ${i + 1} - ${DateFormat('EEEE').format(thisDay)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(),
              ),
              // const TimelineTile(
              //   leading: Text('01:00 PM'),
              //   isActive: true,
              //   title: TimelineCard(
              //     title: 'Hotel Iwahori',
              //
              // subtitle: 'Accommodation',
              //   ),
              // ),

              // Check the list of plans and display the activities equal to the date
              ...listPlans
                  .where((plan) => plan.isSameDate(thisDay))
                  .map((plan) => Column(
                        children: [
                          ...plan.activities!.map((activity) => TimelineTile(
                                leading: Text(
                                  DateFormat('hh:mm a')
                                      .format(activity.startTime!),
                                ),
                                isActive: true,
                                title: TimelineCard(
                                  title: activity.title!,
                                  subtitle: activity.description!,
                                ),
                              )),
                        ],
                      )),

              // Add  an option to add a new activity
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 16.0),
                    const Icon(Icons.add),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        onTapActivity(
                          thisDay,
                        );
                      },
                      child: const Text('Add Activity'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8.0),
            ],
          ),
        );
      }
      return days;
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Tara! Lakbay!', user: user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ListTile Location
            // If planLocation is not null and planStartDate is not null and planEndDate is not null

            planLocation == null || planStartDate == null || planEndDate == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: heading(
                      "Let's plan your trip!",
                      "Choose a location and date to start",
                      context,
                    ),
                  )
                : const SizedBox(),

            ListTile(
              title: const Text('Location'),
              leading: const Icon(Icons.location_on_outlined),
              subtitle: Text(
                planLocation ?? 'Select a location',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                onTapLocation();
              },
            ),

            // ListTile Date
            ListTile(
              title: const Text('Date'),
              leading: const Icon(Icons.calendar_today_outlined),
              subtitle: Text(planStartDate == null || planEndDate == null
                  ? 'Select a date'
                  : '${DateFormat.yMMMMd().format(planStartDate)} - ${DateFormat.yMMMMd().format(planEndDate)}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                onTapDate();
              },
            ),

            // Row with budget and number of travelers
            ListTile(
              title: const Text('Budget'),
              leading: const Icon(Icons.attach_money_outlined),
              subtitle: const Text('₱ 10,000'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),

            // Heading Day 01 - Day (Monday)
            if (planStartDate != null && planEndDate != null)
              ...generateDays(planStartDate, planEndDate),

            // planLocation == null && planStartDate == null && planEndDate == null
            //     ? showRecommendations(context)
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Column showRecommendations(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: heading(
            // TODO 1: Change the title and subtitle
            //  "Already reserved/booked a listing?",
            // "Choose a listing and let's start from there",
            //  "Already reserved/booked a listing?",
            // "Choose a listing and let's start from there",
            "Want to check out our listings?",
            "Choose a listing and let's start from there",
            context,
          ),
        ),
        ref.watch(getAllListingsProvider).when(
              data: (listings) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 12.0,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final listing = listings[index];
                      return TripCard(
                        listing: listing,
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                  error: error.toString(), stackTrace: stackTrace.toString()),
              loading: () => const Loader(),
            )
      ],
    );
  }

  Align heading(String title, String subtitle, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}

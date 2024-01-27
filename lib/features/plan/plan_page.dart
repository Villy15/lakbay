import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/plan/components/timeline_card.dart';
import 'package:lakbay/features/plan/components/timeline_tile.dart';
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
    final user = ref.watch(userProvider);
    final planLocation = ref.watch(planLocationProvider);
    final planStartDate = ref.watch(planStartDateProvider);
    final planEndDate = ref.watch(planEndDateProvider);

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
              const TimelineTile(
                leading: Text('01:00 PM'),
                isActive: true,
                title: TimelineCard(
                  title: 'Hotel Iwahori',
                  subtitle: 'Accommodation',
                ),
              ),
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
      appBar: CustomAppBar(title: 'Plan', user: user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ListTile Location
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

            // Heading Day 01 - Day (Monday)
            if (planStartDate != null && planEndDate != null)
              ...generateDays(planStartDate, planEndDate),
          ],
        ),
      ),
    );
  }
}

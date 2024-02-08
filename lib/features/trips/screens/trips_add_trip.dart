import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/plan/plan_providers.dart';

class TripsAddTrip extends ConsumerStatefulWidget {
  const TripsAddTrip({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripsAddTripState();
}

class _TripsAddTripState extends ConsumerState<TripsAddTrip> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void onTapDate() {
    context.push('/plan/calendar');
  }

  void onTapLocation() {
    context.push('/plan/location');
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      context.push('/trips');
    }
  }

  @override
  Widget build(BuildContext context) {
    final planLocation = ref.watch(planLocationProvider);
    final planStartDate = ref.watch(planStartDateProvider);
    final planEndDate = ref.watch(planEndDateProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Trip'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: heading(
                    "Let's plan your trip!",
                    "Choose a location and date to start",
                    context,
                  ),
                ),

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

                // Number of people
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.people,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Number of people',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                // Budget per person
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.money_sharp,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Budget per person',
                      prefixText: '₱ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                // Trip Name
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.card_travel_outlined,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Trip Name*',
                      helperText: '*required',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),

                // Text with Travel With?
                // travelWith(context),

                // Filled button that says Start my new Tri
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FilledButton(
                    onPressed: () {
                      onSubmit();
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Start my new Trip',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column travelWith(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Travel with?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Adjust as needed
                      ),
                    ),
                    child: const Text('Solo'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5.0), // Adjust as needed
                      ),
                    ),
                    child: const Text('Party'),
                  ),
                ),
              ),
            ],
          ),
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

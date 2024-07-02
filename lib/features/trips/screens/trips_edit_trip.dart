import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class TripsEditTrip extends ConsumerStatefulWidget {
  final PlanModel plan;
  const TripsEditTrip({super.key, required this.plan});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripsEditTripState();
}

class _TripsEditTripState extends ConsumerState<TripsEditTrip> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form fields
  final _numOfGuestsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    _numOfGuestsController.text = widget.plan.guests.toString();
    _budgetController.text = widget.plan.budget.toString();
    _nameController.text = widget.plan.name;
  }

  void onTapDate() {
    context.push('/plan/calendar');
  }

  void onTapLocation() {
    context.push('/plan/location');
  }

  void onSubmit() {
    if (formKey.currentState!.validate()) {
      final location = ref.read(planLocationProvider);
      final startDate = ref.read(planStartDateProvider);
      final endDate = ref.read(planEndDateProvider);

      var updatedPlan = widget.plan.copyWith(
        location: location!,
        name: _nameController.text,
        budget: num.parse(_budgetController.text),
        guests: num.parse(_numOfGuestsController.text),
        startDate: startDate,
        endDate: endDate,
      );

      ref
          .read(plansControllerProvider.notifier)
          .updatePlan(updatedPlan, context);
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
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
        
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Trip'),
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
                    controller: _numOfGuestsController,
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
                    controller: _budgetController,
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
                    controller: _nameController,
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

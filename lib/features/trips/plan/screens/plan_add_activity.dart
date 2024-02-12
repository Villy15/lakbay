import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/components/trip_card.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class PlanAddActivity extends ConsumerStatefulWidget {
  const PlanAddActivity({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanAddActivityState();
}

class _PlanAddActivityState extends ConsumerState<PlanAddActivity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = ref.watch(userProvider);
      final planLocation = ref.watch(planLocationProvider);
      final planStartDate = ref.watch(planStartDateProvider);
      final planEndDate = ref.watch(planEndDateProvider);
      final selectedDate = ref.watch(selectedDateProvider);

      var plan = PlanModel(
        name: planLocation ?? '',
        budget: 0,
        guests: 0,
        location: planLocation ?? '',
        startDate: planStartDate,
        endDate: planEndDate,
        userId: user!.uid,
        activities: [
          PlanActivity(
            title: _nameController.text,
            description: _descriptionController.text,
            startTime: DateTime(
              selectedDate!.year,
              selectedDate.month,
              selectedDate.day,
              _startTime.hour,
              _startTime.minute,
            ),
            endTime: DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              _endTime.hour,
              _endTime.minute,
            ),
            dateTime: selectedDate,
          )
        ],
      );

      ref.read(planModelProvider.notifier).addPlan(plan, context);
      // ref.watch(plansControllerProvider.notifier).addPlan(plan, context);
    }
  }

  void onChooseCategory() {
    context.push('/plan/add_activity/search_listing');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("file name: plan_add_activity.dart");
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Activity'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              TextButton(
                onPressed: () {
                  context.pop();
                  ();
                },
                child: const Text('Cancel'),
              ),

              // Save Button
              TextButton(
                onPressed: () {
                  onSave();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  heading(
                    "Activity outside of our listings?",
                    "Add manually here!",
                    context,
                  ),
                  // Name
                  activityName(),

                  const SizedBox(height: 10),

                  // Description
                  activityDesc(),

                  const SizedBox(height: 10),

                  startAndEndTime(context),

                  const SizedBox(height: 10),

                  const Divider(),
                  const SizedBox(height: 10),

                  // Add  an option to add a new activity
                  heading(
                    "Activity from our listings?",
                    "Choose from our listings!",
                    context,
                  ),

                  chooseCategory(context),

                  const SizedBox(height: 10),

                  heading(
                    "Activity from your reservations/bookings?",
                    "Choose from your reservations/bookings!",
                    context,
                  ),

                  ref.watch(getAllListingsProvider).when(
                        data: (listings) {
                          return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
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
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                            stackTrace: stackTrace.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseCategory(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {'name': 'Accommodation', 'icon': Icons.hotel_outlined},
      {'name': 'Transport', 'icon': Icons.directions_bus_outlined},
      {'name': 'Tour', 'icon': Icons.map_outlined},
      {'name': 'Food', 'icon': Icons.restaurant_outlined},
      {'name': 'Entertainment', 'icon': Icons.movie_creation_outlined},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            switch (category['name']) {
              case 'Accommodation':
                context.push('/plan/add_activity/search_listing/accommodation');
                break;

              case 'Food':
                context.push('/plan/add_activity/search_listing/food');
                break;

              case 'Entertainment':
                context.push('/plan/add_activity/search_listing/entertainment');

                break;

              case 'Transport':
                context.push('/plan/add_activity/search_listing/transport');

                break;

              case 'Tour':
                context.push('/plan/add_activity/search_listing/tour');

                break;
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Icon(
                  category['icon'],
                  size: 35.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                category['name'],
                style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
        );
      },
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

  TextFormField activityDesc() {
    return TextFormField(
      controller: _descriptionController,
      // minLines: 3,
      maxLines: null,
      decoration: const InputDecoration(
        icon: Icon(Icons.description),
        border: OutlineInputBorder(),
        labelText: 'Description',
        helperText: 'optional',
        // alignLabelWithHint: true,
      ),
    );
  }

  TextFormField activityName() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.person,
        ),
        border: OutlineInputBorder(),
        labelText: 'Activity Name*',
        helperText: '*required',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Row startAndEndTime(BuildContext context) {
    return Row(
      children: [
        // Start Time
        Flexible(
          flex: 1,
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time, color: Colors.transparent),
              suffixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              labelText: 'Start Time*',
              helperText: '*required',
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _startTime,
              );
              if (time != null) {
                setState(() {
                  _startTime = time;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('hh:mm a').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _startTime.hour,
                _startTime.minute,
              )),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
          ),
        ),

        const SizedBox(width: 10),

        // Time
        Flexible(
          flex: 1,
          child: TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.access_time, color: Colors.transparent),
              suffixIcon: Icon(Icons.access_time_outlined),
              border: OutlineInputBorder(),
              labelText: 'End Time*',
              helperText: '*required',
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _endTime,
              );
              if (time != null) {
                setState(() {
                  _endTime = time;
                });
              }
            },
            controller: TextEditingController(
              text: DateFormat('hh:mm a').format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                _endTime.hour,
                _endTime.minute,
              )),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a time';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/plan_model.dart';

class TripsAddActivity extends ConsumerStatefulWidget {
  final PlanModel plan;
  const TripsAddActivity({super.key, required this.plan});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TripsAddActivityState();
}

class _TripsAddActivityState extends ConsumerState<TripsAddActivity> {
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

  @override
  Widget build(BuildContext context) {
    debugPrint("file name: trips_add_activity.dart");
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Add Activity'),
        ),
        // bottomNavigationBar: BottomAppBar(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       // Cancel Button
        //       TextButton(
        //         onPressed: () {
        //           context.pop();
        //           ();
        //         },
        //         child: const Text('Cancel'),
        //       ),

        //       // Save Button
        //       TextButton(
        //         onPressed: () {
        //           onSave();
        //         },
        //         child: const Text('Submit'),
        //       ),
        //     ],
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // heading(
                  //   "Activity outside of our listings?",
                  //   "Add manually here!",
                  //   context,
                  // ),
                  // // Name
                  // activityName(),

                  // const SizedBox(height: 10),

                  // // Description
                  // activityDesc(),

                  // const SizedBox(height: 10),

                  // startAndEndTime(context),

                  // const SizedBox(height: 10),

                  // const Divider(),
                  // const SizedBox(height: 10),

                  // Add  an option to add a new activity
                  heading(
                    "Activity from our listings?",
                    "Choose a category to search for listings!",
                    context,
                  ),

                  chooseCategory(context),

                  // const SizedBox(height: 10),

                  // heading(
                  //   "Activity from your reservations/bookings?",
                  //   "Choose from your reservations/bookings!",
                  //   context,
                  // ),

                  // ref.watch(getAllListingsProvider).when(
                  //       data: (listings) {
                  //         return ListView.separated(
                  //           separatorBuilder: (context, index) =>
                  //               const SizedBox(
                  //             height: 12.0,
                  //           ),
                  //           physics: const NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           itemCount: listings.length,
                  //           itemBuilder: (context, index) {
                  //             final listing = listings[index];
                  //             return TripCard(
                  //               listing: listing,
                  //             );
                  //           },
                  //         );
                  //       },
                  //       error: (error, stackTrace) => ErrorText(
                  //           error: error.toString(),
                  //           stackTrace: stackTrace.toString()),
                  //       loading: () => const Loader(),
                  //     ),
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
      // {'name': 'Tour', 'icon': Icons.map_outlined},
      {'name': 'Food', 'icon': Icons.restaurant_outlined},
      {'name': 'Entertainment', 'icon': Icons.movie_creation_outlined},
    ];

    return Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisExtent: 120,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () async {
                switch (category['name']) {
                  case 'Accommodation':
                    final planStartDate = ref.read(planStartDateProvider);
                    final today = Timestamp.fromDate(planStartDate!);
                    final query = FirebaseFirestore.instance
                        .collectionGroup(
                            'bookings') // Perform collection group query for 'bookings'
                        .where('category', isEqualTo: category["name"])
                        .where('bookingStatus', isEqualTo: "Reserved")
                        .where('startDate', isGreaterThan: today);
                    final bookings = await ref
                        .watch(getBookingsByPropertiesProvider((query)).future);
                    final queryForListings = FirebaseFirestore.instance
                        .collection("listings")
                        .where('category', isEqualTo: category["name"]);
                    final listings = await ref.watch(
                        getListingsByPropertiesProvider(queryForListings)
                            .future);
                    debugPrint("booking:s ${bookings.length}");
                    if (context.mounted) {
                      context.push('/plan/add_activity/search_listing', extra: {
                        'bookings': bookings,
                        'listings': listings,
                        'category': category["name"],
                      });
                    }
                    break;

                  case 'Food':
                    final query = FirebaseFirestore.instance
                        .collection("listings")
                        .where('category', isEqualTo: category["name"]);
                    final listings = await ref
                        .watch(getListingsByPropertiesProvider(query).future);
                    if (context.mounted) {
                      context.push('/plan/add_activity/search_listing', extra: {
                        'listings': listings,
                        'category': category["name"]
                      });
                    }
                    break;

                  case 'Entertainment':
                    final query = FirebaseFirestore.instance
                        .collection("listings")
                        .where('category', isEqualTo: category["name"]);
                    final listings = await ref
                        .watch(getListingsByPropertiesProvider(query).future);
                    if (context.mounted) {
                      context.push('/plan/add_activity/search_listing', extra: {
                        'listings': listings,
                        'category': category["name"]
                      });
                    }
                    break;

                  case 'Transport':
                    final query = FirebaseFirestore.instance
                        .collection('listings')
                        .where('category', isEqualTo: category["name"]);
                    final listings = await ref
                        .watch(getListingsByPropertiesProvider(query).future);
                    if (context.mounted) {
                      context.push('/plan/add_activity/search_listing', extra: {
                        'listings': listings,
                        'category': category["name"]
                      });
                    }
                    break;

                  // case 'Tour':
                  //   final query = FirebaseFirestore.instance
                  //       .collection('listings')
                  //       .where('category', isEqualTo: category["name"]);
                  //   final listings = await ref
                  //       .watch(getListingsByPropertiesProvider(query).future);
                  //   if (context.mounted) {
                  //     context.push('/plan/add_activity/search_listing', extra: {
                  //       'listings': listings,
                  //       'category': category["name"]
                  //     });
                  //   }
                  //   break;
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
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 20,
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height / 8,
          child: FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController titleController =
                      TextEditingController();
                  TextEditingController categoryController =
                      TextEditingController();
                  TextEditingController startTimeController =
                      TextEditingController();
                  TextEditingController endTimeController =
                      TextEditingController();

                  TimeOfDay thisStartTime = TimeOfDay.now();
                  TimeOfDay thisEndTime = TimeOfDay.now();

                  return StatefulBuilder(
                    builder: (context, setActivity) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Manually Add Activity'),
                        content: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: 'Activity Title',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // Keep the label always visible
                                hintText: "",
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: categoryController.text.isEmpty
                                  ? null
                                  : categoryController.text,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              hint: const Text('Select an activity'),
                              items: [
                                "Accommodation",
                                "Transport",
                                "Food",
                                "Entertainment"
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  categoryController.text = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: startTimeController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: "Start Time",
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always, // Keep the label always visible
                                      hintText: "11:30",
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: thisStartTime,
                                        initialEntryMode:
                                            TimePickerEntryMode.inputOnly,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        false),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTime != null) {
                                        setActivity(() {
                                          startTimeController.text =
                                              pickedTime.format(context);
                                          thisStartTime = pickedTime;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: endTimeController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: 'End Time',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always, // Keep the label always visible
                                      hintText: "2:30",
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: thisEndTime,
                                        initialEntryMode:
                                            TimePickerEntryMode.inputOnly,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        false),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (pickedTime != null) {
                                        setActivity(() {
                                          endTimeController.text =
                                              pickedTime.format(context);
                                          thisEndTime = pickedTime;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("Close")),
                          TextButton(
                              onPressed: () {
                                var thisSelectedDate =
                                    ref.watch(selectedDateProvider);
                                DateTime formattedStartTime = DateTime(
                                  thisSelectedDate!.year,
                                  thisSelectedDate.month,
                                  thisSelectedDate.day,
                                  thisStartTime.hour,
                                  thisStartTime.minute,
                                );
                                DateTime formattedEndTime = DateTime(
                                  thisSelectedDate.year,
                                  thisSelectedDate.month,
                                  categoryController.text == "Accommodation"
                                      ? thisSelectedDate.day + 1
                                      : thisSelectedDate.day,
                                  thisEndTime.hour,
                                  thisEndTime.minute,
                                );
                                String title = titleController.text;
                                PlanActivity activity = PlanActivity(
                                  // Create a random key for the activity
                                  key: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  category: categoryController.text,
                                  isManual: true,
                                  dateTime: ref.watch(selectedDateProvider),
                                  startTime: formattedStartTime,
                                  endTime: formattedEndTime,
                                  title: title,
                                );

                                if (context.mounted) {
                                  ref
                                      .read(plansControllerProvider.notifier)
                                      .addActivityToPlan(
                                          widget.plan.uid!, activity, context);

                                  context.pop();
                                  context.pop();
                                }
                              },
                              child: const Text("Add"))
                        ],
                      );
                    },
                  );
                },
              );
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the value as needed
              ),
            ),
            child: const Text(
              "Add Activity Manually",
              style: TextStyle(fontSize: 14),
            ),
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/listing_provider.dart';
import 'package:lakbay/features/location/geocoding_repository.dart';
import 'package:lakbay/features/location/map_repository.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

class AddTransport extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final String category;
  const AddTransport({required this.coop, required this.category, super.key});

  @override
  ConsumerState<AddTransport> createState() => _AddTransportState();
}

class _AddTransportState extends ConsumerState<AddTransport> {
  // global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // stepper
  int activeStep = 0;
  int upperBound = 7;

  // initial values
  String type = 'Public';
  num guests = 0;
  num luggage = 0;
  TimeOfDay startDate = TimeOfDay.now();
  TimeOfDay endDate = TimeOfDay.now();
  TimeOfDay travelDuration = const TimeOfDay(hour: 1, minute: 15);
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController travelDurationController =
      TextEditingController();
  List<bool> workingDays = List.filled(7, false);
  List<BookingTask>? fixedTasks = [];
  String _addressDestination = '';
  String _addressPickup = '';
  String _addressLocation = '';

  List<File>? _images = [];
  int departures = 0;
  final List<TextEditingController> _departureController = [];
  final List<TimeOfDay> _departureTime = [];

  // controllers
  final TextEditingController _travelTimeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _addressController =
      TextEditingController(text: 'Eastwood City');
  final TextEditingController _destinationController =
      TextEditingController(text: 'Eastwood City');
  final TextEditingController _pickupController =
      TextEditingController(text: 'Eastwood City');

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          context.pop();
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Add Transport Listing'),
            ),
            bottomNavigationBar: bottomAppBar(),
            body: isLoading
                ? const Loader()
                : SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(children: [
                              steppers(context),
                              stepForm(context)
                            ]))))));
  }

  BottomAppBar bottomAppBar() {
    return BottomAppBar(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (activeStep == 0) ...[
        TextButton(
            onPressed: () {
              context.pop();
              // ref.read(navBarVisibilityProvider.notifier).show();
            },
            child: const Text('Cancel'))
      ] else ...[
        TextButton(
            onPressed: () {
              setState(() {
                activeStep--;
              });
            },
            child: const Text('Back'))
      ],

      // Next
      if (activeStep != upperBound) ...[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              if (activeStep < upperBound) {
                setState(() {
                  activeStep++;
                });
              }
            },
            child: Text(
              'Next',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ))
      ] else ...[
        TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              AvailableTransport transport = AvailableTransport(
                guests: guests,
                luggage: luggage,
                price: num.parse(_feeController.text),
                available: true,
                workingDays: workingDays,
                startTime: startDate,
                endTime: endDate,
                // if destination is empty, set to null
                destination: _destinationController.text.isEmpty
                    ? null
                    : _destinationController.text,
                pickupPoint: _pickupController.text.isEmpty
                    ? null
                    : _pickupController.text,
                // if departure times are empty, set to null
                departureTimes: _departureTime.isEmpty ? null : _departureTime,
                // if travel time is empty, set to null
                travelTime: _travelTimeController.text.isEmpty
                    ? null
                    : _travelTimeController.text,
              );

              ListingModel listingModel = ListingModel(
                  address: _addressController.text,
                  category: widget.category,
                  city: widget.coop.city,
                  cooperative: ListingCooperative(
                      cooperativeId: widget.coop.uid!,
                      cooperativeName: widget.coop.name),
                  travelDuration: travelDuration,
                  description: _descriptionController.text,
                  province: widget.coop.province,
                  publisherId: ref.read(userProvider)!.uid,
                  title: _titleController.text,
                  type: type,
                  publisherName: ref.read(userProvider)!.name,
                  images:
                      _images?.map((e) => ListingImages(path: e.path)).toList(),
                  availableTransport: transport);

              ref
                  .read(saveListingProvider.notifier)
                  .saveListingProvider(listingModel);
              submitAddListing(listingModel);
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ))
      ]
    ]));
  }

  void submitAddListing(ListingModel listing) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // prepare data for storeFiles
      final imagePath = 'listings/${widget.coop.name}';
      final ids = _images!.map((e) => e.path.split('/').last).toList();

      // store files
      ref
          .read(storageRepositoryProvider)
          .storeFiles(path: imagePath, ids: ids, files: _images!)
          .then((value) => value.fold(
                  (failure) => debugPrint('failed to store files'), (urls) {
                // add urls to images
                listing = listing.copyWith(
                    images: listing.images!
                        .map((e) =>
                            e.copyWith(url: urls[listing.images!.indexOf(e)]))
                        .toList());

                debugPrint('success');

                // add listing
                ref.read(listingControllerProvider.notifier).addListing(
                    listing, context,
                    transport: listing.availableTransport);
              }));
    }
  }

  Column steppers(BuildContext context) {
    return Column(
      children: [
        IconStepper(
          lineColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          stepColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          activeStepColor: Theme.of(context).colorScheme.primary,
          enableNextPreviousButtons: false,
          icons: [
            Icon(
              Icons.category_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.details_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.map_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.image_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(
              Icons.task,
              color: Theme.of(context).colorScheme.background,
            ),
            Icon(Icons.policy, color: Theme.of(context).colorScheme.background),
            Icon(
              Icons.summarize_outlined,
              color: Theme.of(context).colorScheme.background,
            ),
          ],

          // activeStep property set to activeStep variable defined above.
          activeStep: activeStep,

          // This ensures step-tapping updates the activeStep.
          onStepReached: (index) {
            setState(() {
              activeStep = index;
              debugPrint('the current step is $activeStep');
            });
          },
        ),
        header(),
      ],
    );
  }

  Widget header() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DisplayText(
          text: headerText(),
          lines: 2,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Add details';

      case 2:
        return 'Add supporting details...';

      case 3:
        return 'Where are you located?';

      case 4:
        return 'Add listing photo/s';

      case 5:
        return 'Add Fixed Tasks';

      case 6:
        return 'Add Policies';

      case 7:
        return 'Review Listing';

      default:
        return 'Choose Type';
    }
  }

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Public', 'icon': Icons.car_rental_sharp},
      {'name': 'Private', 'icon': Icons.car_rental_outlined}
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: types.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 120,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: type == types[index]['name']
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  width: 1,
                ),
              ),
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: InkWell(
                onTap: () {
                  setState(() {
                    type = types[index]['name'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Icon(
                        types[index]['icon'],
                        size: 35,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      // Title
                      Text(
                        types[index]['name'],
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget addFixedTasks(BuildContext context) {
    List<String> notes = [
      "Fixed tasks will appear for every booking. They must always be accomplished when your service is purchased.",
      "Members that can be assigned to tasks are those belonging in the tourism committee."
    ];
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      child: Dialog.fullscreen(child: showFixedTaskForm()),
                    );
                  });
            },
            child: const Text("Add Task")),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fixedTasks?.length,
            itemBuilder: ((context, taskIndex) {
              return Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 1), // Border color
                    borderRadius: BorderRadius.circular(
                        6), // Border radius for rounded corners
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 25,
                              ), // 'X' icon
                              onPressed: () {},
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns children at the start of the cross axis
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Task: ",
                                style: TextStyle(
                                  fontSize:
                                      16, // Ensure this matches the font size of the other text
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: DisplayText(
                                  text: fixedTasks![taskIndex].name,
                                  lines: 3,
                                  style: const TextStyle(
                                    fontSize: 16, // Adjust text style
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Assigned: ",
                                style: TextStyle(
                                  fontSize:
                                      16, // Ensure this matches the font size of the other text
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 items per row
                                    crossAxisSpacing:
                                        1.5, // Space between cards horizontally
                                    mainAxisSpacing: 1.5,
                                    mainAxisExtent: MediaQuery.sizeOf(context)
                                            .height /
                                        20, // Space between cards vertically
                                  ),
                                  itemCount: fixedTasks![taskIndex]
                                      .assignedNames
                                      .length,
                                  itemBuilder: (context, assignedIndex) {
                                    return Container(
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey), // Border color
                                          borderRadius: BorderRadius.circular(
                                              4), // Border radius for rounded corners
                                        ),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            fixedTasks![taskIndex]
                                                    .assignedNames[
                                                assignedIndex], // Replace with the name from your data
                                            style: const TextStyle(
                                              fontSize: 14, // Adjust text style
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle long text
                                            ),
                                          ),
                                        ));
                                  }),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            })),
        if (fixedTasks!.isEmpty)
          SizedBox(
              height: MediaQuery.sizeOf(context).height / 5,
              width: double.infinity,
              child: const Center(child: Text("No Tasks Created"))),
        addNotes(
          notes,
        ),
      ],
    );
  }

  Widget showFixedTaskForm() {
    TextEditingController taskNameController = TextEditingController();
    TextEditingController committeeController =
        TextEditingController(text: "Tourism");
    List<String> assignedIds = [];
    List<String> assignedNames = [];
    List<CooperativeMembers>? members;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          AppBar(
            leading: IconButton(
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).pop(); // Corrected the navigation method
              },
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            title: const Text(
              "Create Task",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                TextFormField(
                  controller: taskNameController,
                  decoration: const InputDecoration(
                    labelText: 'Task Name*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "e.g., Clean the car",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: committeeController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Committee Assigned*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    suffixIcon:
                        Icon(Icons.arrow_drop_down), // Dropdown arrow icon
                  ),
                  readOnly: true,
                  enabled: false,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    TextFormField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                          labelText: 'Members Assigned*',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior
                              .always, // Keep the label always visible
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          hintText:
                              "Press to select member" // Dropdown arrow icon
                          ),
                      readOnly: true,
                      canRequestFocus: false,
                      onTap: () async {
                        members = await ref.read(
                            getAllMembersInCommitteeProvider(CommitteeParams(
                          committeeName: committeeController.text,
                          coopUid: ref.watch(userProvider)!.currentCoop!,
                        )).future);

                        members = members!
                            .where((member) =>
                                !assignedNames.contains(member.name))
                            .toList();
                        if (context.mounted) {
                          return showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return Container(
                                padding: const EdgeInsets.all(
                                    10.0), // Padding for overall container
                                child: Column(
                                  children: [
                                    // Optional: Add a title or header for the modal
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Text(
                                        "Members (${committeeController.text})",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: members!.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              members![index].name,
                                              style: const TextStyle(
                                                  fontSize:
                                                      16.0), // Adjust font size
                                            ),
                                            onTap: () {
                                              setState(
                                                () {
                                                  assignedIds.add(
                                                      members![index].uid!);
                                                  assignedNames.add(
                                                      members![index].name);
                                                },
                                              );
                                              context.pop();
                                            },
                                            // Optional: Add trailing icons or actions
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 items per row
                        crossAxisSpacing:
                            1.5, // Space between cards horizontally
                        mainAxisSpacing: 1.5,
                        mainAxisExtent: MediaQuery.sizeOf(context).height /
                            8, // Space between cards vertically
                      ),
                      itemCount: assignedNames
                          .length, // Replace with the length of your data
                      itemBuilder: (context, index) {
                        return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey), // Border color
                              borderRadius: BorderRadius.circular(
                                  4), // Border radius for rounded corners
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 16,
                                    ), // 'X' icon
                                    onPressed: () {
                                      setState(
                                        () {
                                          assignedIds.remove(members![members!
                                                  .indexWhere((element) =>
                                                      element.name ==
                                                      assignedNames[index])]
                                              .uid!);
                                          assignedNames.removeAt(index);
                                        },
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      assignedNames[
                                          index], // Replace with the name from your data
                                      style: const TextStyle(
                                        fontSize: 14, // Adjust text style
                                        overflow: TextOverflow
                                            .ellipsis, // Handle long text
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                    )
                  ],
                ),
              ]),
            ),
          ),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                this.setState(() {
                  fixedTasks?.add(BookingTask(
                      listingName: _titleController.text,
                      status: 'Incomplete',
                      assignedIds: assignedIds,
                      assignedNames: assignedNames,
                      committee: committeeController.text,
                      complete: false,
                      openContribution: false,
                      name: taskNameController.text));
                });
                context.pop();
              },
              child: const Text("Add Task")),
        ],
      );
    });
  }

  Widget addPolicies(BuildContext context) {
    List<String> notes = [
      "Cancellation Rate: The amount that would not be refunded in the situation that a customer cancels their booking.",
      "Cancellation Period: This refers to the number of days before the scheduled booking, that a customer can cancel and pay the full amount in the case for a downpayment. Otherwise their booking will be cancelled",
      "Customers booking passed the cancellation period would be required to pay the downpayment or full amount upon checkout."
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLines: 1,
                decoration: const InputDecoration(
                    labelText: 'Cancellation Rate (%)*',
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior
                        .always, // Keep the label always visible
                    hintText: "e.g., 5",
                    suffixText: "%"),
                onTap: () {},
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.number, // For numeric input
          decoration: const InputDecoration(
              labelText:
                  'Cancellation Period (Day/s)*', // Indicate it's a percentage
              border: OutlineInputBorder(),
              floatingLabelBehavior:
                  FloatingLabelBehavior.always, // Keep the label always visible
              hintText: "e.g., 5 Days before the booked date",
              suffixText: "Day/s"),
          onTap: () {
            // Handle tap if needed, e.g., showing a dialog to select a percentage
          },
        ),
        addNotes(notes),
      ],
    );
  }

  Column addNotes(
    List<String> notes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        DisplayText(
          text: "Notes:",
          lines: 1,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    DisplayText(
                      text: notes[index],
                      lines: 10,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              );
            }))
      ],
    );
  }

  Widget addDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Please add the details of your listing...',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
              labelText: 'Listing Title*',
              helperText: '*required',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Lakbay Transport"),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          maxLines: null,
          decoration: const InputDecoration(
              labelText: 'Description*',
              helperText: '*required',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "A transport from Lakbay..."),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _feeController,
          decoration: const InputDecoration(
              labelText: 'Price*',
              prefix: Text('₱'),
              helperText: '*required',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "1000.00"),
        ),
        const SizedBox(height: 10),
        const Text('Guest Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Let the guests know how many people can stay...',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        ListTile(
            title: const Row(children: [
              Icon(Icons.people_alt_outlined),
              SizedBox(width: 10),
              Text('Guests')
            ]),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (guests >= 1) {
                      setState(() {
                        guests--;
                      });
                    }
                  }),
              const SizedBox(width: 10),
              Text("$guests", style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      guests++;
                    });
                  })
            ])),
        const SizedBox(height: 10),
        ListTile(
            title: const Row(children: [
              Icon(Icons.luggage),
              SizedBox(width: 10),
              Text('Luggages')
            ]),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (luggage >= 1) {
                      setState(() {
                        luggage--;
                      });
                    }
                  }),
              const SizedBox(width: 10),
              Text("$luggage", style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      luggage++;
                    });
                  })
            ])),
        // add working days of the listing
        const SizedBox(height: 10)
      ],
    );
  }

  String getDay(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  Widget addLocation(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text('Add the location of your listing...',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
      ),
      const SizedBox(height: 10),
      TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address*',
            helperText: '*required',
            border: OutlineInputBorder(),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }),
      Center(
        child: ElevatedButton(
          onPressed: () {
            // update the map with the new address
            setState(() {
              _addressLocation = _addressController.text;
            });
          },
          child: const Text('Update Map'),
        ),
      ),

      const SizedBox(height: 10),

      // Google Map
      SizedBox(
        height: 400,
        child: MapWidget(address: _addressLocation),
      ),

      const SizedBox(height: 10),
    ]);
  }

  Widget addSuppDetails(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      const Text('Working Days',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text('Please select your working days...',
          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
      Column(
        children: List<Widget>.generate(7, (int index) {
          return CheckboxListTile(
            title: Text(
              getDay(index),
              style: const TextStyle(fontSize: 16),
            ),
            value: workingDays[index],
            onChanged: (bool? value) {
              setState(() {
                workingDays[index] = value!;
              });
            },
          );
        }),
      ),
      const SizedBox(height: 10),
      // indicate the working hours of the listing
      const Text('Operating Hours',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const Text('Please select your operating hours...',
          style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
      const SizedBox(height: 10),
      TextFormField(
        controller: startDateController,
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'Start Time*',
          helperText: '*required',
          border: OutlineInputBorder(),
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep the label always visible
          hintText: "8:30",
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 8, minute: 30),
            initialEntryMode: TimePickerEntryMode.inputOnly,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            },
          );

          if (pickedTime != null) {
            setState(() {
              startDateController.text = pickedTime.format(context);
              startDate = pickedTime;
            });
          }
        },
      ),
      // start time
      const SizedBox(
        height: 10,
      ),
      // end time
      TextFormField(
        controller: endDateController,
        maxLines: 1,
        decoration: const InputDecoration(
          labelText: 'End Time*',
          helperText: '*required',
          border: OutlineInputBorder(),
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep the label always visible
          hintText: "5:30",
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 5, minute: 30),
            initialEntryMode: TimePickerEntryMode.inputOnly,
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!,
              );
            },
          );

          if (pickedTime != null) {
            setState(() {
              endDateController.text = pickedTime.format(context);
              endDate = pickedTime;
            });
          }
        },
      ),
      const SizedBox(height: 30),
      // check if the type is public
      if (type == 'Public') ...[
        const Text('Travel Duration',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Please input the expected travel duration....',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        TextFormField(
          controller: travelDurationController,
          maxLines: 1,
          decoration: const InputDecoration(
            labelText: 'Duration*',
            helperText: '*required',
            border: OutlineInputBorder(),
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep the label always visible
            hintText: "1:15",
          ),
          readOnly: true,
          onTap: () async {
            final TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: travelDuration,
              initialEntryMode: TimePickerEntryMode.inputOnly,
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              setState(() {
                travelDurationController.text =
                    "${pickedTime.hour}:${pickedTime.minute}";
                travelDuration = pickedTime;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        const Text('Departure Time',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Text('Please select your departure time...',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: departures,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                // replace elevatedButton with textfield
                const SizedBox(height: 15),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      controller: _departureController[index],
                      decoration: InputDecoration(
                          labelText: 'Departure Time',
                          border: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText:
                              "${startDate.hour}:${startDate.minute} ${startDate.period.name.toUpperCase()}"),
                      readOnly: true,
                      onTap: () async {
                        showTimePicker(
                          context: context,
                          initialTime: startDate,
                          initialEntryMode: TimePickerEntryMode.inputOnly,
                        ).then((time) {
                          if (time != null) {
                            setState(() {
                              _departureTime.add(time);
                              _departureController[index].text =
                                  time.format(context);
                            });
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  departures++;
                  _departureController.add(TextEditingController());
                });
              },
              child: const Text('Add Departure Time')),
        ),
        const SizedBox(height: 15),
        const Text('Pickup Point',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Add your pickup point for the listing...',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _pickupController,
          decoration: const InputDecoration(
              labelText: 'Destination*',
              helperText: '*required',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Eastwood City"),
        ),
        // Google Map
        const SizedBox(height: 15),
        SizedBox(
          height: 400,
          child: MapWidget(address: _addressPickup),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // update the map according to the pickup point
              setState(() {
                _addressPickup = _pickupController.text;
              });
            },
            child: const Text('Update Map'),
          ),
        ),
        const SizedBox(height: 30),
        const Text('Destination',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Add your preferred destination for the listing...',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _destinationController,
          decoration: const InputDecoration(
              labelText: 'Destination*',
              helperText: '*required',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Eastwood City"),
        ),
        // Google Map
        const SizedBox(height: 15),
        SizedBox(
          height: 400,
          child: MapWidget(address: _addressDestination),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                // update the map according to the destination
                _addressDestination = _destinationController.text;
                // update the value of travel time accordingly
              });
            },
            child: const Text('Update Map'),
          ),
        ),
        if (type == 'Public') ...[
          const Padding(
            padding: EdgeInsets.only(top: 8.0, left: 12.0),
            child: DisplayText(
                text: "Travel Time",
                lines: 1,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _travelTimeController,
              decoration: const InputDecoration(
                  labelText: 'Travel Time*',
                  helperText: '*required',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "1 hour"),
            ),
          ),
          // calculate the travel time
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final mapRepository = ref.read(mapRepositoryProvider);
                debugPrint(
                    'this is the pickup point: ${_pickupController.text}');
                debugPrint(
                    'this is the destination point: ${_destinationController.text}');
                // calculate the travel time
                final travelTime = await mapRepository.calculateTravelTime(
                    origin: _pickupController.text,
                    destination: _destinationController.text);

                debugPrint('this is the travel time: $travelTime');
                _travelTimeController.text = travelTime;
              },
              child: const Text('Calculate Travel Time'),
            ),
          )
        ]
      ],
    ]);
  }

  Widget addListingPhotos(BuildContext context) {
    return Column(children: [
      GestureDetector(
          child: Row(children: [
        Icon(Icons.image_outlined, color: Theme.of(context).iconTheme.color),
        const SizedBox(width: 15),
        Expanded(
          child: ImagePickerFormField(
            height: MediaQuery.sizeOf(context).height / 2.5,
            width: MediaQuery.sizeOf(context).width,
            context: context,
            initialValue: _images,
            onSaved: (List<File>? files) {
              _images = files;
            },
            validator: (List<File>? files) {
              if (files == null || files.isEmpty) {
                return 'Please select some images';
              }
              return null;
            },
            onImagesSelected: (List<File> files) {
              _images = files;
            },
          ),
        )
      ]))
    ]);
  }

  Widget addGuestInfo(BuildContext context) {
    return const Column();
  }

  Widget reviewListing(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_images?.isNotEmpty == true) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, left: 12.0),
              child: DisplayText(
                  text: "Listing Photo/s",
                  lines: 1,
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageSlider(
                  images: _images,
                  height: MediaQuery.sizeOf(context).height / 2.5,
                  width: double.infinity,
                  radius: BorderRadius.circular(10)),
            ),
          ],

          ListTile(
              title: const Text('Category',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text(widget.category)),
          ListTile(
              title: const Text(
                'Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(type)),
          const Divider(),
          // Step 1
          ListTile(
              title: const Text(
                'Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_titleController.text)),
          ListTile(
            title: const Text('Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(_descriptionController.text),
          ),
          if (type == 'Public') ...[
            ListTile(
              title: const Text('Ticket Price',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text("₱${_feeController.text} / per person"),
            ),
          ] else ...[
            ListTile(
              title: const Text('Price',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text("₱${_feeController.text}"),
            ),
          ],

          const Divider(),
          ListTile(
            title: const Text('Guest Capacity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text("$guests"),
          ),
          ListTile(
            title: const Text('Luggage Capacity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text("$luggage"),
          ),
          const Divider(),
          // add working days
          ListTile(
            title: const Text('Working Days',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(workingDays
                .asMap()
                .entries
                .where((element) => element.value)
                .map((e) => getDay(e.key))
                .toList()
                .join(', ')),
          ),
          // add working hours
          ListTile(
            title: const Text('Operating Hours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text('$startDate - $endDate'),
          ),

          // insert departure times if there are any
          if (type == 'Public') ...[
            const Divider(),
            ListTile(
              title: const Text('Departure Times',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _departureTime.length,
                  (index) => Text(_departureTime[index].format(context)),
                ),
              ),
            ),
            ListTile(
              title: const Text('Travel Time',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )
          ],
        ]);
  }

  Widget stepForm(BuildContext context) {
    switch (activeStep) {
      case 1:
        return addDetails(context);
      case 2:
        return addSuppDetails(context);
      case 3:
        return addLocation(context);
      case 4:
        return addListingPhotos(context);
      case 5:
        return addFixedTasks(context);
      case 6:
        return addPolicies(context);
      case 7:
        return reviewListing(context);
      default:
        return chooseType(context);
    }
  }
}

class ImagePickerFormField extends FormField<List<File>> {
  final Function(List<File>) onImagesSelected;

  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    required BuildContext context,
    required double height,
    required double width,
    List<File>? initialValue,
    required this.onImagesSelected,
  }) : super(
          initialValue: initialValue ?? [],
          builder: (FormFieldState<List<File>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFiles = await picker.pickMultiImage();

                    if (pickedFiles.isNotEmpty) {
                      List<File> files = pickedFiles
                          .map((pickedFile) => File(pickedFile.path))
                          .toList();
                      state.didChange(files);
                      onImagesSelected(files); // Use the callback here
                    }
                  },
                  child: Column(
                    children: [
                      // If its empty
                      if (state.value!.isEmpty)
                        Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                                DisplayText(
                                  text: "Add Images",
                                  lines: 1,
                                  style: Theme.of(context).textTheme.bodySmall!,
                                ),
                              ]),
                        ),
                      if (state.value!.isNotEmpty)
                        Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child:
                              Image.file(state.value!.first, fit: BoxFit.cover),
                        ),
                      if (state.value!.length > 1)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: state.value!.length - 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.file(state.value![index + 1],
                                  fit: BoxFit.cover),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

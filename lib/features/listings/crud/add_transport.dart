import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/listing_provider.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

enum CancelPolicy { fixedCancelRate, percentageCancelRate }

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
  int upperBound = 6;

  // initial values
  String type = 'Public';
  num guests = 0;
  num luggage = 0;
  num vehicles = 0;
  TimeOfDay startDate = const TimeOfDay(hour: 8, minute: 30);
  TimeOfDay endDate = const TimeOfDay(hour: 17, minute: 30);
  TimeOfDay travelDuration = const TimeOfDay(hour: 1, minute: 15);
  final TextEditingController startDateController =
      TextEditingController(text: ('8:30 AM'));
  final TextEditingController endDateController =
      TextEditingController(text: ('5:30 AM'));
  final TextEditingController travelDurationController =
      TextEditingController();
  List<bool> workingDays = List.filled(7, false);
  List<BookingTask>? fixedTasks = [];
  Map<String, String> drivers = {};

  List<AvailableTransport> availableTransports = [];
  List<File>? _images = [];
  int departures = 0;
  final List<TimeOfDay> _departureTime = [];
  bool _showByHourFeeField = false;

  // controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _byHourFeeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickupController = TextEditingController();

  final TextEditingController _cancellationRateController =
      TextEditingController();
  final TextEditingController _cancellationPeriodController =
      TextEditingController();
  CancelPolicy _selectedCancel = CancelPolicy.fixedCancelRate; // Default value

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
        FilledButton(
            style: FilledButton.styleFrom(
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
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: const Text('Submit Listing'),
                        content: const Text(
                            'Are you sure you want to submit this listing?'),
                        actions: [
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              AvailableTransport transport = AvailableTransport(
                                vehicleNo: vehicles,
                                guests: guests,
                                luggage: luggage,
                                available: true,
                                workingDays: workingDays,
                                startTime: startDate,
                                endTime: endDate,
                                departureTimes: _departureTime.isEmpty
                                    ? null
                                    : _departureTime,
                                // if travel time is empty, set to null
                                priceByHour: _byHourFeeController.text.isEmpty
                                    ? null
                                    : num.parse(_byHourFeeController.text),
                              );

                              ListingModel listingModel = ListingModel(
                                address: _addressController.text,
                                category: widget.category,
                                city: widget.coop.city,
                                cooperative: ListingCooperative(
                                    cooperativeId: widget.coop.uid!,
                                    cooperativeName: widget.coop.name),
                                duration: travelDuration,
                                description: _descriptionController.text,
                                driverIds: drivers.keys.toList(),
                                driverNames: drivers.values.toList(),
                                price: num.parse(_feeController.text),
                                province: widget.coop.province,
                                publisherId: ref.read(userProvider)!.uid,
                                pickUp: _pickupController.text,
                                destination: _destinationController.text,
                                title: _titleController.text,
                                // fixedTasks: fixedTasks,
                                type: type,
                                publisherName: ref.read(userProvider)!.name,
                                images: _images
                                    ?.map((e) => ListingImages(path: e.path))
                                    .toList(),
                                availableTransport: transport,
                                cancellationPeriod: num.parse(
                                    _cancellationPeriodController.text),
                                cancellationRate: _selectedCancel ==
                                        CancelPolicy.fixedCancelRate
                                    ? num.parse(
                                        (_cancellationRateController.text))
                                    : num.parse((_cancellationRateController
                                            .text)) /
                                        100,
                              );

                              ref
                                  .read(saveListingProvider.notifier)
                                  .saveListingProvider(listingModel);
                              submitAddListing(listingModel);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0))),
                            child: const Text('Submit'),
                          ),
                        ]);
                  });
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
                    transports: availableTransports);
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
              Icons.directions_bus_filled_outlined,
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
            // Icon(
            //   Icons.task,
            //   color: Theme.of(context).colorScheme.background,
            // ),
            Icon(Icons.policy, color: Theme.of(context).colorScheme.background),
          ],

          // activeStep property set to activeStep variable defined above.
          activeStep: activeStep,

          // This ensures step-tapping updates the activeStep.
          onStepReached: (index) {
            setState(() {
              activeStep = index;
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
        return 'Vehicle Information';

      case 3:
        return 'Add supporting details...';

      case 4:
        return 'Where are you located?';

      case 5:
        return 'Add listing photo/s';

      // case 6:
      //   return 'Add Fixed Tasks';

      case 6:
        return 'Add Policies';

      // case 7:
      //   return 'Review Listing';

      default:
        return 'Choose Type';
    }
  }

  Widget chooseType(BuildContext context) {
    List<Map<String, dynamic>> types = [
      {'name': 'Public', 'icon': Icons.car_rental_sharp},
      // {'name': 'Private', 'icon': Icons.car_rental_outlined}
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
        SizedBox(
          width: MediaQuery.sizeOf(context).width * .5,
          child: FilledButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Create Task"),
                        content: showFixedTaskForm(),
                      );
                    });
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(4.0), // Adjust the radius as needed
                ),
              ),
              child: const Text("Add Task")),
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fixedTasks?.length,
            itemBuilder: ((context, taskIndex) {
              return ListTile(
                leading: Text("[${taskIndex + 1}]. "),
                title: Text(fixedTasks![taskIndex].name),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ), // 'X' icon
                  onPressed: () {
                    setState(
                      () {
                        fixedTasks?.removeAt(taskIndex);
                      },
                    );
                  },
                ),
                // subtitle: SizedBox(
                //   height: MediaQuery.sizeOf(context).height * .03,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     itemCount: fixedTasks?[taskIndex].assignedNames.length ?? 0,
                //     itemBuilder: (context, nameIndex) {
                //       return nameIndex == 0
                //           ? Text(
                //               'Assigned: ${fixedTasks?[taskIndex].assignedNames[nameIndex]}, ',
                //               style: const TextStyle(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w300,
                //               ),
                //             )
                //           : Text(
                //               '${fixedTasks?[taskIndex].assignedNames[nameIndex]}, ',
                //               style: const TextStyle(
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w300,
                //               ),
                //             );
                //     },
                //   ),
                // ),
              );
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
    return SingleChildScrollView(
      child: StatefulBuilder(builder: (context, setState) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .70,
          width: MediaQuery.sizeOf(context).width * 1,
          child: Column(
            children: [
              Column(children: [
                TextFormField(
                  maxLines: null,
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
                // Column(
                //   children: [
                //     TextFormField(
                //       maxLines: 1,
                //       decoration: const InputDecoration(
                //           labelText: 'Members Assigned*',
                //           border: OutlineInputBorder(),
                //           floatingLabelBehavior: FloatingLabelBehavior
                //               .always, // Keep the label always visible
                //           suffixIcon: Icon(Icons.arrow_drop_down),
                //           hintText:
                //               "Press to select member" // Dropdown arrow icon
                //           ),
                //       readOnly: true,
                //       canRequestFocus: false,
                //       onTap: () async {
                //         members = await ref.read(
                //             getAllMembersInCommitteeProvider(CommitteeParams(
                //           committeeName: committeeController.text,
                //           coopUid: ref.watch(userProvider)!.currentCoop!,
                //         )).future);

                //         members = members!
                //             .where((member) =>
                //                 !assignedNames.contains(member.name))
                //             .toList();
                //         if (context.mounted) {
                //           return showModalBottomSheet(
                //             context: context,
                //             builder: (builder) {
                //               return Container(
                //                 padding: const EdgeInsets.all(
                //                     10.0), // Padding for overall container
                //                 child: Column(
                //                   children: [
                //                     // Optional: Add a title or header for the modal
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           vertical: 10.0),
                //                       child: Text(
                //                         "Members (${committeeController.text})",
                //                         style: const TextStyle(
                //                           fontSize: 18.0,
                //                           fontWeight: FontWeight.bold,
                //                         ),
                //                       ),
                //                     ),
                //                     Expanded(
                //                       child: ListView.builder(
                //                         itemCount: members!.length,
                //                         itemBuilder: (context, index) {
                //                           return ListTile(
                //                             title: Text(
                //                               members![index].name,
                //                               style: const TextStyle(
                //                                   fontSize:
                //                                       16.0), // Adjust font size
                //                             ),
                //                             onTap: () {
                //                               setState(
                //                                 () {
                //                                   assignedIds.add(
                //                                       members![index].uid!);
                //                                   assignedNames.add(
                //                                       members![index].name);
                //                                 },
                //                               );
                //                               context.pop();
                //                             },
                //                             // Optional: Add trailing icons or actions
                //                           );
                //                         },
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               );
                //             },
                //           );
                //         }
                //       },
                //     ),
                //     const SizedBox(
                //       height: 5,
                //     ),
                //     SizedBox(
                //       height: MediaQuery.sizeOf(context).height * .13,
                //       width: double.infinity,
                //       child: ListView.builder(
                //         shrinkWrap: true,
                //         itemCount: assignedNames.length,
                //         itemBuilder: (context, index) {
                //           return ListTile(
                //             dense: true,
                //             contentPadding: const EdgeInsets.all(0),
                //             horizontalTitleGap: 8,
                //             leading: Text('[${index + 1}]'),
                //             title: Text(
                //               assignedNames[index],
                //               style: const TextStyle(
                //                 fontSize: 14,
                //                 color: Colors.black,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //             trailing: IconButton(
                //               icon: const Icon(
                //                 Icons.close,
                //                 color: Colors.black,
                //                 size: 16,
                //               ), // 'X' icon
                //               onPressed: () {
                //                 setState(
                //                   () {
                //                     assignedIds.remove(members![members!
                //                             .indexWhere((element) =>
                //                                 element.name ==
                //                                 assignedNames[index])]
                //                         .uid!);
                //                     assignedNames.removeAt(index);
                //                   },
                //                 );
                //               },
                //             ),
                //           );
                //         },
                //       ),
                //     )
                //   ],
                // ),
              ]),
              const SizedBox(height: 65),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Close')),
                  const SizedBox(
                    width: 10,
                  ),
                  FilledButton(
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
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget addPolicies(BuildContext context) {
    List<String> notes = [
      "Cancellation Rate: The amount that would not be refunded in the situation that a customer cancels their booking.",
      "Cancellation Period: This refers to the number of days before the scheduled booking, that a customer can cancel and pay the full amount in the case for a downpayment. Otherwise their booking will be cancelled",
      "Customers booking passed the cancellation period would be required to pay the downpayment or full amount upon checkout."
    ];
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cancellation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Radio buttons for payment options
            Row(
              children: [
                Expanded(
                  child: RadioListTile<CancelPolicy>(
                    title: const Text('Fixed Rate'),
                    value: CancelPolicy.fixedCancelRate,
                    groupValue: _selectedCancel,
                    onChanged: (CancelPolicy? value) {
                      setState(() {
                        _selectedCancel = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<CancelPolicy>(
                    title: const Text('Percent Rate'),
                    value: CancelPolicy.percentageCancelRate,
                    groupValue: _selectedCancel,
                    onChanged: (CancelPolicy? value) {
                      setState(() {
                        _selectedCancel = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_selectedCancel == CancelPolicy.fixedCancelRate) ...[
              rendFixedCancelRate(),
            ],

            if (_selectedCancel == CancelPolicy.percentageCancelRate) ...[
              rendPercentageCancelRate(),
            ],
          ],
        ),
        addNotes(notes),
      ],
    );
  }

  Row rendPercentageCancelRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cancellationRateController,
            maxLines: 1,
            decoration: const InputDecoration(
                labelText: 'Percentage Rate',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5",
                suffixText: "%"),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: _cancellationPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Cancellation Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
      ],
    );
  }

  Row rendFixedCancelRate() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _cancellationRateController,
            maxLines: 1,
            decoration: const InputDecoration(
                labelText: 'Fixed Rate',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5",
                suffixText: "₱"),
            onTap: () {},
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: _cancellationPeriodController,
            maxLines: 1,
            keyboardType: TextInputType.number, // For numeric input
            decoration: const InputDecoration(
                labelText: 'Cancellation Period', // Indicate it's a percentage
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior
                    .always, // Keep the label always visible
                hintText: "e.g., 5 Days before the booked date",
                suffixText: "Day/s"),
            onTap: () {
              // Handle tap if needed, e.g., showing a dialog to select a percentage
            },
          ),
        ),
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
    List<String> notes = [
      // 'Vehicle count will be used to determine how many availability of your service.',
      // 'Luggage and Capacity is referring to a singular vehicle.',
      // 'Vehicles pertained should be of similar capacity, in the case of a larger or smaller vehicle, create another listing for it.',
    ];
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
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "150.00"),
        ),
        const SizedBox(height: 10),
        if (type == 'Private') ...[
          const Text('Add Price By Hour',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Would you like to add a price by hour?',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
          // add a button to add price by hour
          const SizedBox(height: 10),
          if (_showByHourFeeField) ...[
            TextFormField(
              controller: _byHourFeeController,
              decoration: const InputDecoration(
                  labelText: 'Price By Hour',
                  border: OutlineInputBorder(),
                  prefix: Text('₱'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "100.00"),
            ),
            const SizedBox(height: 10),
          ],
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FilledButton(
                onPressed: () {
                  setState(() {
                    _showByHourFeeField = true;
                  });
                },
                child: const Text('Add Price By Hour')),
            FilledButton(
                onPressed: () {
                  setState(() {
                    _showByHourFeeField = false;
                  });
                },
                child: const Text('Remove Price By Hour')),
          ]),
          const SizedBox(height: 10)
        ],
        // const SizedBox(height: 10),
        // const Text('Select Drivers',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        // const Text(
        //     'Select the drivers of the vehicles when the service is booked...',
        //     style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        // ListView.builder(
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     itemCount: drivers.keys.length,
        //     itemBuilder: (context, driverIndex) {
        //       final driverKey = drivers.keys
        //           .toList()[driverIndex]; // Get the key at the current index
        //       final driverName =
        //           drivers[driverKey]; // Get the corresponding value

        //       return ListTile(
        //         dense: true,
        //         contentPadding: const EdgeInsets.all(0),
        //         horizontalTitleGap: 8,
        //         leading: Text('[${driverIndex + 1}]'),
        //         title: Text('$driverName'),
        //         trailing: IconButton(
        //           icon: const Icon(
        //             Icons.close,
        //             color: Colors.black,
        //             size: 16,
        //           ), // 'X' icon
        //           onPressed: () {
        //             setState(
        //               () {
        //                 drivers.remove(driverKey);
        //               },
        //             );
        //           },
        //         ),
        //       );
        //     }),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     SizedBox(
        //       width: MediaQuery.sizeOf(context).width * .5,
        //       child: FilledButton(
        //           onPressed: () async {
        //             List<String> assignedNames = [];
        //             List<CooperativeMembers>? members;
        //             TextEditingController committeeController =
        //                 TextEditingController(text: 'Tourism');
        //             members = await ref
        //                 .read(getAllMembersInCommitteeProvider(CommitteeParams(
        //               committeeName: committeeController.text,
        //               coopUid: ref.watch(userProvider)!.currentCoop!,
        //             )).future);

        //             members = members!
        //                 .where(
        //                     (member) => !drivers.values.contains(member.name))
        //                 .toList();
        //             if (context.mounted) {
        //               return showModalBottomSheet(
        //                 context: context,
        //                 builder: (builder) {
        //                   return Container(
        //                     padding: const EdgeInsets.all(
        //                         10.0), // Padding for overall container
        //                     child: Column(
        //                       children: [
        //                         // Optional: Add a title or header for the modal
        //                         Padding(
        //                           padding: const EdgeInsets.symmetric(
        //                               vertical: 10.0),
        //                           child: Text(
        //                             "Members (${committeeController.text})",
        //                             style: const TextStyle(
        //                               fontSize: 18.0,
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ),
        //                         Expanded(
        //                           child: ListView.builder(
        //                             itemCount: members!.length,
        //                             itemBuilder: (context, index) {
        //                               return ListTile(
        //                                 title: Text(
        //                                   members![index].name,
        //                                   style: const TextStyle(
        //                                       fontSize:
        //                                           16.0), // Adjust font size
        //                                 ),
        //                                 onTap: () {
        //                                   setState(() {
        //                                     drivers[members![index].uid!] =
        //                                         members[index]
        //                                             .name; // Add to the map
        //                                     assignedNames
        //                                         .add(members[index].name);
        //                                   });
        //                                   Navigator.pop(
        //                                       context); // Use Navigator.pop to close the bottom sheet
        //                                 },

        //                                 // Optional: Add trailing icons or actions
        //                               );
        //                             },
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   );
        //                 },
        //               );
        //             }
        //           },
        //           style: FilledButton.styleFrom(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(
        //                   4.0), // Adjust the radius as needed
        //             ),
        //           ),
        //           child: const Text('Add Driver')),
        //     ),
        //   ],
        // ),
        addNotes(notes),
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
    final location = ref.read(listingLocationProvider);

    if (location != null) {
      _addressController.text = location;
    }
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
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          onTap: () async {
            await context.push('/select_location', extra: 'listing');
          }),

      const SizedBox(height: 10),

      // Google Map
      GestureDetector(
        onVerticalDragUpdate: (details) {},
        child: SizedBox(
          height: 400,
          child: MapWidget(address: _addressController.text),
        ),
      ),

      const SizedBox(height: 10),
    ]);
  }

  Widget addSuppDetails(BuildContext context) {
    final pickupPoint = ref.read(pickupPointLocationProvider);
    final destination = ref.read(destinationLocationProvider);

    if (pickupPoint != null) {
      _pickupController.text = pickupPoint;
    }

    if (destination != null) {
      _destinationController.text = destination;
    }
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
          border: OutlineInputBorder(),
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep the label always visible
          hintText: "8:30",
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: startDate,
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
          border: OutlineInputBorder(),
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keep the label always visible
          hintText: "5:30",
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: endDate,
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

        const SizedBox(height: 15),
        const Text('Pickup & Destination',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Add your pickup and destination point...',
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
        ),
        const SizedBox(height: 10),
        TextFormField(
            controller: _pickupController,
            decoration: const InputDecoration(
                labelText: 'Pickup*',
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: "Address*"),
            readOnly: true,
            onTap: () async {
              // make this pop another page so that
              await context.push('/select_location', extra: 'pickup');
            }),
        // Google Map
        const SizedBox(height: 10),
        TextFormField(
          controller: _destinationController,
          decoration: const InputDecoration(
              labelText: 'Destination*',
              border: OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: "Address*"),
          readOnly: true,
          onTap: () async {
            // make this pop another page so that
            await context.push('/select_location', extra: 'destination');
          },
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onVerticalDragUpdate: (details) {},
          child: SizedBox(
            height: 400,
            child: TwoMarkerMapWidget(
                pickup: _pickupController.text,
                destination: _destinationController.text),
          ),
        ),
        const SizedBox(height: 10),
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
              title: const Text('Whole Day Price',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text("₱${_feeController.text}"),
            ),
            ListTile(
              title: const Text('Price By Hour',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text("₱${_byHourFeeController.text} / per hour"),
            )
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
            const ListTile(
              title: Text('Travel Time',
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
        return addVehicleDetails(context);
      case 3:
        return addSuppDetails(context);
      case 4:
        return addLocation(context);
      case 5:
        return addListingPhotos(context);
      // case 6:
      // return addFixedTasks(context);
      case 6:
        return addPolicies(context);
      default:
        return chooseType(context);
    }
  }

  Widget addVehicleDetails(BuildContext context) {
    return Column(children: [
      Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.2,
          child: FilledButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      child: AlertDialog(
                        contentPadding: const EdgeInsets.all(10),
                        title: const Text('Create Vehicle'),
                        content: showAddVehicleForm(),
                      ),
                    );
                  });
            },
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    8.0), // Adjust the border radius as needed
              ),
            ),
            child: const Text('Add Vehicle'),
          ),
        ),
      ),
      const SizedBox(height: 20),
      vehicleInfoCard(),
    ]);
  }

  ListView vehicleInfoCard() {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: availableTransports.length,
        itemBuilder: ((context, transportIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('[${transportIndex + 1}]'),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Vehicle No: ${availableTransports[transportIndex].vehicleNo}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .3,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        availableTransports.removeAt(transportIndex);
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * .1),
                child: Row(
                  children: [
                    Text(
                      'Capacity: ${availableTransports[transportIndex].guests} | ',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      'Luggage: ${availableTransports[transportIndex].luggage}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              availableTransports.isEmpty
                  ? SizedBox(
                      height: MediaQuery.sizeOf(context).height / 4,
                      width: double.infinity,
                      child: const Center(child: Text("No Vehicles Added")))
                  : Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.sizeOf(context).width * .1),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing:
                            8, // Adjust the spacing between items as needed
                        runSpacing:
                            8, // Adjust the run spacing (vertical spacing) as needed
                        children: List.generate(
                          availableTransports[transportIndex]
                              .departureTimes!
                              .length,
                          (index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                availableTransports[transportIndex]
                                    .departureTimes![index]
                                    .format(context),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            );
                          },
                        ),
                      ),
                    )
            ],
          );
        }));
  }

  Widget showAddVehicleForm() {
    TextEditingController vehicleNoController = TextEditingController();
    TextEditingController departureController = TextEditingController();
    List<TimeOfDay> departureTimes = [];
    num capacity = 0;
    num luggage = 0;
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  controller: vehicleNoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Vehicle No",
                      floatingLabelBehavior: FloatingLabelBehavior
                          .always, // Keep the label always visible
                      hintText: "",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  })),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: departureController,
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
                      departureTimes.add(time);
                      departureController.text = time.format(context);
                    });
                  }
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .16,
            width: MediaQuery.sizeOf(context).width * 4,
            child: departureTimes.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: departureTimes.length,
                    itemBuilder: (context, timeIndex) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 25),
                        leading: Text('[${timeIndex + 1}]'),
                        title: Text(
                          departureTimes[timeIndex].format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              departureTimes.removeAt(timeIndex);
                            });
                          },
                          icon: const Icon(Icons.close),
                          iconSize: 14,
                        ),
                      );
                    })
                : const Center(
                    child: Text('No Departure Times',
                        style: TextStyle(fontWeight: FontWeight.w300))),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height / 50),
          ListTile(
              horizontalTitleGap: 0,
              title: const Text('Passengers', style: TextStyle(fontSize: 14)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (capacity >= 1) {
                        setState(() {
                          capacity--;
                        });
                      }
                    }),
                Text("$capacity", style: const TextStyle(fontSize: 16)),
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        capacity++;
                      });
                    })
              ])),
          ListTile(
              title: const Text(
                'Luggage',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (luggage >= 1) {
                        setState(() {
                          luggage--;
                        });
                      }
                    }),
                Text("$luggage", style: const TextStyle(fontSize: 16)),
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        luggage++;
                      });
                    })
              ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text("Close")),
              const SizedBox(
                width: 10,
              ),
              FilledButton(
                  onPressed: () {
                    AvailableTransport transport = AvailableTransport(
                        available: true,
                        vehicleNo: num.parse(vehicleNoController.text),
                        departureTimes: departureTimes,
                        guests: capacity,
                        luggage: luggage,
                        workingDays: workingDays,
                        startTime: startDate,
                        endTime: endDate);
                    this.setState(() {
                      int index = availableTransports.indexWhere((element) =>
                          element.vehicleNo ==
                          num.parse(vehicleNoController.text));
                      if (index == -1) {
                        availableTransports.add(transport);
                      } else {
                        availableTransports[index] = transport;
                      }
                    });
                    context.pop();
                  },
                  child: const Text("Confirm")),
            ],
          )
        ]),
      );
    });
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

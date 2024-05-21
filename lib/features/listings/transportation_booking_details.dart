// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/emergency_process_dialog.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';
import 'package:url_launcher/url_launcher.dart';

class TransportationBookingsDetails extends ConsumerStatefulWidget {
  final ListingBookings booking;
  final ListingModel listing;
  const TransportationBookingsDetails({
    super.key,
    required this.booking,
    required this.listing,
  });

  @override
  ConsumerState<TransportationBookingsDetails> createState() =>
      _TransportationBookingsDetailsState();
}

class _TransportationBookingsDetailsState
    extends ConsumerState<TransportationBookingsDetails> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100.0, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100.0, child: Tab(child: Text('Tasks'))),
    const SizedBox(width: 100.0, child: Tab(child: Text('Expenses'))),
  ];
  late ListingBookings modifiableBooking;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('MMMM dd').format(widget.booking.startDate!);
    String formattedEndDate =
        DateFormat('MMMM dd').format(widget.booking.endDate!);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          // ref.read(navBarVisibilityProvider.notifier).show();
        },
        child: DefaultTabController(
            initialIndex: 0,
            length: tabs.length,
            child: ref
                .watch(getBookingByIdProvider(
                    (widget.listing.uid!, widget.booking.id!)))
                .when(
                    data: (booking) {
                      modifiableBooking = booking;
                      return Scaffold(
                        resizeToAvoidBottomInset: true,
                        appBar: _appBar("Booking Details", context),
                        body: StatefulBuilder(
                          builder: (context, setState) {
                            return TabBarView(
                              children: [
                                showDetails(context, widget.booking),
                                showTasks(booking),
                                expenses(),
                              ],
                            );
                          },
                        ),
                        bottomNavigationBar: BottomAppBar(
                            surfaceTintColor: Colors.white,
                            height: 90,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FilledButton(
                                              style: ButtonStyle(
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(
                                                  const Size(100, 45),
                                                ),
                                              ),
                                              onPressed: () {
                                                showAddTaskDialog(
                                                    context, booking);
                                              },
                                              child: const Text('Add Task')))),
                                  Flexible(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FilledButton(
                                              style: ButtonStyle(
                                                minimumSize:
                                                    MaterialStateProperty.all<
                                                        Size>(
                                                  const Size(100, 45),
                                                ),
                                              ),
                                              onPressed: () {
                                                showAddExpenseDialog(
                                                    context, booking);
                                              },
                                              child:
                                                  const Text('Add Expense'))))
                                ])),
                      );
                    },
                    error: ((error, stackTrace) =>
                        ErrorText(error: error.toString(), stackTrace: '')),
                    loading: () => const Loader())));
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
        title: Text(title,
            style:
                const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        bottom: TabBar(
            tabAlignment: TabAlignment.center,
            labelPadding: EdgeInsets.zero,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs));
  }

  Future<dynamic> showAddTaskDialog(
      BuildContext context, ListingBookings booking) {
    List<String> notes = [
      "'Open for Contribution' will make this task available for other members to accomplish."
    ];
    return showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to close the dialog
        builder: (BuildContext context) {
          TextEditingController nameOfTaskController = TextEditingController();
          TextEditingController committeeController =
              TextEditingController(text: "Tourism");
          bool openContribution = false;
          List<String> assignedIds = [];
          List<String> assignedNames = [];
          List<CooperativeMembers>? members;
          return Dialog.fullscreen(
            child: StatefulBuilder(builder: (context, setState) {
              return Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  IconButton(
                    iconSize: 30,
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                ]),
                const Text('Add Task',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        TextFormField(
                            controller: nameOfTaskController,
                            decoration: const InputDecoration(
                                labelText: 'Task Name*',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: 'Assigned Driver')),
                        const SizedBox(height: 10),
                        TextFormField(
                            controller: committeeController,
                            decoration: const InputDecoration(
                                labelText: 'Committee Assigned*',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: Icon(Icons.arrow_drop_down)),
                            readOnly: true,
                            enabled: false,
                            onTap: () {}),
                        const SizedBox(height: 10),
                        Column(children: [
                          TextFormField(
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  labelText: 'Members Assigned*',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  hintText: 'Press to select member'),
                              readOnly: true,
                              canRequestFocus: false,
                              onTap: () async {
                                members = await ref.read(
                                    getAllMembersInCommitteeProvider(
                                            CommitteeParams(
                                                coopUid: ref
                                                    .watch(userProvider)!
                                                    .currentCoop!,
                                                committeeName:
                                                    committeeController.text))
                                        .future);
                                members = members!
                                    .where((member) =>
                                        !assignedNames.contains(member.name))
                                    .toList();
                                if (context.mounted) {
                                  return showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: Text(
                                                        "Members in ${committeeController.text}",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Expanded(
                                                    child: ListView.builder(
                                                        itemCount:
                                                            members!.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                index) {
                                                          return ListTile(
                                                            title: Text(
                                                                members![index]
                                                                    .name,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                            onTap: () {
                                                              setState(() {
                                                                assignedIds.add(
                                                                    members![
                                                                            index]
                                                                        .uid!);
                                                                assignedNames.add(
                                                                    members![
                                                                            index]
                                                                        .name);
                                                              });
                                                              context.pop();
                                                            },
                                                          );
                                                        }))
                                              ],
                                            ));
                                      });
                                }
                              })
                        ])
                      ])),
                )),
                const SizedBox(height: 5),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.5,
                        mainAxisSpacing: 1.5,
                        mainAxisExtent: MediaQuery.sizeOf(context).height / 8),
                    itemCount: assignedNames.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(children: [
                                IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        assignedNames.removeAt(index);
                                      });
                                    }),
                                Expanded(
                                    child: Text(assignedNames[index],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis)))
                              ])));
                    }),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        value: openContribution,
                        onChanged: (value) {
                          setState(() {
                            openContribution = value!;
                          });
                        },
                      )),
                  const Text("Open for Contribution",
                      style: TextStyle(fontSize: 18))
                ]),
                const SizedBox(height: 20),
                addNotes(notes),
                SizedBox(height: MediaQuery.sizeOf(context).height / 20),
                ElevatedButton(
                    onPressed: () {
                      BookingTask bookingTask = BookingTask(
                          listingName: widget.listing.title,
                          status: 'Incomplete',
                          listingId: widget.listing.uid,
                          assignedIds: assignedIds,
                          assignedNames: assignedNames,
                          committee: committeeController.text,
                          complete: false,
                          openContribution: openContribution,
                          name: nameOfTaskController.text);

                      if (nameOfTaskController.text.isNotEmpty) {
                        List<BookingTask> bookingTasks =
                            booking.tasks?.toList(growable: true) ?? [];
                        bookingTasks.add(bookingTask);
                        ListingBookings updatedBooking =
                            booking.copyWith(tasks: bookingTasks);
                        ref
                            .read(listingControllerProvider.notifier)
                            .updateBooking(context, widget.listing.uid!,
                                updatedBooking, "Booking updated!");
                      }
                    },
                    child: const Text("Add Task"))
              ]);
            }),
          );
        });
  }

  Column addNotes(
    List<String> notes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      lines: 3,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              );
            }))
      ],
    );
  }

  Future<void> showAddExpenseDialog(
      BuildContext context, ListingBookings booking) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController costController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        List<Expense>? expenses = booking.expenses?.toList(growable: true) ??
            []; // Local list to hold expenses
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Scrollable list of expenses
                    // Form to add new expense, always visible
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    TextFormField(
                      controller: costController,
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          costController.text.isNotEmpty) {
                        booking = booking.copyWith(expenses: expenses);
                        // ref
                        //     .read(listingControllerProvider.notifier)
                        //     // .updateBookingExpenses(
                        //     //     context, widget.listing.uid!, booking);
                      } else {
                        context.pop();
                      }
                    }),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // Add logic to handle the input data
                    String name = nameController.text;
                    num cost = num.parse(costController.text);
                    setState(() {
                      expenses.add(Expense(cost: cost, name: name));

                      debugPrint("$expenses");
                      if (nameController.text.isNotEmpty &&
                          costController.text.isNotEmpty) {
                        booking = booking.copyWith(expenses: expenses);
                        // ref
                        //     .read(listingControllerProvider.notifier)
                        //     .updateBookingExpenses(
                        //         context, widget.listing.uid!, booking);
                      }
                    });
                    nameController.clear();
                    costController.clear();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget showDetails(BuildContext context, ListingBookings booking) {
    Map<String, Map<String, dynamic>> generalActions = {
      "contact": {
        "icon": Icons.call,
        "title": "Contact Passengers",
        "action": () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Contact'),
                  content: ListTile(
                    onTap: () async {
                      // ignore: deprecated_member_use
                      await launch("tel://${booking.emergencyContactNo}");
                    },
                    leading: const Icon(Icons.phone_rounded),
                    title: Text(
                      booking.emergencyContactName ?? "No Emergency Contact",
                      style: const TextStyle(
                        fontSize: 16, // Set your desired font size
                        // Add other styling as needed
                      ),
                    ),
                    subtitle: Text(
                      booking.emergencyContactNo ??
                          "No Emergency Contact Number",
                      style: TextStyle(
                        fontSize: 14, // Slightly smaller than the title
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                        // You can add other styling as needed
                      ),
                    ),
                    // Arrow Trailing
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  ),
                  actions: [
                    FilledButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Close'))
                  ],
                );
              });
        },
      },
      "emergency": {
        "icon": Icons.emergency,
        "title": "Emergency",
        "action": () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Emergency Guide'),
                  content: const Text(
                      "An emergency would be a situation wherein the service provider cannot provide their service."),
                  actions: [
                    FilledButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('Close')),
                    FilledButton(
                        onPressed: () {
                          emergencyProcess(ref, context, 'Transport',
                              booking: booking);
                        },
                        child: const Text('Continue')),
                  ],
                );
              });
        }
      },
    };
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * .4,
            child: const Placeholder(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Departure',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Text(DateFormat('E, MMM d').format(booking.startDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // departure time
                        Text(
                          TimeOfDay.fromDateTime(booking.startDate!)
                              .format(context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height / 7.5,
                  width: 1,
                  color: Colors.grey, // Choose the color of the line
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _displaySubHeader('Arrival'),
                        const SizedBox(height: 10),
                        Text(DateFormat('E, MMM d').format(booking.endDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // Checkout time
                        Text(
                          TimeOfDay.fromDateTime(booking.endDate!)
                              .format(context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _displaySubtitleText('Vehicle No: ${booking.vehicleNo}'),
                    Container(
                        height: MediaQuery.sizeOf(context).height * .05,
                        width: 1,
                        color: Colors.grey),
                    _displaySubtitleText('Passengers: ${booking.guests}'),
                    Container(
                        height: MediaQuery.sizeOf(context).height * .05,
                        width: 1,
                        color: Colors.grey),
                    _displaySubtitleText('Luggage: ${booking.luggage}'),
                  ],
                ),
                const SizedBox(height: 10),
                ...generalActions.entries.map((entry) {
                  final generalAction = entry.value;
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ), // Adjust the padding as needed
                        child: const Divider(
                          color: Colors.grey,
                          height: 1.0,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          generalAction['icon'],
                          size: 20,
                        ),
                        title: Text(generalAction['title'],
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)),
                        onTap: generalAction["action"],
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                _displaySubHeader("Booking Details"),
                // ref.watch(getUserDataProvider(booking.customerId)).maybeWhen(
                //       data: (user) {
                //         return _userInformation(user, booking);
                //       },
                //       orElse: () =>
                //           const Center(child: CircularProgressIndicator()),
                //     ),
                // No of Guests
                const SizedBox(height: 10),

                _displayDivider(),
                const SizedBox(height: 10),

                _displaySubHeader("Additional Information"),
                const SizedBox(height: 10),
                // Government ID
                _displayGovId(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showTasks(ListingBookings booking) {
    return ref
        .watch(getBookingTasksByBookingId((booking.listingId, booking.id!)))
        .when(
          data: (List<BookingTask>? bookingTasks) {
            return bookingTasks == null || bookingTasks.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: const Center(child: Text("No Tasks Listed")),
                  )
                : ListView.builder(
                    itemCount: bookingTasks.length,
                    itemBuilder: (context, taskIndex) {
                      String proofNote;
                      if (bookingTasks[taskIndex].imageProof != null) {
                        proofNote = "Proof Available";
                      } else {
                        proofNote = "No Proof Available";
                      }
                      return Card(
                        margin: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            ListTile(
                              leading: bookingTasks[taskIndex].status ==
                                      'Pending'
                                  ? const Text('Pending')
                                  : Checkbox(
                                      value: bookingTasks[taskIndex].complete,
                                      onChanged: null,
                                    ),
                              title: Text(
                                bookingTasks[taskIndex].name,
                                style: const TextStyle(
                                  fontSize: 16, // Set your desired font size
                                  // Add other styling as needed
                                ),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    showNotesDialog(
                                        context, bookingTasks[taskIndex]);
                                  },
                                  icon: const Icon(Icons.comment_outlined)),
                              subtitle: Text(
                                "Assigned: ${bookingTasks[taskIndex].assignedNames.join(", ")}",
                                style: TextStyle(
                                  fontSize:
                                      14, // Slightly smaller than the title
                                  color: Colors
                                      .grey[600], // Grey color for the subtitle
                                  // You can add other styling as needed
                                ),
                              ),
                              onTap:
                                  bookingTasks[taskIndex].status != 'Completed'
                                      ? () {
                                          showMarkAsDoneDialog(
                                              context, bookingTasks[taskIndex]);
                                        }
                                      : null,
                            ),
                            ListTile(
                              leading: Checkbox(
                                  value:
                                      bookingTasks[taskIndex].openContribution,
                                  onChanged: (value) {
                                    String title = "";
                                    String note = "";
                                    if (value == true) {
                                      title =
                                          "Activate \"Open for Contribution\"";
                                      note =
                                          "Activating \"Open for Contribution\" will make this task visible to other cooperative members, giving them the opportunity to help.";
                                    } else {
                                      title =
                                          "Deactivate Open for Contribution";
                                      note =
                                          "Deactivating Open for Contribution will make this task private to the assigned members.";
                                    }
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          false, // User must tap button to close the dialog
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            title,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(note),
                                          actions: <Widget>[
                                            TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  context.pop();
                                                }),
                                            TextButton(
                                              child: const Text('Confirm'),
                                              onPressed: () {
                                                List<BookingTask>
                                                    updatedBookingTasks =
                                                    bookingTasks.toList(
                                                        growable: true);
                                                updatedBookingTasks[taskIndex] =
                                                    bookingTasks[taskIndex]
                                                        .copyWith(
                                                            openContribution:
                                                                value!);
                                                ListingBookings updatedBooking =
                                                    booking.copyWith(
                                                        tasks:
                                                            updatedBookingTasks);
                                                debugPrint("$updatedBooking");

                                                ref
                                                    .read(
                                                        listingControllerProvider
                                                            .notifier)
                                                    .updateBookingTask(
                                                        context,
                                                        widget.listing.uid!,
                                                        updatedBookingTasks[
                                                            taskIndex],
                                                        "Tasks Updated");
                                                context.pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                              title: const Text("Open for Contribution"),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 25,
                              width: MediaQuery.sizeOf(context).width * .6,
                              child: FilledButton(
                                onPressed: bookingTasks[taskIndex].imageProof !=
                                        null
                                    ? () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                insetPadding:
                                                    const EdgeInsets.all(0),
                                                child: ImageSlider(
                                                    images:
                                                        bookingTasks[taskIndex]
                                                            .imageProof!
                                                            .map((image) =>
                                                                image.url)
                                                            .toList(),
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height /
                                                        3,
                                                    width: MediaQuery.sizeOf(
                                                            context)
                                                        .width,
                                                    radius: BorderRadius.zero),
                                              );
                                            });
                                      }
                                    : null,
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(
                                      0), // Removes the shadow/elevation
                                  backgroundColor:
                                      proofNote == "No Proof Available"
                                          ? MaterialStateProperty.all(
                                              Colors.transparent)
                                          : null,

                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          4.0), // Adjust the radius as needed
                                    ),
                                  ),
                                  // Apply additional styling as needed
                                ),
                                child: Text(proofNote,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: proofNote == "No Proof Available"
                                            ? Colors.black
                                            : Colors.white)),
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              indent: 20,
                              endIndent: 20,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      );
                    },
                  );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
            stackTrace: '',
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }

  Expanded tasks() {
    List<BookingTask> bookingTasks =
        widget.booking.tasks?.toList(growable: true) ?? [];
    return Expanded(
        child: bookingTasks.isEmpty
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: const Center(child: Text("No Tasks Listed")),
              )
            : ListView.builder(
                itemCount: bookingTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      bookingTasks[index].name,
                      style: const TextStyle(
                        fontSize: 14, // Set your desired font size
                        // Add other styling as needed
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Keep the row tight around its children
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              bookingTasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }));
  }

  Expanded expenses() {
    List<Expense>? expenses =
        widget.booking.expenses?.toList(growable: true) ?? [];
    return Expanded(
      child: expenses.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: const Center(child: Text("No Expenses Listed")),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(
                    expense.name,
                    style: const TextStyle(
                      fontSize: 14, // Set your desired font size
                      // Add other styling as needed
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Keep the row tight around its children
                    children: [
                      Text(
                        "₱${expense.cost.toString()}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            expenses.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<dynamic> showNotesDialog(
      BuildContext context, BookingTask bookingTask) {
    List<BookingTaskMessage>? notes =
        bookingTask.notes?.toList(growable: true) ?? [];
    TextEditingController messageController = TextEditingController();
    notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Notes',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            InkWell(
                onTap: () {
                  context.pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 20,
                ))
          ]),
          content: SizedBox(
            height: MediaQuery.of(context).size.height /
                1.5, // Set a fixed height for the ListView
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, messageIndex) {
                      final message = notes[messageIndex];
                      return Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message.senderName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(DateFormat('MMM d HH:mm')
                                    .format(message.timestamp)),
                              ],
                            ),
                            Text(message.content),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the border radius as needed
                color:
                    Colors.white, // Set the background color of the input field
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                      ),
                      maxLines: null, // Allow multiple lines
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      String content = messageController.text;
                      messageController.clear();
                      final user = ref.read(userProvider);
                      BookingTaskMessage message = BookingTaskMessage(
                          listingName: bookingTask.listingName,
                          senderId: user!.uid,
                          senderName: user.name,
                          taskId: bookingTask.uid!,
                          timestamp: DateTime.now(),
                          content: content);
                      notes.add(message);
                      BookingTask updatedBookingTask =
                          bookingTask.copyWith(notes: notes);

                      ref
                          .read(listingControllerProvider.notifier)
                          .updateBookingTask(context, bookingTask.listingId!,
                              updatedBookingTask, '');
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.deepOrange[400],
                    ), // Set the color of the send icon
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showMarkAsDoneDialog(
      BuildContext context, BookingTask bookingTask) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(bookingTask.name),
            titleTextStyle: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
            actions: [
              FilledButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Back'),
              ),
              FilledButton(
                onPressed: bookingTask.status == 'Pending'
                    ? () {
                        BookingTask updatedBookingTask = bookingTask.copyWith(
                            complete: true, status: 'Completed');
                        ref
                            .read(listingControllerProvider.notifier)
                            .updateBookingTask(
                                context,
                                updatedBookingTask.listingId!,
                                updatedBookingTask,
                                'Task updated successfully!');
                        context.pop();
                      }
                    : null,
                child: bookingTask.status == 'Pending'
                    ? const Text('Mark as Done')
                    : const Text('Pending'),
              )
            ],
          );
        });
  }

  Text _displaySubHeader(String subHeader) {
    return Text(
      subHeader,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        // Add other styling as needed
      ),
    );
  }

  Divider _displayDivider() {
    return Divider(
      thickness: 1.0,
      indent: 20,
      endIndent: 20,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
    );
  }

  ListTile _displayGovId() {
    return ListTile(
      onTap: () {},
      leading: const Icon(Icons.card_membership_rounded),
      title: const Text(
        'Customer Government ID',
        style: TextStyle(
          fontSize: 16, // Set your desired font size
          // Add other styling as needed
        ),
      ),
      // Arrow Trailing
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 20,
      ),
    );
  }

  // ListTile _userInformation(UserModel user, ListingBookings booking) {
  //   return ListTile(
  //     onTap: () {
  //       // Show user profile
  //     },
  //     leading: CircleAvatar(
  //       radius: 15.0,
  //       backgroundImage: user.imageUrl != null && user.imageUrl != ''
  //           ? NetworkImage(user.imageUrl!)
  //           // Use placeholder image if user has no profile pic
  //           : const AssetImage('lib/core/images/default_profile_pic.jpg')
  //               as ImageProvider,
  //     ),
  //     // Contact owner
  //     trailing: IconButton(
  //       onPressed: () {
  //         // Show snackbar with reviews
  //         showSnackBar(context, 'Contact owner');
  //       },
  //       icon: const Icon(Icons.message_rounded),
  //     ),
  //     title: Text(
  //       booking.customerName,
  //       style: const TextStyle(
  //           fontSize: 16, // Set your desired font size
  //           fontWeight: FontWeight.w500
  //           // Add other styling as needed
  //           ),
  //     ),
  //     subtitle: const Text(
  //       '1 month in lakbay',
  //       style: TextStyle(
  //         fontSize: 14, // Slightly smaller than the title
  //         fontWeight: FontWeight.w300,
  //         // You can add other styling as needed
  //       ),
  //     ),
  //   );
  // }

  Widget _displaySubtitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    );
  }
}

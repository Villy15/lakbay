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
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

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
          ref.read(navBarVisibilityProvider.notifier).show();
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
                                bookingDetails(context, formattedStartDate,
                                    formattedEndDate),
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

  // create _tasks
  Widget bookingDetails(BuildContext context, String formattedStartDate,
      String formattedEndDate) {
    if (widget.booking.typeOfTrip == 'Two Way Trip') {
      return Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    'First Trip: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedStartDate,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 19.0,
                        ),
                      ),
                      Text(
                          'Departure Time: ${DateFormat('h:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.booking.startTime!.hour, widget.booking.startTime!.minute))}'),
                      Text(
                          'Pickup Point: ${widget.listing.availableTransport!.pickupPoint}'),
                      Text(
                          'Destination: ${widget.listing.availableTransport!.destination}'),
                      const SizedBox(height: 10),
                      // show map widget
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: MapWidget(
                              address: widget
                                  .listing.availableTransport!.destination),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Last Trip: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedEndDate,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 19.0,
                        ),
                      ),
                      Text(
                          'Departure Time: ${DateFormat('h:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.booking.endTime!.hour, widget.booking.endTime!.minute))}'),
                      Text(
                          'Pickup Point: ${widget.listing.availableTransport!.destination}'),
                      Text(
                          'Destination: ${widget.listing.availableTransport!.pickupPoint}'),
                      const SizedBox(height: 10),
                      // show map widget
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: MapWidget(
                              address: widget
                                  .listing.availableTransport!.pickupPoint),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(children: [
        Expanded(
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'Trip: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedStartDate,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 19.0,
                      ),
                    ),
                    Text(
                        'Departure Time: ${DateFormat('h:mm a').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.booking.startTime!.hour, widget.booking.startTime!.minute))}'),
                    Text(
                        'Pickup Point: ${widget.listing.availableTransport!.pickupPoint}'),
                    Text(
                        'Destination: ${widget.listing.availableTransport!.destination}'),
                    const SizedBox(height: 10),
                    // show map widget
                    Center(
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: MapWidget(
                            address:
                                widget.listing.availableTransport!.destination),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ],
          ),
        )
      ]);
    }
  }

  Widget showTasks(ListingBookings booking) {
    return booking.tasks == null || booking.tasks!.isEmpty
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height / 5,
            child: const Center(
              child: Text("No Tasks Listed"),
            ),
          )
        : ListView.builder(
            itemCount: booking.tasks!.length,
            itemBuilder: (context, index) {
              String proofNote;
              if (booking.tasks![index].imageProof != null) {
                proofNote = "Proof Submitted";
              } else {
                proofNote = "No Proof Submitted";
              }
              return Column(children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Checkbox(
                        value: booking.tasks![index].complete,
                        onChanged: null,
                      ),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                            Text(booking.tasks![index].name,
                                style: const TextStyle(
                                  fontSize: 16, // Set your desired font size
                                )),
                            Text(
                                "Assigned: ${booking.tasks![index].assignedNames.join(",")}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]))
                          ]))
                    ]),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Checkbox(
                      value: booking.tasks![index].openContribution,
                      onChanged: (value) {
                        String title = "";
                        String note = "";
                        if (value == true) {
                          title = "Activate \"Open for Contribution\"";
                          note =
                              "This will allow other members to contribute to this task";
                        } else {
                          title = "Deactivate \"Open for Contribution\"";
                          note =
                              "This will disallow other members to contribute to this task";
                        }
                        showDialog<void>(
                            context: context,
                            barrierDismissible:
                                false, // User must tap button to close the dialog
                            builder: (context) {
                              return AlertDialog(
                                  title: Text(title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  content: Text(note,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      )),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        context.pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Confirm'),
                                      onPressed: () {
                                        List<BookingTask> bookingTasks = booking
                                            .tasks!
                                            .toList(growable: true);
                                        bookingTasks[index] =
                                            bookingTasks[index].copyWith(
                                                openContribution: value!);
                                        ListingBookings updatedBooking = booking
                                            .copyWith(tasks: bookingTasks);
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .updateBookingTask(
                                                context,
                                                widget.listing.uid!,
                                                bookingTasks[index],
                                                "Task/s updated!");
                                        context.pop();
                                      },
                                    )
                                  ]);
                            });
                      })
                ])
              ]);
            });
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
}

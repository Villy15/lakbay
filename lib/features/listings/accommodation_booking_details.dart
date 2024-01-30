// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

class AccommodationBookingsDetails extends ConsumerStatefulWidget {
  final ListingBookings booking;
  final ListingModel listing;
  const AccommodationBookingsDetails({
    super.key,
    required this.booking,
    required this.listing,
  });

  @override
  ConsumerState<AccommodationBookingsDetails> createState() =>
      _AccommodationBookingsDetailsState();
}

class _AccommodationBookingsDetailsState
    extends ConsumerState<AccommodationBookingsDetails> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Tasks'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Expenses'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          // fontFamily: 'Satisfy',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
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

  Widget showExpenses(ListingBookings booking) {
    return booking.expenses == null || booking.expenses!.isEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: const Center(child: Text("No Expenses Listed")),
          )
        : ListView.builder(
            itemCount: booking.expenses!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  booking.expenses![index].name,
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
                      "₱${booking.expenses![index].cost.toString()}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          booking.expenses!.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
  }

  Future<void> showAddExpenseForm(
      BuildContext context, ListingBookings booking) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController costController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
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
                      context.pop();
                    }),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // Add logic to handle the input data
                    String name = nameController.text;
                    num cost = num.parse(costController.text);
                    debugPrint("${booking.expenses}");
                    if (nameController.text.isNotEmpty &&
                        costController.text.isNotEmpty) {
                      Expense expense = Expense(cost: cost, name: name);
                      List<Expense> expenses =
                          booking.expenses?.toList(growable: true) ?? [];
                      expenses.add(expense);

                      ListingBookings updatedBooking =
                          booking.copyWith(expenses: expenses);

                      ref
                          .read(listingControllerProvider.notifier)
                          .updateBooking(context, widget.listing.uid!,
                              updatedBooking, "Expense Updated");
                    }
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

  Widget showTasks(ListingBookings booking) {
    return booking.tasks == null || booking.tasks!.isEmpty
        ? SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: const Center(child: Text("No Tasks Listed")),
          )
        : ListView.builder(
            itemCount: booking.tasks!.length,
            itemBuilder: (context, taskIndex) {
              return Container(
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Checkbox(
                          value: booking.tasks![taskIndex].complete,
                          onChanged: null,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                booking.tasks![taskIndex].name,
                                style: const TextStyle(
                                  fontSize: 16, // Set your desired font size
                                  // Add other styling as needed
                                ),
                              ),
                              Text(
                                "Assigned: ${booking.tasks![taskIndex].assigned.join(", ")}",
                                style: TextStyle(
                                  fontSize:
                                      14, // Slightly smaller than the title
                                  color: Colors
                                      .grey[600], // Grey color for the subtitle
                                  // You can add other styling as needed
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Checkbox(
                          value: booking.tasks![taskIndex].openContribution,
                          onChanged: (value) {
                            setState(() {
                              booking.tasks![taskIndex] = booking
                                  .tasks![taskIndex]
                                  .copyWith(openContribution: value!);
                            });
                          }),
                      const Text("Open for Contribution"),
                    ]),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2,
                      child: ElevatedButton(
                        onPressed: booking.tasks![taskIndex].imageProof != null
                            ? () {
                                // Your function here when imageProof is not empty
                              }
                            : null,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(
                              1), // Removes the shadow/elevation
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    20), // Adjust the radius as needed
                                topRight: Radius.circular(
                                    20), // Adjust the radius as needed
                                bottomLeft:
                                    Radius.zero, // Flat bottom left corner
                                bottomRight:
                                    Radius.zero, // Flat bottom right corner
                              ),
                            ),
                          ),
                          // Apply additional styling as needed
                        ),
                        child: const Text("View Proof"),
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
  }

  Future<dynamic> showAddTaskForm(
      BuildContext context, ListingBookings booking) {
    List<String> notes = [
      "'Open for Contribution' will make this task available for other members to accomplish."
    ];
    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController taskNameController = TextEditingController();
          TextEditingController committeeController =
              TextEditingController(text: "Tourism");
          bool openContribution = false;
          List<String> assignedMembers = [];
          return Dialog.fullscreen(
            child: StatefulBuilder(builder: (context, setTaskState) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        iconSize: 30, // Set the icon size here
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons
                              .arrow_back, // Removed the size property from here
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Add Task",
                    style: TextStyle(
                      fontSize: 20, // Choose your desired size
                      fontWeight: FontWeight.bold, // Makes the text bold
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
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
                              hintText: "Prepare Room For Guests",
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
                              suffixIcon: Icon(
                                  Icons.arrow_drop_down), // Dropdown arrow icon
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
                                  List<CooperativeMembers> members = await ref
                                      .read(getAllMembersInCommitteeProvider(
                                          CommitteeParams(
                                    committeeName: committeeController.text,
                                    coopUid:
                                        ref.watch(userProvider)!.currentCoop!,
                                  )).future);

                                  members = members
                                      .where((member) => !assignedMembers
                                          .contains(member.name))
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                  itemCount: members.length,
                                                  itemBuilder:
                                                      (context, membersIndex) {
                                                    return ListTile(
                                                      title: Text(
                                                        members[membersIndex]
                                                            .name,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                16.0), // Adjust font size
                                                      ),
                                                      onTap: () {
                                                        setTaskState(
                                                          () {
                                                            assignedMembers.add(
                                                                members[membersIndex]
                                                                    .name);
                                                          },
                                                        );
                                                        context.pop();
                                                      },
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
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 items per row
                                  crossAxisSpacing:
                                      1.5, // Space between cards horizontally
                                  mainAxisSpacing: 1.5,
                                  mainAxisExtent:
                                      MediaQuery.sizeOf(context).height /
                                          8, // Space between cards vertically
                                ),
                                itemCount: assignedMembers
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
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 16,
                                              ), // 'X' icon
                                              onPressed: () {
                                                setTaskState(
                                                  () {
                                                    assignedMembers
                                                        .removeAt(index);
                                                  },
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                assignedMembers[
                                                    index], // Replace with the name from your data
                                                style: const TextStyle(
                                                  fontSize:
                                                      14, // Adjust text style
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale:
                                    1.5, // Adjust the scale to increase the size of the checkbox
                                child: Checkbox(
                                  value: openContribution,
                                  onChanged: (value) {
                                    setTaskState(() {
                                      openContribution = value!;
                                    });
                                  },
                                ),
                              ),
                              const Text(
                                "Open for Contribution",
                                style: TextStyle(
                                  fontSize:
                                      18, // Adjust the font size for larger text
                                  // Add other styling as needed
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          addNotes(notes),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Task task = Task(
                                    assigned: assignedMembers,
                                    committee: committeeController.text,
                                    complete: false,
                                    openContribution: openContribution,
                                    name: taskNameController.text);

                                debugPrintJson("$task");
                                if (taskNameController.text.isNotEmpty) {
                                  List<Task> tasks =
                                      booking.tasks?.toList(growable: true) ??
                                          [];
                                  tasks.add(task);
                                  ListingBookings updatedBooking =
                                      booking.copyWith(tasks: tasks);
                                  debugPrint("$updatedBooking");
                                  ref
                                      .read(listingControllerProvider.notifier)
                                      .updateBooking(
                                          context,
                                          widget.listing.uid!,
                                          updatedBooking,
                                          "Tasks Updated");
                                }
                                taskNameController.dispose;
                              },
                              child: const Text("Add Task")),
                        ]),
                      ),
                    ),
                  ),
                ],
              );
            }),
          );
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
      },
      child: DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: ref
              .watch(getBookingByIdProvider(
                  (widget.listing.uid!, widget.booking.id!)))
              .when(
                data: (booking) {
                  return Scaffold(
                    resizeToAvoidBottomInset: true,
                    // Add appbar with back button
                    appBar: _appBar(
                        "$formattedStartDate - $formattedEndDate", context),
                    body: StatefulBuilder(builder: (context, setState) {
                      return TabBarView(
                        children: [
                          showTasks(booking),
                          showExpenses(booking),
                        ],
                      );
                    }),

                    bottomNavigationBar: BottomAppBar(
                      surfaceTintColor: Colors.white,
                      height: 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                // Make it wider
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(180, 45)),
                                ),
                                onPressed: () {
                                  showAddTaskForm(context, booking);
                                },
                                child: const Text('Add Task'),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                // Make it wider
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(180, 45)),
                                ),
                                onPressed: () {
                                  showAddExpenseForm(context, booking);
                                },
                                child: const Text('Add Expense'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                  stackTrace: '',
                ),
                loading: () => const Loader(),
              )),
    );
  }
}

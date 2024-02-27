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
import 'package:lakbay/models/user_model.dart';
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
        // icon: Icon(Icons.location_pin),
        child: Text('Details'),
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
  late ListingBookings modifiableBooking;
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

  Widget showDetails(ListingBookings booking) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Information
            _displayHeader("Booking Details"),
            const SizedBox(height: 10),
            _displaySubHeader("Check In and Check Out"),
            _displayCheckInCheckOut(booking),
            _displayDivider(),
            const SizedBox(height: 10),
            _displaySubHeader("Customer Information"),
            ref.watch(getUserDataProvider(booking.customerId)).maybeWhen(
                  data: (user) {
                    return _userInformation(user, booking);
                  },
                  orElse: () => const CircularProgressIndicator(),
                ),
            // No of Guests
            const SizedBox(height: 10),
            _displaySubHeader("No of Guests"),
            Text(
              'Guests: ${booking.guests}',
            ),
            _displayDivider(),
            const SizedBox(height: 10),
            _displaySubHeader("Payment Information"),
            Text(
              'Payment Option: ${booking.paymentOption}',
            ),
            Text(
              'Total Amount: ${booking.amountPaid}',
            ),
            Text(
              'Amount Due: ${booking.totalPrice}',
            ),
            _displayDivider(),
            const SizedBox(height: 10),
            _displayHeader("Additional Information"),
            const SizedBox(height: 10),
            // Government ID
            _displayGovId(),
            // Emergency Contact
            const SizedBox(height: 10),
            _displaySubHeader("Emergency Contact"),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.phone_rounded),
              title: Text(
                booking.emergencyContactName ?? "No Emergency Contact",
                style: const TextStyle(
                  fontSize: 16, // Set your desired font size
                  // Add other styling as needed
                ),
              ),
              subtitle: Text(
                booking.emergencyContactNo ?? "No Emergency Contact Number",
                style: TextStyle(
                  fontSize: 14, // Slightly smaller than the title
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                  // You can add other styling as needed
                ),
              ),
              // Arrow Trailing
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
              ),
            ),
          ],
        ),
      ),
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

  Divider _displayDivider() {
    return Divider(
      thickness: 1.0,
      indent: 20,
      endIndent: 20,
      color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
    );
  }

  Widget _displayCheckInCheckOut(ListingBookings booking) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Starts
              const Text(
                'Starts',
                style: TextStyle(
                  fontSize: 14, // Set your desired font size
                  fontWeight: FontWeight.bold,
                  // Add other styling as needed
                ),
              ),
              // Tue, Aug 29, 2024
              Text(
                DateFormat('E, MMM dd, yyyy').format(booking.startDate!),
                style: const TextStyle(
                  fontSize: 16, // Set your desired font size
                  fontWeight: FontWeight.bold,
                  // Add other styling as needed
                ),
              ),
              // 9:00 AM
              Text(
                DateFormat('h:mm a').format(booking.startDate!),
                style: const TextStyle(
                  fontSize: 14, // Set your desired font size
                  // Add other styling as needed
                ),
              ),
            ],
          ),
          // Divider
          const VerticalDivider(
            thickness: 1.5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Starts
              const Text(
                'Ends',
                style: TextStyle(
                  fontSize: 14, // Set your desired font size
                  fontWeight: FontWeight.bold,
                  // Add other styling as needed
                ),
              ),
              // Tue, Aug 29, 2024
              Text(
                DateFormat('E, MMM dd, yyyy').format(booking.endDate!),
                style: const TextStyle(
                  fontSize: 16, // Set your desired font size
                  fontWeight: FontWeight.bold,
                  // Add other styling as needed
                ),
              ),
              // 9:00 AM
              Text(
                DateFormat('h:mm a').format(booking.endDate!),
                style: const TextStyle(
                  fontSize: 14, // Set your desired font size
                  // Add other styling as needed
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  ListTile _userInformation(UserModel user, ListingBookings booking) {
    return ListTile(
      onTap: () {
        // Show user profile
      },
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.imageUrl != null && user.imageUrl != ''
            ? NetworkImage(user.imageUrl!)
            // Use placeholder image if user has no profile pic
            : const AssetImage('lib/core/images/default_profile_pic.jpg')
                as ImageProvider,
      ),
      // Contact owner
      trailing: IconButton(
        onPressed: () {
          // Show snackbar with reviews
          showSnackBar(context, 'Contact owner');
        },
        icon: const Icon(Icons.message_rounded),
      ),
      title: Text(
        booking.customerName,
        style: const TextStyle(
          fontSize: 16, // Set your desired font size
          // Add other styling as needed
        ),
      ),
      subtitle: Text(
        '1 month in lakbay',
        style: TextStyle(
          fontSize: 14, // Slightly smaller than the title
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          // You can add other styling as needed
        ),
      ),
    );
  }

  Text _displayHeader(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        // Add other styling as needed
      ),
    );
  }

  // display sub details
  Text _displaySubHeader(String subHeader) {
    return Text(
      subHeader,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        // Add other styling as needed
      ),
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
              String proofNote;
              if (booking.tasks![taskIndex].imageProof != null) {
                proofNote = "Proof Available";
              } else {
                proofNote = "No Proof Available";
              }
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
                                "Assigned: ${booking.tasks![taskIndex].assignedNames.join(", ")}",
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
                            String title = "";
                            String note = "";
                            if (value == true) {
                              title = "Activate \"Open for Contribution\"";
                              note =
                                  "Activating \"Open for Contribution\" will make this task visible to other cooperative members, giving them the opportunity to help.";
                            } else {
                              title = "Deactivate Open for Contribution";
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
                                        List<BookingTask> bookingTasks = booking
                                            .tasks!
                                            .toList(growable: true);
                                        bookingTasks[taskIndex] = booking
                                            .tasks![taskIndex]
                                            .copyWith(openContribution: value!);
                                        ListingBookings updatedBooking = booking
                                            .copyWith(tasks: bookingTasks);
                                        debugPrint("$updatedBooking");

                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .updateBookingTask(
                                                context,
                                                widget.listing.uid!,
                                                bookingTasks[taskIndex],
                                                "Tasks Updated");
                                        context.pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                      const Text("Open for Contribution"),
                    ]),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 25,
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
                        child: Text(proofNote),
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
          List<String> assignedIds = [];
          List<String> assignedNames = [];
          List<CooperativeMembers>? members;
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
                                  members = await ref.read(
                                      getAllMembersInCommitteeProvider(
                                          CommitteeParams(
                                    committeeName: committeeController.text,
                                    coopUid:
                                        ref.watch(userProvider)!.currentCoop!,
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
                                                  itemCount: members!.length,
                                                  itemBuilder:
                                                      (context, membersIndex) {
                                                    return ListTile(
                                                      title: Text(
                                                        members![membersIndex]
                                                            .name,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                16.0), // Adjust font size
                                                      ),
                                                      onTap: () {
                                                        setTaskState(
                                                          () {
                                                            assignedIds.add(
                                                                members![
                                                                        membersIndex]
                                                                    .uid!);
                                                            assignedNames.add(
                                                                members![
                                                                        membersIndex]
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
                                                    assignedNames
                                                        .removeAt(index);
                                                  },
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                assignedNames[
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
                                BookingTask bookingTask = BookingTask(
                                    assignedIds: assignedIds,
                                    assignedNames: assignedNames,
                                    committee: committeeController.text,
                                    complete: false,
                                    openContribution: openContribution,
                                    name: taskNameController.text);

                                debugPrintJson("$bookingTask");
                                if (taskNameController.text.isNotEmpty) {
                                  List<BookingTask> bookingTasks =
                                      booking.tasks?.toList(growable: true) ??
                                          [];
                                  bookingTasks.add(bookingTask);
                                  ListingBookings updatedBooking =
                                      booking.copyWith(tasks: bookingTasks);
                                  debugPrint("$updatedBooking");
                                  ref
                                      .read(listingControllerProvider.notifier)
                                      .updateBookingTask(
                                          context,
                                          widget.listing.uid!,
                                          bookingTask,
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
                    // Add appbar with back button
                    appBar: _appBar(
                        "$formattedStartDate - $formattedEndDate", context),
                    body: StatefulBuilder(builder: (context, setState) {
                      return TabBarView(
                        children: [
                          showTasks(booking),
                          showDetails(booking),
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

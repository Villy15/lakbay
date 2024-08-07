import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/departure_details.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/emergency_process_dialog.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';
import 'package:url_launcher/url_launcher.dart';

class EntertainmentBookingDetails extends ConsumerStatefulWidget {
  final ListingBookings booking;
  final ListingModel listing;
  const EntertainmentBookingDetails({
    super.key,
    required this.booking,
    required this.listing,
  });

  @override
  ConsumerState<EntertainmentBookingDetails> createState() => _EntertainmentBookingDetailsState();
}

class _EntertainmentBookingDetailsState extends ConsumerState<EntertainmentBookingDetails> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Details'),
      ),
    ),
  ];

  late ListingBookings modifiableBooking;
  late Widget map;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    map = MapWidget(
      address: widget.listing.address,
    );
    modifiableBooking = widget.booking;
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
                FilledButton(
                    child: const Text('Close'),
                    onPressed: () {
                      context.pop();
                    }),
                FilledButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // Add logic to handle the input data
                    String name = nameController.text;
                    num cost = num.parse(costController.text);
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
    Map<String, Map<String, dynamic>> generalActions = {
      "contact": {
        "icon": Icons.call,
        "title": "Contact Guest",
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
    };
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children:[
                Container(
                  foregroundDecoration: BoxDecoration(
                    color: widget.booking.bookingStatus == 'Emergency Request' ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.0),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .4,
                    child: map
                  )
                ),
                Padding(
                  padding:  const EdgeInsets.only(top: 60.0, left: 30),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.booking.bookingStatus == 'Emergency Request' ? 'Emergency Request\nOn-Going' : '',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          )
                        )
                      )
                    ]
                    
                  ),
                )
              ]
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
                            'Start Time:',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500
                            )
                          ),
                          const SizedBox(height: 10),
                          Text(
                            DateFormat('E, MMM d').format(booking.startDate!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ) 
                          ),
                          Text(
                            TimeOfDay.fromDateTime(
                              widget.booking.startDate!
                            ).format(context),
                            style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300
                            )
                          ),
                          const SizedBox(height: 10)
                        ]
                      )
                    )
                  ),
                  const VerticalDivider(
                    color: Colors.grey,
                    thickness: 5,
                    width: 10,
                    indent: 0,
                    endIndent: 0,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _displaySubHeader('End Time:'),
                          const SizedBox(height: 10),
                          Text(
                            DateFormat('E, MMM d').format(booking.endDate!),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            )
                          ),
                          Text(
                            TimeOfDay.fromDateTime(
                              widget.booking.endDate!
                            ).format(context),
                            style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300
                            )
                          ),
                          const SizedBox(height: 10)
                        ],
                      )
                    )
                  )
                ]
              )
            ),
            const SizedBox(height: 10),
            // display the title of the trip
            ...generalActions.entries.map((entry) {
              final generalAction = entry.value;
              return Column(
                children: [
                  ListTile(
                    onTap: generalAction['action'],
                    leading: Icon(generalAction['icon'], size: 20),
                    title: Text(
                      generalAction['title'],
                      style: const TextStyle(
                        fontSize: 14, // Set your desired font size
                        // Add other styling as needed
                      ),
                    ),
                    // Arrow Trailing
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  ),
                ],
              );
            })

          ]
        )
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

  ListTile _userInformation(UserModel user, ListingBookings booking) {
    return ListTile(
      onTap: () {
        context.push('/profile/id/${user.uid}');
      },
      leading: CircleAvatar(
        radius: 15.0,
        backgroundImage: user.profilePic != ''
            ? NetworkImage(user.profilePic)
            // Use placeholder image if user has no profile pic
            : const AssetImage('lib/core/images/default_profile_pic.jpg')
                as ImageProvider,
      ),
      // Contact owner
      trailing: IconButton(
        onPressed: () {
          // createRoom(context, user.uid, ref.watch(userProvider)!);
        },
        icon: const Icon(Icons.message_rounded),
      ),
      title: Text(
        booking.customerName,
        style: const TextStyle(
            fontSize: 16, // Set your desired font size
            fontWeight: FontWeight.w500
            // Add other styling as needed
            ),
      ),
      subtitle: const Text(
        '1 month in lakbay',
        style: TextStyle(
          fontSize: 14, // Slightly smaller than the title
          fontWeight: FontWeight.w300,
          // You can add other styling as needed
        ),
      ),
    );
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
                            // If there are contributors, show them
                            bookingTasks[taskIndex].contributorsNames != null &&
                                    bookingTasks[taskIndex]
                                        .contributorsNames!
                                        .isNotEmpty
                                ? ListTile(
                                    leading: bookingTasks[taskIndex].status ==
                                            'Pending'
                                        ? const Text('Pending')
                                        : Checkbox(
                                            value: bookingTasks[taskIndex]
                                                .complete,
                                            onChanged: null,
                                          ),
                                    title: Text(
                                      bookingTasks[taskIndex].name,
                                      style: const TextStyle(
                                        fontSize:
                                            16, // Set your desired font size
                                        // Add other styling as needed
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          showNotesDialog(
                                              context, bookingTasks[taskIndex]);
                                        },
                                        icon:
                                            const Icon(Icons.comment_outlined)),
                                    subtitle: Text(
                                      "Contributors: ${bookingTasks[taskIndex].contributorsNames?.join(", ")}",
                                      style: TextStyle(
                                        fontSize:
                                            14, // Slightly smaller than the title
                                        color: Colors.grey[
                                            600], // Grey color for the subtitle
                                        // You can add other styling as needed
                                      ),
                                    ),
                                    onTap: bookingTasks[taskIndex].status !=
                                            'Completed'
                                        ? () {
                                            showMarkAsDoneDialog(context,
                                                bookingTasks[taskIndex]);
                                          }
                                        : null,
                                  )
                                : const SizedBox(),
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
                                                  growable: true,
                                                );
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
                                      borderRadius:
                                          BorderRadius.circular(4.0), // Adjus
                                      side: BorderSide(
                                        color: proofNote == "No Proof Available"
                                            ? Colors
                                                .grey // Border color when proofNote is "No Proof Available"
                                            : Colors
                                                .transparent, // Transparent border color otherwise
                                        width: 1, // Border width
                                      ),
                                    ),
                                  ),
                                  // Apply additional styling as needed
                                ),
                                child: Text(proofNote,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: proofNote == "No Proof Available"
                                            ? Colors.grey
                                            : Colors.white)),
                              ),
                            ),
                            Divider(
                              thickness: 1.5,
                              indent: 20,
                              endIndent: 20,
                              color: Colors.grey[400],
                            ),
                            // FilledButton where I can contribute to the task
                            bookingTasks[taskIndex].openContribution
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilledButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Contribute to Task'),
                                                  // Content where its a text Do you wanna contribute to this task?
                                                  content: const Text(
                                                      'Do you want to contribute to this task?'),
                                                  actions: [
                                                    FilledButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () {
                                                        contributeTask(
                                                            bookingTasks[
                                                                taskIndex]);
                                                      },
                                                      child:
                                                          const Text('Confirm'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: const Text('Contribute')),
                                  )
                                : const SizedBox(),
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

  void contributeTask(BookingTask bookingTask) {
    // Edit the task to make Open for Contribution false
    BookingTask updatedBookingTask = bookingTask.copyWith(
      openContribution: false,
      contributorsIds: [ref.read(userProvider)!.uid],
      contributorsNames: [ref.read(userProvider)!.name],
    );

    ref.read(listingControllerProvider.notifier).updateBookingTask(
        context,
        updatedBookingTask.listingId!,
        updatedBookingTask,
        "Task updated successfully!");

    context.pop();
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
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .5,
                            child: FilledButton(
                                onPressed: () {
                                  BookingTask bookingTask = BookingTask(
                                      listingName: widget.listing.title,
                                      listingId: widget.listing.uid,
                                      status: 'Incomplete',
                                      assignedIds: assignedIds,
                                      assignedNames: assignedNames,
                                      committee: committeeController.text,
                                      complete: false,
                                      openContribution: openContribution,
                                      name: taskNameController.text);

                                  if (taskNameController.text.isNotEmpty) {
                                    List<BookingTask> bookingTasks =
                                        booking.tasks?.toList(growable: true) ??
                                            [];
                                    bookingTasks.add(bookingTask);

                                    ref
                                        .read(
                                            listingControllerProvider.notifier)
                                        .updateBookingTask(
                                            context,
                                            widget.listing.uid!,
                                            bookingTask,
                                            "Tasks Updated");
                                  }
                                  taskNameController.dispose;

                                  // use sendTaskNotification to send a notification to the assigned members
                                  sendTaskNotification(context, ref,
                                      assignedIds, taskNameController.text);
                                },
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        4.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: const Text("Add Task")),
                          ),
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

  Future<void> sendTaskNotification(BuildContext context, WidgetRef ref,
      List<String> assignedIds, String taskName) async {
    for (String userId in assignedIds) {
      final taskNotif = NotificationsModel(
          title: 'New Task!',
          message:
              'You have been added to do the task: $taskName. Navigate to the booking under tasks to view more details.',
          ownerId: userId,
          bookingId: widget.booking.id!,
          listingId: widget.listing.uid!,
          type: 'task',
          isToAllMembers: false,
          createdAt: DateTime.now(),
          isRead: false);

      await ref
          .read(notificationControllerProvider.notifier)
          .addNotification(taskNotif, context);
    }
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
            width: MediaQuery.of(context).size.width /
                1.5, // Set a fixed width for the ListView
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

  Widget _displaySubtitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    );
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
                    // Add appbar with back button
                    appBar: _appBar(
                        "$formattedStartDate - $formattedEndDate", context),
                    body: StatefulBuilder(builder: (context, setState) {
                      return TabBarView(
                        children: [
                          showDetails(booking),
                        ],
                      );
                    }),
                  );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                  stackTrace: '',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              )),
    );
  }
}
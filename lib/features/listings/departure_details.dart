// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/emergency_process_dialog.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/committee_params.dart';

class DepartureDetails extends ConsumerStatefulWidget {
  final DepartureModel departure;
  final ListingModel listing;
  const DepartureDetails({
    super.key,
    required this.departure,
    required this.listing,
  });

  @override
  ConsumerState<DepartureDetails> createState() => _DepartureDetailsState();
}

late DepartureModel departureDetails;

class _DepartureDetailsState extends ConsumerState<DepartureDetails> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100.0, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100.0, child: Tab(child: Text('Passengers'))),
  ];
  late ListingBookings modifiableBooking;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    departureDetails = widget.departure;
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = DateFormat('MMMM dd')
        .format(departureDetails.passengers.first.startDate!);
    String formattedEndDate = DateFormat('MMMM dd')
        .format(departureDetails.passengers.first.endDate!);
    num passengerCount = 0;
    for (var booking in departureDetails.passengers) {
      if (booking.vehicleNo == departureDetails.vehicle?.vehicleNo) {
        passengerCount = passengerCount + booking.guests;
      }
    }

    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          // ref.read(navBarVisibilityProvider.notifier).show();
        },
        child: DefaultTabController(
            initialIndex: 0,
            length: tabs.length,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: _appBar("Booking Details", context),
              body: StatefulBuilder(
                builder: (context, setState) {
                  return TabBarView(
                    children: [
                      details(
                          context, departureDetails.passengers, passengerCount),
                      passengers(departureDetails.passengers),
                    ],
                  );
                },
              ),
            )));
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

  Widget details(BuildContext context, List<ListingBookings> bookings,
      num passengerCount) {
    Map<String, Map<String, dynamic>> generalActions = {
      "contact": {
        "icon": Icons.call,
        "title": "Contact Passengers",
        "action": () {},
      },
      "emergency": {
        "icon": Icons.emergency,
        "title": "Emergency",
        "action": () {}
      },
    };
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * .4,
            child: TwoMarkerMapWidget(
                destination: widget.listing.destination ?? '',
                pickup: widget.listing.pickUp ?? ''),
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
                        Text(
                            DateFormat('E, MMM d')
                                .format(bookings.first.startDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // departure time
                        Text(
                          TimeOfDay.fromDateTime(bookings.first.startDate!)
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
                        Text(
                            DateFormat('E, MMM d')
                                .format(bookings.first.endDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // Checkout time
                        Text(
                          TimeOfDay.fromDateTime(bookings.first.endDate!)
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
                    InkWell(
                      onTap: () async {
                        Query query = FirebaseFirestore.instance
                            .collectionGroup('availableTransport')
                            .where('listingId', isEqualTo: widget.listing.uid);
                        List<AvailableTransport> vehicles = await ref.read(
                            getTransportByPropertiesProvider(query).future);
                        List<AvailableTransport> filteredVehicles = [];

                        for (var vehicle in vehicles) {
                          if (vehicle.departureTimes?.contains(
                                  TimeOfDay.fromDateTime(departureDetails
                                      .passengers.first.startDate!)) ==
                              true) {
                            filteredVehicles.add(vehicle);
                          }
                        }
                        if (mounted) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Select Vehicle'),
                                  actions: [
                                    FilledButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('Close'))

                                  ],
                                  content: SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        .3,
                                    width: MediaQuery.sizeOf(context).width * .5,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: vehicles.length,
                                        itemBuilder: (context, index) {
                                          AvailableTransport vehicle =
                                              vehicles[index];
                                          return InkWell(
                                            onTap: () {
                                              for (var booking in bookings) {
                                                ListingBookings updatedBooking =
                                                    booking.copyWith(
                                                        vehicleNo:
                                                            vehicle.vehicleNo);
                                                ref
                                                    .read(
                                                        listingControllerProvider
                                                            .notifier)
                                                    .updateBooking(
                                                        context,
                                                        widget.listing.uid!,
                                                        updatedBooking,
                                                        "Booking updated!");
                                              }
                                              setState(() {
                                                departureDetails =
                                                    departureDetails.copyWith(
                                                        vehicle: vehicle);
                                              });
                                              context.pop();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('[${index + 1}]'),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      "Vehicle No: ${vehicle.vehicleNo}",
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          .3,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: MediaQuery.sizeOf(
                                                                  context)
                                                              .width *
                                                          .1),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Capacity: ${vehicle.guests} | ',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300),
                                                      ),
                                                      Text(
                                                        'Luggage: ${vehicle.luggage}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w300),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _displaySubtitleText(
                            'Vehicle No: ${departureDetails.vehicle?.vehicleNo ?? 'Not Set'}'),
                      ),
                    ),
                    Container(
                        height: MediaQuery.sizeOf(context).height * .05,
                        width: 1,
                        color: Colors.grey),
                    _displaySubtitleText('Passengers: $passengerCount'),
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

  ListTile _userInformation(UserModel user, ListingBookings booking) {
    return ListTile(
      onTap: () {
        // Show user profile
      },
      leading: CircleAvatar(
        radius: 15.0,
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

  Widget _displaySubtitleText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
    );
  }

  Widget passengers(List<ListingBookings> bookings) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final passenger = bookings[index];
          return ListTile(
            leading: Text(
              '${passenger.guests}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            title: Text(
              passenger.customerName,
            ),
            subtitle: _displaySubtitleText(passenger.customerPhoneNo),
          );
        });
  }
}

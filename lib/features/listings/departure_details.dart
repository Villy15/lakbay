// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
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
Map<num, num> passengerCount = {};

class _DepartureDetailsState extends ConsumerState<DepartureDetails> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100.0, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100.0, child: Tab(child: Text('Passengers'))),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    departureDetails = widget.departure;
  }

  @override
  void dispose() {
    passengerCount.clear(); // Clear the map when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = DateFormat('MMMM dd')
        .format(departureDetails.passengers.first.startDate!);
    String formattedEndDate = DateFormat('MMMM dd')
        .format(departureDetails.passengers.first.endDate!);

    for (var vehicle in departureDetails.vehicles!) {
      passengerCount[vehicle.vehicle!.vehicleNo!] = 0;
    }
    for (var booking in departureDetails.passengers) {
      if (booking.vehicleNo != null) {
        passengerCount[booking.vehicleNo!] =
            passengerCount[booking.vehicleNo!]! + booking.guests;
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
              appBar: _appBar("Departure Details", context),
              body: StatefulBuilder(
                builder: (context, setState) {
                  return TabBarView(
                    children: [
                      details(context),
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

  Widget details(
    BuildContext context,
  ) {
    Query query = FirebaseFirestore.instance
        .collectionGroup('availableTransport')
        .where('listingId', isEqualTo: widget.listing.uid);
    Map<String, Map<String, dynamic>> generalActions = {
      "contact": {
        "icon": Icons.call,
        "title": "Contact Passengers",
        "action": () {},
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
                              departureDetails: departureDetails);
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
            child: TwoMarkerMapWidget(
                destination: widget.departure.destination ?? '',
                pickup: widget.departure.pickUp ?? ''),
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
                                .format(departureDetails.departure!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // departure time
                        Text(
                          TimeOfDay.fromDateTime(departureDetails.departure!)
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
                                .format(departureDetails.arrival!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // Checkout time
                        Text(
                          TimeOfDay.fromDateTime(departureDetails.arrival!)
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
                ref.watch(getTransportByPropertiesProvider(query)).when(
                      data: (List<AvailableTransport> vehicles) {
                        List<AvailableTransport> filteredVehicles = [];
                        for (var vehicle in vehicles) {
                          if (vehicle.departureTimes!.contains(
                              TimeOfDay.fromDateTime(
                                  departureDetails.departure!))) {
                            filteredVehicles.add(vehicle);
                          }
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredVehicles.length,
                            itemBuilder: (context, vehicleIndex) {
                              final vehicle = filteredVehicles[vehicleIndex];
                              return Container(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Vehicle Information'),
                                                content: SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          .1,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          1,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text.rich(
                                                          TextSpan(
                                                            text: 'Capacity: ',
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '${vehicle.guests}',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                ),
                                                actions: [
                                                  FilledButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      child:
                                                          const Text('Close'))
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: _displaySubtitleText(
                                          'Vehicle No: ${vehicle.vehicleNo ?? 'Not Set'}',
                                        ),
                                      ),
                                    ),
                                    Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                .05,
                                        width: 1,
                                        color: Colors.grey),
                                    InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: _displaySubtitleText(
                                            'Passengers: ${passengerCount[vehicle.vehicleNo]}'),
                                      ),
                                      onTap: () async {
                                        selectPassengerDialog(context, vehicle);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: '',
                      ),
                      loading: () => const Loader(),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> selectPassengerDialog(
      BuildContext context, AvailableTransport vehicle) {
    List<ListingBookings> boardedPassengers = [];
    List<ListingBookings> notBoardedPassengers = [];
    for (var booking in departureDetails.passengers) {
      if (booking.vehicleNo == vehicle.vehicleNo) {
        boardedPassengers.add(booking);
      } else if (booking.vehicleNo == null) {
        notBoardedPassengers.add(booking);
      }
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select Passengers'),
            actions: [
              FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Close'))
            ],
            content: SizedBox(
              height: MediaQuery.sizeOf(context).height * .5,
              width: MediaQuery.sizeOf(context).height * 1,
              child: StatefulBuilder(builder: (context, setPassengers) {
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Boarded',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: boardedPassengers.length,
                              itemBuilder: (context, boardedIndex) {
                                final booking = boardedPassengers[boardedIndex];
                                return InkWell(
                                  onTap: () {
                                    ListingBookings updatedPassenger =
                                        booking.copyWith(vehicleNo: null);
                                    setPassengers(() {
                                      notBoardedPassengers
                                          .add(updatedPassenger);
                                      boardedPassengers.remove(booking);
                                    });

                                    List<AssignedVehicle>
                                        updatedAssignedVehicles = [];
                                    AssignedVehicle updatedAssignedVehicle =
                                        AssignedVehicle(
                                            vehicle: vehicle.copyWith(
                                                vehicleNo: vehicle.vehicleNo),
                                            passengers: boardedPassengers);
                                    for (var currentVehicle
                                        in departureDetails.vehicles!) {
                                      if (vehicle.vehicleNo ==
                                          currentVehicle.vehicle!.vehicleNo) {
                                        updatedAssignedVehicles
                                            .add(updatedAssignedVehicle);
                                      } else {
                                        updatedAssignedVehicles
                                            .add(currentVehicle);
                                      }
                                    }
                                    List<ListingBookings> updatedPassengers =
                                        [];
                                    for (var passenger
                                        in notBoardedPassengers) {
                                      updatedPassengers.add(passenger);
                                    }
                                    for (var passenger in boardedPassengers) {
                                      updatedPassengers.add(passenger);
                                    }

                                    DepartureModel updatedDeparture =
                                        departureDetails.copyWith(
                                            passengers: updatedPassengers,
                                            vehicles: updatedAssignedVehicles);

                                    ref
                                        .read(
                                            listingControllerProvider.notifier)
                                        .updateDeparture(
                                            context, updatedDeparture, '');
                                    ListingBookings updatedBooking = booking
                                        .copyWith(vehicleNo: vehicle.vehicleNo);
                                    ref
                                        .read(
                                            listingControllerProvider.notifier)
                                        .updateBooking(
                                            context,
                                            booking.listingId,
                                            updatedBooking,
                                            '');
                                    setState(() {
                                      departureDetails = updatedDeparture;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Text(
                                          '${booking.guests}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        title: Text(
                                          booking.customerName,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Not Boarded',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: notBoardedPassengers.length,
                              itemBuilder: (context, notBoardedIndex) {
                                final booking =
                                    notBoardedPassengers[notBoardedIndex];
                                return InkWell(
                                  onTap: () {
                                    ListingBookings updatedPassenger = booking
                                        .copyWith(vehicleNo: vehicle.vehicleNo);
                                    setPassengers(() {
                                      boardedPassengers.add(updatedPassenger);
                                      notBoardedPassengers.remove(booking);
                                    });
                                    List<AssignedVehicle>
                                        updatedAssignedVehicles = [];
                                    AssignedVehicle updatedAssignedVehicle =
                                        AssignedVehicle(
                                            vehicle: vehicle,
                                            passengers: boardedPassengers);
                                    for (var currentVehicle
                                        in departureDetails.vehicles!) {
                                      if (currentVehicle.vehicle!.vehicleNo ==
                                          updatedAssignedVehicle
                                              .vehicle!.vehicleNo) {
                                        updatedAssignedVehicles
                                            .add(updatedAssignedVehicle);
                                      } else {
                                        updatedAssignedVehicles
                                            .add(currentVehicle);
                                      }
                                    }
                                    List<ListingBookings> updatedPassengers =
                                        [];
                                    for (var passenger in boardedPassengers) {
                                      updatedPassengers.add(passenger);
                                    }

                                    for (var passenger
                                        in notBoardedPassengers) {
                                      updatedPassengers.add(passenger);
                                    }
                                    DepartureModel updatedDeparture =
                                        departureDetails.copyWith(
                                            passengers: updatedPassengers,
                                            vehicles: updatedAssignedVehicles);

                                    ref
                                        .read(
                                            listingControllerProvider.notifier)
                                        .updateDeparture(
                                            context, updatedDeparture, '');
                                    ListingBookings updatedBooking = booking
                                        .copyWith(vehicleNo: vehicle.vehicleNo);
                                    ref
                                        .read(
                                            listingControllerProvider.notifier)
                                        .updateBooking(
                                            context,
                                            booking.listingId,
                                            updatedBooking,
                                            '');
                                    setState(() {
                                      departureDetails = updatedDeparture;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Text(
                                          '${booking.guests}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        title: Text(
                                          booking.customerName,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
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
            trailing: Text('Vehicle No: ${passenger.vehicleNo ?? 'Not Set'}'),
          );
        });
  }
}

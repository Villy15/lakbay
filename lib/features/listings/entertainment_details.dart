// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_local_variable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/emergency_process_dialog.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:slider_button/slider_button.dart';

class EntertainmentDetails extends ConsumerStatefulWidget {
  final List<ListingBookings> bookings;
  final ListingModel listing;
  const EntertainmentDetails({
    super.key,
    required this.bookings,
    required this.listing,
  });

  @override
  ConsumerState<EntertainmentDetails> createState() =>
      _EntertainmentDetailsState();
}

Map<num, num> passengerCount = {};
late Widget map;
AssignedVehicle? selectedVehicle;
late List<ListingBookings> bookings;

class _EntertainmentDetailsState extends ConsumerState<EntertainmentDetails> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100.0, child: Tab(child: Text('Details'))),
    const SizedBox(width: 100.0, child: Tab(child: Text('Guests'))),
    // const SizedBox(width: 100.0, child: Tab(child: Text('Expenses'))),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    map = MapWidget(
      address: widget.listing.address,
    );
    bookings = widget.bookings;
  }

  @override
  void dispose() {
    passengerCount.clear(); // Clear the map when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('MMMM dd').format(widget.bookings.first.startDate!);
    String formattedEndDate =
        DateFormat('MMMM dd').format(widget.bookings.first.endDate!);
    Query query = FirebaseFirestore.instance
        .collection("listings")
        .doc(widget.listing.uid)
        .collection("bookings")
        .where('listingId', isEqualTo: widget.listing.uid)
        .where('startDate',
            isEqualTo: Timestamp.fromDate(bookings.first.startDate!));

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
              appBar: _appBar("${widget.listing.type} Details", context),
              // bottomNavigationBar: ["Waiting", "OnGoing"]
              //         .contains(departureDetails.departureStatus)
              //     ? BottomAppBar(
              //         height: MediaQuery.sizeOf(context).height / 8,
              //         surfaceTintColor: Colors.transparent,
              //         child: SizedBox(
              //           width: MediaQuery.of(context).size.width * 0.8,
              //           child: getDepartureStatus(),
              //         ),
              //       )
              //     : null,
              body: ref.watch(getBookingsByPropertiesProvider(query)).when(
                    data: (List<ListingBookings> bookings) {
                      // Get all listings by the cooperative
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return TabBarView(
                            children: [
                              details(context, bookings),
                              guests(bookings),
                            ],
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => Scaffold(
                      body: ErrorText(
                        error: error.toString(),
                        stackTrace: stackTrace.toString(),
                      ),
                    ),
                    loading: () => const Scaffold(
                      body: Loader(),
                    ),
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

  bool allCancelled() {
    return widget.bookings
        .every((booking) => booking.bookingStatus == 'Cancelled');
  }

  bool allCompleted() {
    return widget.bookings
        .every((booking) => booking.bookingStatus == 'Completed');
  }

  Widget details(BuildContext context, List<ListingBookings> bookings) {
    Map<String, Map<String, dynamic>> generalActions = {
      if (bookings.first.tourGuideId == null)
        "assignedTG": {
          "icon": Icons.person_search_outlined,
          "title": "Assign Tour Guide",
          "action": () {
            assignTourGuide(context);
          },
        },
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
                          emergencyProcess(ref, context, 'Entertainment',
                              bookings: bookings);
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
          Stack(children: [
            Container(
              foregroundDecoration: BoxDecoration(
                  color:
                      Colors.black.withOpacity((allCancelled()) ? 0.5 : 0.0)),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * .4,
                child: map,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 30),
              child: Row(
                children: [
                  Flexible(
                      child: Text(
                          allCancelled()
                              ? "Your ${widget.listing.type} Has Been Cancelled"
                              : allCompleted()
                                  ? "Your Departure Has Been Completed"
                                  : '',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.background))),
                ],
              ),
            )
          ]),
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
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Text(
                            DateFormat('E, MMM d')
                                .format(widget.bookings.first.startDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // departure time
                        Text(
                          TimeOfDay.fromDateTime(
                                  widget.bookings.first.startDate!)
                              .format(context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),

                        // departed time
                      ],
                    ),
                  ),
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
                            DateFormat('E, MMM d')
                                .format(widget.bookings.first.endDate!),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        // Checkout time
                        Text(
                          TimeOfDay.fromDateTime(widget.bookings.first.endDate!)
                              .format(context),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),

                        // departed time
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (bookings.first.tourGuideName != null &&
              widget.listing.type == "Activities/Tours")
            ListTile(
              leading: const Icon(Icons.person_4_outlined),
              title: Text(widget.bookings.first.tourGuideName!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary)),
              subtitle: const Text("Guide",
                  style: TextStyle(
                    fontSize: 12,
                  )),
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
          })
        ],
      ),
    );
  }

  Future<dynamic> assignTourGuide(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          CooperativeMembers assignedGuide = CooperativeMembers(name: "");
          return StatefulBuilder(builder: (context, setAssignedGuide) {
            return AlertDialog(
              title: const Text("Tour Guides"),
              content: SizedBox(
                height: MediaQuery.sizeOf(context).height / 4,
                child: Column(children: [
                  InkWell(
                    onTap: () async {
                      List<CooperativeMembers> members = await ref.read(
                          getAllMembersProvider(
                                  widget.listing.cooperative.cooperativeId)
                              .future);
                      List<CooperativeMembers> guides = members.where((member) {
                        return member.committees!.any(
                            (committee) => committee.role!.contains("Guide"));
                      }).toList();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Tour Guides"),
                              content: SizedBox(
                                height: MediaQuery.sizeOf(context).height / 4,
                                width: MediaQuery.sizeOf(context).width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: guides.length,
                                    itemBuilder: (context, dIndex) {
                                      var d = guides[dIndex];
                                      return ListTile(
                                          title: Text(d.name),
                                          onTap: () {
                                            setAssignedGuide(() {
                                              assignedGuide = d;
                                            });
                                            context.pop();
                                          },
                                          trailing: const Icon(
                                              size: 10,
                                              Icons.arrow_forward_ios_rounded));
                                    }),
                              ),
                              actions: [
                                FilledButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the value as needed
                                      ),
                                    ),
                                    child: const Text("Close"))
                              ],
                            );
                          });
                    },
                    child: ListTile(
                        title: Text('Tour Guide: ${assignedGuide.name}'),
                        trailing: const Icon(
                            size: 16, Icons.arrow_forward_ios_rounded)),
                  ),
                ]),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the value as needed
                    ),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    for (var booking in bookings) {
                      ListingBookings updatedBooking = booking.copyWith(
                          tourGuideId: assignedGuide.uid!,
                          tourGuideName: assignedGuide.name);
                      ref
                          .read(listingControllerProvider.notifier)
                          .updateBooking(context, updatedBooking.listingId,
                              updatedBooking, "");
                    }
                    context.pop();
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the value as needed
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            );
          });
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

  // Divider _displayDivider() {
  //   return Divider(
  //     thickness: 1.0,
  //     indent: 20,
  //     endIndent: 20,
  //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
  //   );
  // }

  // ListTile _displayGovId() {
  //   return ListTile(
  //     onTap: () {},
  //     leading: const Icon(Icons.card_membership_rounded),
  //     title: const Text(
  //       'Customer Government ID',
  //       style: TextStyle(
  //         fontSize: 16, // Set your desired font size
  //         // Add other styling as needed
  //       ),
  //     ),
  //     // Arrow Trailing
  //     trailing: const Icon(
  //       Icons.arrow_forward_ios_rounded,
  //       size: 20,
  //     ),
  //   );
  // }

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

  Widget guests(List<ListingBookings> bookings) {
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

// // ignore_for_file: unused_local_variable

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
import 'package:lakbay/features/common/widgets/bottom_nav.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';

class ManageTransportation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageTransportation({super.key, required this.listing});

  @override
  ConsumerState<ManageTransportation> createState() =>
      _ManageTransportationState();
}

class _ManageTransportationState extends ConsumerState<ManageTransportation> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Departures'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Bookings'),
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
        child: Text(
          'Departures & Vehicles',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ];
  BottomAppBar? bottomAppBar = const BottomAppBar();
  int currentTab = 0;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  TextEditingController vehicleNo = TextEditingController();
  num guests = 0;
  num luggage = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          ref.read(navBarVisibilityProvider.notifier).show();
          context.pop();
        },
        child: DefaultTabController(
            initialIndex: 0,
            length: tabs.length,
            child: Scaffold(
                appBar: AppBar(
                  title: widget.listing.title.length > 20
                      ? Text('${widget.listing.title.substring(0, 20)}...',
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold))
                      : Text(widget.listing.title,
                          style: const TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold)),
                  bottom: TabBar(
                    onTap: (tab) {
                      setState(() {
                        currentTab = tab;
                      });
                    },
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
                bottomNavigationBar: currentTab == 2
                    ? BottomAppBar(
                        child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the value as needed
                            ),
                          ),
                          child: const Text('Edit Listing'),
                        ),
                      )
                    : null,
                body: TabBarView(
                  children: [
                    departures(),
                    bookings(),
                    details(),
                    vehicles(),
                  ],
                ))));
  }

  SingleChildScrollView details() {
    List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();

    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          foregroundDecoration:
              BoxDecoration(color: Colors.black.withOpacity(0.0)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            child: TwoMarkerMapWidget(
              pickup: widget.listing.pickUp!,
              destination: widget.listing.destination!,
            ),
          )),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: DisplayText(
                text: widget.listing.title,
                lines: 2,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          DisplayText(
              text:
                  'Location: ${widget.listing.province}, ${widget.listing.city}',
              lines: 4,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelLarge?.fontSize)),
          DisplayText(
            text: "${widget.listing.category} · ${widget.listing.type}",
            lines: 1,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
            ),
          ),
          const Divider(),
          DisplayText(
            text: 'Description',
            lines: 1,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            ),
          ),
          if (widget.listing.description.length > 40) ...[
            TextInBottomSheet(
                "About this space", widget.listing.description, context)
          ] else ...[
            DisplayText(
              text: widget.listing.description,
              lines: 5,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
              ),
            )
          ],
        ]),
      ),
      const SizedBox(height: 10),
      const Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Working Hours',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              Text(
                '${widget.listing.availableTransport!.startTime!.format(context)} - ${widget.listing.availableTransport!.endTime!.format(context)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Available Days',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  getWorkingDays(
                      widget.listing.availableTransport!.workingDays!),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ]),
      ),
      const Divider(),
      ref
          .watch(
              getCooperativeProvider(widget.listing.cooperative.cooperativeId))
          .maybeWhen(
            data: (coop) {
              return ListTile(
                leading: SizedBox(
                  height: 40,
                  width: 40,
                  child: DisplayImage(
                      imageUrl: coop.imageUrl,
                      height: 40,
                      width: 40,
                      radius: BorderRadius.circular(20)),
                ),
                // Contact owner
                trailing: IconButton(
                  onPressed: () {
                    // Show snackbar with reviews
                    showSnackBar(context, 'Contact owner');
                  },
                  icon: const Icon(Icons.message_rounded),
                ),
                title: Text('Hosted by ${coop.name}',
                    style: Theme.of(context).textTheme.labelLarge),
              );
            },
            orElse: () => const ListTile(
              leading: Icon(Icons.error),
              title: Text('Error'),
              subtitle: Text('Something went wrong'),
            ),
          ),
    ]));
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
        data: (List<ListingBookings> bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No Bookings'));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: bookings.length,
                itemBuilder: ((context, index) {
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(bookings[index].startDate!);
                  String formattedStartTime =
                      TimeOfDay.fromDateTime(bookings[index].startDate!)
                          .format(context);
                  String formattedEndTime =
                      TimeOfDay.fromDateTime(bookings[index].endDate!)
                          .format(context);
                  // String formattedEndDate =
                  //     DateFormat('MMMM dd').format(bookings[index].endDate!);
                  return Card(
                      elevation: 1.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 10, top: 10, bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedStartDate,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Departure: $formattedStartTime | ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Arrival: $formattedEndTime",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Passengers: ${bookings[index].guests}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                      onPressed: () async {
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .deleteBooking(
                                                bookings[index], context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text('Delete')),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        context.push(
                                          '/market/${bookings[index].category.toLowerCase()}/booking_details',
                                          extra: {
                                            'booking': bookings[index],
                                            'listing': widget.listing
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text('Booking Details')),
                                ),
                              ],
                            ))
                      ]));
                }));
          }
        },
        error: ((error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()))),
        loading: () => const Scaffold(body: Loader()));
  }

  bool isOverlapping(
      ListingBookings newBooking, ListingBookings existingBooking) {
    DateTime newStart = DateTime(
        newBooking.startDate!.year,
        newBooking.startDate!.month,
        newBooking.startDate!.day,
        newBooking.startTime!.hour,
        newBooking.startTime!.minute);
    DateTime newEnd = DateTime(
        newBooking.endDate!.year,
        newBooking.endDate!.month,
        newBooking.endDate!.day,
        newBooking.endTime!.hour,
        newBooking.endTime!.minute);

    DateTime existingStart = DateTime(
        existingBooking.startDate!.year,
        existingBooking.startDate!.month,
        existingBooking.startDate!.day,
        existingBooking.startTime!.hour,
        existingBooking.startTime!.minute);

    DateTime existingEnd = DateTime(
        existingBooking.endDate!.year,
        existingBooking.endDate!.month,
        existingBooking.endDate!.day,
        existingBooking.endTime!.hour,
        existingBooking.endTime!.minute);

    return newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart);
  }

  String getWorkingDays(List<bool> workingDays) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> result = [];
    for (int i = 0; i < workingDays.length; i++) {
      if (workingDays[i]) {
        int start = i;
        // Find the end of this sequence of days
        while (i + 1 < workingDays.length && workingDays[i + 1]) {
          i++;
        }
        // If start and i are the same, it means only one day is available
        if (start == i) {
          result.add(daysOfWeek[start]);
        } else {
          // Else, we have a range of days
          result.add('${daysOfWeek[start]}-${daysOfWeek[i]}');
        }
      }
    }
    return result.join(', ');
  }

  List<DateTime> getAllDatesFromBookings(List<ListingBookings> bookings) {
    List<DateTime> allDates = [];

    for (ListingBookings booking in bookings) {
      // Add start date
      DateTime currentDate = booking.startDate!;

      // Keep adding dates until you reach the end date
      while (currentDate.isBefore(booking.endDate!) ||
          currentDate.isAtSameMomentAs(booking.endDate!)) {
        allDates.add(currentDate);
        // Move to next day
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return allDates;
  }

  List<List<DateTime>> getAllDateTimeRangesFromBookings(
      List<ListingBookings> bookings) {
    List<List<DateTime>> allDateTimeRanges = [];

    for (ListingBookings booking in bookings) {
      // Add start date and time
      DateTime currentDateTime = DateTime(
        booking.startDate!.year,
        booking.startDate!.month,
        booking.startDate!.day,
        booking.startTime!.hour,
        booking.startTime!.minute,
      );

      // Add end date and time
      DateTime endDateTime = DateTime(
        booking.endDate!.year,
        booking.endDate!.month,
        booking.endDate!.day,
        booking.endTime!.hour,
        booking.endTime!.minute,
      );

      // Add the DateTime range to the list
      allDateTimeRanges.add([currentDateTime, endDateTime]);
    }

    return allDateTimeRanges;
  }

  void showConfirmBooking(
      AvailableTransport transport,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String typeOfTrip) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          num guests = 0;
          num luggage = 0;
          final user = ref.read(userProvider);

          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo);
          TextEditingController emergencyContactNameController =
              TextEditingController();
          TextEditingController emergencyContactNoController =
              TextEditingController();
          bool governmentId = true;
          String formattedStartDate =
              DateFormat('MMMM dd, yyyy').format(startDate);
          String formattedEndDate = DateFormat('MMMM dd, yyyy').format(endDate);

          if (typeOfTrip == 'One Way Trip') {
            return oneWayTrip(
                formattedStartDate,
                formattedEndDate,
                transport,
                guests,
                luggage,
                phoneNoController,
                emergencyContactNameController,
                emergencyContactNoController,
                governmentId,
                startDate,
                endDate,
                startTime,
                endTime,
                typeOfTrip,
                user!);
          } else {
            return twoWayTrip(
                formattedStartDate,
                formattedEndDate,
                transport,
                guests,
                luggage,
                phoneNoController,
                emergencyContactNameController,
                emergencyContactNoController,
                governmentId,
                startDate,
                endDate,
                startTime,
                endTime,
                typeOfTrip,
                user!);
          }
        });
  }

  DraggableScrollableSheet oneWayTrip(
      String formattedStartDate,
      String formattedEndDate,
      AvailableTransport transport,
      num guests,
      num luggage,
      TextEditingController phoneNoController,
      TextEditingController emergencyContactNameController,
      TextEditingController emergencyContactNoController,
      bool governmentId,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String typeOfTrip,
      UserModel user) {
    return DraggableScrollableSheet(
        initialChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: DisplayText(
                                  text: typeOfTrip,
                                  lines: 1,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: DisplayText(
                                  text: formattedStartDate,
                                  lines: 1,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                  )),
                            ),
                            SizedBox(
                                height: MediaQuery.sizeOf(context).height / 20),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Number of Guests',
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: transport.guests.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  guests = int.tryParse(value) ?? 0;
                                }),
                            const SizedBox(height: 10),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Number of Luggages',
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: transport.luggage.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  luggage = int.tryParse(value) ?? 0;
                                }),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneNoController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: '+63',
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                                controller: emergencyContactNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact Name',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: 'Lastname Firstname',
                                )),
                            const SizedBox(height: 10),
                            TextFormField(
                                controller: emergencyContactNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact Number',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: '+63',
                                ),
                                keyboardType: TextInputType.phone),
                            const SizedBox(height: 10),
                            Column(children: [
                              CheckboxListTile(
                                  enabled: false,
                                  title: const Text("Government ID"),
                                  value: governmentId,
                                  onChanged: (value) {
                                    setState(() {
                                      governmentId = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading),
                              const Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                      "Your Government ID is required as a means to protect cooperatives from fraud and to ensure the safety of all guests.",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)))
                            ]),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    final currentTrip =
                                        ref.read(currentTripProvider);

                                    ListingBookings booking = ListingBookings(
                                        tripUid: currentTrip!.uid!,
                                        tripName: currentTrip.name,
                                        listingId: widget.listing.uid!,
                                        listingTitle: widget.listing.title,
                                        price: widget.listing.price!,
                                        roomId: widget.listing.title,
                                        category: "Transport",
                                        startDate: startDate,
                                        endDate: endDate,
                                        startTime: startTime,
                                        endTime: endTime,
                                        email: "",
                                        governmentId:
                                            "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                                        guests: guests,
                                        luggage: luggage,
                                        customerPhoneNo: phoneNoController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        emergencyContactNo:
                                            emergencyContactNoController.text,
                                        needsContributions: false,
                                        totalPrice:
                                            widget.listing.price! * guests,
                                        typeOfTrip: typeOfTrip,
                                        expenses: [],
                                        tasks: [],
                                        customerId: user.uid,
                                        customerName: user.name,
                                        bookingStatus: "Reserved");
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog.fullscreen(
                                              child: CustomerTransportCheckout(
                                                  listing: widget.listing,
                                                  transport: transport,
                                                  booking: booking));
                                        }).then((value) => context.pop());
                                  },
                                  child: const Text('Proceed'),
                                ))
                          ],
                        ))));
          });
        });
  }

  DraggableScrollableSheet twoWayTrip(
      String formattedStartDate,
      String formattedEndDate,
      AvailableTransport transport,
      num guests,
      num luggage,
      TextEditingController phoneNoController,
      TextEditingController emergencyContactNameController,
      TextEditingController emergencyContactNoController,
      bool governmentId,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String typeOfTrip,
      UserModel user) {
    return DraggableScrollableSheet(
        initialChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: DisplayText(
                                text: typeOfTrip,
                                lines: 1,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$formattedStartDate and ',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 4),
                                  Text(formattedEndDate,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic)),
                                ]),
                            SizedBox(
                                height: MediaQuery.sizeOf(context).height / 20),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Number of Guests',
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: transport.guests.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  guests = int.tryParse(value) ?? 0;
                                }),
                            const SizedBox(height: 10),
                            TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Number of Luggages',
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: transport.luggage.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  luggage = int.tryParse(value) ?? 0;
                                }),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneNoController,
                              decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  prefix: Text('+63')),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                                controller: emergencyContactNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact Name',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: 'Lastname Firstname',
                                )),
                            const SizedBox(height: 10),
                            TextFormField(
                                controller: emergencyContactNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact Number',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: '+63',
                                ),
                                keyboardType: TextInputType.phone),
                            const SizedBox(height: 10),
                            Column(children: [
                              CheckboxListTile(
                                  enabled: false,
                                  title: const Text("Government ID"),
                                  value: governmentId,
                                  onChanged: (value) {
                                    setState(() {
                                      governmentId = value ?? false;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading),
                              const Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Text(
                                      "Your Government ID is required as a means to protect cooperatives from fraud and to ensure the safety of all guests.",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)))
                            ]),
                            SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    final currentTrip =
                                        ref.read(currentTripProvider);

                                    ListingBookings booking = ListingBookings(
                                        tripUid: currentTrip!.uid!,
                                        tripName: currentTrip.name,
                                        listingId: widget.listing.uid!,
                                        listingTitle: widget.listing.title,
                                        price: widget.listing.price!,
                                        roomId: widget.listing.title,
                                        category: "Transport",
                                        startDate: startDate,
                                        endDate: endDate,
                                        startTime: startTime,
                                        endTime: endTime,
                                        email: "",
                                        governmentId:
                                            "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                                        guests: guests,
                                        luggage: luggage,
                                        customerPhoneNo: phoneNoController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        emergencyContactNo:
                                            emergencyContactNoController.text,
                                        needsContributions: false,
                                        totalPrice:
                                            widget.listing.price! * guests,
                                        typeOfTrip: typeOfTrip,
                                        expenses: [],
                                        tasks: [],
                                        customerId: user.uid,
                                        customerName: user.name,
                                        bookingStatus: 'Reserved');

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog.fullscreen(
                                              child: CustomerTransportCheckout(
                                                  listing: widget.listing,
                                                  transport: transport,
                                                  booking: booking));
                                        }).then((value) => context.pop());
                                  },
                                  child: const Text('Proceed'),
                                ))
                          ],
                        ))));
          });
        });
  }

  void showSelectDate(
      BuildContext context, List<ListingBookings> bookings, int index) {
    // DateTime startDate = DateTime.now();
    // DateTime endDate = DateTime.now();

    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                  title: const Text('Select Date'),
                  leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })),
              body: const Dialog.fullscreen(child: Column()));
        });
  }

  Widget vehicles() {
    Query query = FirebaseFirestore.instance
        .collectionGroup('availableTransport')
        .where('listingId', isEqualTo: widget.listing.uid!);
    Query listingQuery = FirebaseFirestore.instance
        .collection("listings")
        .where("uid", isEqualTo: widget.listing.uid!);
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Departure Times",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 10),
                  InkWell(
                    child: Icon(
                      Icons.more_time_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () async {
                      final listing = await ref.watch(
                          getListingsByPropertiesProvider(listingQuery).future);
                      showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController departureTimeController =
                                TextEditingController();
                            TimeOfDay departureTime =
                                const TimeOfDay(hour: 8, minute: 30);
                            return StatefulBuilder(
                                builder: (context, setDeparture) {
                              return AlertDialog(
                                title: const Text("Departure Time"),
                                content: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  child: TextFormField(
                                    controller: departureTimeController,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: "Time",
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .always, // Keep the label always visible
                                      hintText: "8:30 AM",
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      final TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: departureTime,
                                        initialEntryMode:
                                            TimePickerEntryMode.inputOnly,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        false),
                                            child: child!,
                                          );
                                        },
                                      );

                                      if (pickedTime != null) {
                                        setDeparture(() {
                                          departureTimeController.text =
                                              pickedTime.format(context);
                                          departureTime = pickedTime;
                                        });
                                      }
                                    },
                                  ),
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
                                      child: const Text('Cancel')),
                                  FilledButton(
                                      onPressed: () {
                                        List<TimeOfDay> updatedDepartureTimes =
                                            [
                                          ...listing.first.departureTimes ?? []
                                        ];
                                        updatedDepartureTimes
                                            .add(departureTime);
                                        var updatedListing = listing.first
                                            .copyWith(
                                                departureTimes:
                                                    updatedDepartureTimes);
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .updateListing(
                                                context, updatedListing);

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
                                      child: const Text('Add')),
                                ],
                              );
                            });
                          });
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              if (widget.listing.departureTimes != null)
                ref.watch(getListingsByPropertiesProvider(listingQuery)).when(
                      data: (List<ListingModel> listing) {
                        var sortedDepartureTimes =
                            List<TimeOfDay>.from(listing.first.departureTimes!);
                        sortedDepartureTimes.sort((a, b) {
                          int totalMinutesA = a.hour * 60 + a.minute;
                          int totalMinutesB = b.hour * 60 + b.minute;
                          return totalMinutesA.compareTo(totalMinutesB);
                        });
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // 2 columns
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: sortedDepartureTimes.length,
                          itemBuilder: (context, departureIndex) {
                            var dTime = sortedDepartureTimes[departureIndex];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  dTime.format(context),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: '',
                      ),
                      loading: () => const Loader(),
                    ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Vehicles",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 10),
                  InkWell(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Vehicle Information"),
                              content: showAddVehicleForm(),
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
                                    child: const Text('Cancel')),
                                FilledButton(
                                    onPressed: () {
                                      AvailableTransport transport =
                                          AvailableTransport(
                                        available: true,
                                        vehicleNo: num.parse(vehicleNo.text),
                                        guests: guests,
                                        luggage: luggage,
                                      );
                                      if (context.mounted) {
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .addTransport(context,
                                                widget.listing, transport);
                                      }

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
                                    child: const Text('Add')),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        ref.watch(getTransportByPropertiesProvider(query)).when(
              data: (List<AvailableTransport> vehicles) {
                // Sort the vehicles list by vehicleNo parsed into a number
                vehicles.sort((a, b) => a.vehicleNo!.compareTo(b.vehicleNo!));

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text('Vehicle No: ${vehicle.vehicleNo}'),
                          subtitle: Text(
                            'Capacity: ${vehicle.guests} | Luggage: ${vehicle.luggage}',
                          ),
                        ),
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
              loading: () => const Scaffold(body: Loader()),
            )
      ]),
    );
  }

  Widget showAddVehicleForm() {
    TextEditingController vehicleNo = TextEditingController();
    num guests = 0;
    num luggage = 0;
    return StatefulBuilder(builder: (context, setVehicle) {
      return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                  controller: vehicleNo,
                  onChanged: (value) {
                    setVehicle(() {
                      vehicleNo.text = value;
                    });
                    setState(() {
                      this.vehicleNo.text = value;
                    });
                  },
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
          SizedBox(height: MediaQuery.sizeOf(context).height / 50),
          ListTile(
              horizontalTitleGap: -10,
              title: const Text('Passengers', style: TextStyle(fontSize: 14)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (guests >= 1) {
                        setVehicle(() {
                          guests--;
                        });
                        setState(() {
                          this.guests--;
                        });
                      }
                    }),
                Text("$guests", style: const TextStyle(fontSize: 16)),
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setVehicle(() {
                        guests++;
                      });
                      setState(() {
                        this.guests++;
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
                        setVehicle(() {
                          luggage--;
                        });
                        setState(() {
                          this.luggage--;
                        });
                      }
                    }),
                Text("$luggage", style: const TextStyle(fontSize: 16)),
                IconButton(
                    iconSize: 14,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setVehicle(() {
                        luggage++;
                      });
                      setState(() {
                        this.luggage++;
                      });
                    })
              ])),
        ]),
      );
    });
  }

  Widget departures() {
    if (currentTab == 0) {
      setState(() {
        bottomAppBar = null;
      });
    }
    Query query = FirebaseFirestore.instance
        .collectionGroup('departures')
        .where('listingId', isEqualTo: widget.listing.uid!);
    return ref.watch(getDeparturesByPropertiesProvider(query)).when(
        data: (List<DepartureModel> departures) {
          if (departures.isEmpty) {
            return const Center(child: Text('No Departures'));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: departures.length,
                itemBuilder: ((context, index) {
                  num passengers = 0;
                  final departure = departures[index];
                  for (var booking in departure.passengers) {
                    passengers = passengers + booking.guests;
                  }
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(departure.arrival!);
                  String formattedStartTime =
                      TimeOfDay.fromDateTime(departure.departure!)
                          .format(context);
                  String formattedEndTime =
                      TimeOfDay.fromDateTime(departure.arrival!)
                          .format(context);
                  // String formattedEndDate =
                  //     DateFormat('MMMM dd').format(departure.arrival!);
                  return Card(
                      elevation: 1.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 40, right: 10, top: 10, bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    formattedStartDate,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Departure: $formattedStartTime | ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "Arrival: $formattedEndTime",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Passengers: $passengers",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                      onPressed: () async {
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .deleteDeparture(
                                                widget.listing.uid!,
                                                departures[index],
                                                context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text('Delete')),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        context.push(
                                          '/market/${'transport'}/departure_details',
                                          extra: {
                                            'departure': departure,
                                            'listing': widget.listing
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text(
                                        'Departure Details',
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ],
                            ))
                      ]));
                }));
          }
        },
        error: ((error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()))),
        loading: () => const Scaffold(body: Loader()));
  }
}

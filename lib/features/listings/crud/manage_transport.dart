// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
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
        child: Text('Bookings'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Deatils'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Vehicles'),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          ref.read(navBarVisibilityProvider.notifier).show();
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
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
                body: TabBarView(
                  children: [
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
      ImageSlider(
          images: imageUrls,
          height: MediaQuery.sizeOf(context).height * .4,
          width: MediaQuery.sizeOf(context).width,
          radius: BorderRadius.zero),

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
                '${widget.listing.availableTransport!.startTime.format(context)} - ${widget.listing.availableTransport!.endTime.format(context)}',
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
                      widget.listing.availableTransport!.workingDays),
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

      // this box is so that the edit listing doesn't cover any content
      SizedBox(
        height: MediaQuery.sizeOf(context).height / 35,
      ),
      const Divider(),
      Container(
        margin: const EdgeInsets.only(bottom: 0, right: 0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: FilledButton(
              onPressed: () {
                // Handle button tap here
                // Perform action when 'Edit Listing' button is tapped
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(4.0), // Adjust the radius as needed
                ),
              ),
              child: const Text('Edit Listing'),
            ),
          ),
        ),
      ),
    ]));
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
        data: (List<ListingBookings> bookings) {
          Map<DateTime, ListingBookings> filteredBookingsMap = {};

          for (var booking in bookings) {
            DateTime key = booking.startDate!;
            if (!filteredBookingsMap.containsKey(key)) {
              filteredBookingsMap[key] = ListingBookings(
                id: booking.id,
                customerId: '',
                customerName: '',
                customerPhoneNo: '',
                category: 'Transport',
                email: '',
                governmentId: '',
                guests: booking.guests,
                luggage: booking.luggage,
                listingId: booking.listingId,
                listingTitle: booking.listingTitle,
                needsContributions: booking.needsContributions,
                price: 0,
                bookingStatus: 'Reserved',
                tripUid: '',
                tripName: '',
                startDate: booking.startDate,
                endDate: booking.endDate,
                startTime: booking.startTime,
                endTime: booking.endTime,
              );
            } else {
              ListingBookings oldBooking = filteredBookingsMap[key]!;
              filteredBookingsMap[key] = filteredBookingsMap[key]!.copyWith(
                guests: oldBooking.guests + booking.guests,
                // luggage: oldBooking.luggage + booking.luggage,
              );
            }
          }
          List<DateTime> sortedKeys = filteredBookingsMap.keys.toList()
            ..sort((a, b) => a.compareTo(b));
          List<ListingBookings> filteredBookings =
              sortedKeys.map((key) => filteredBookingsMap[key]!).toList();

          return ListView.builder(
              shrinkWrap: true,
              itemCount: filteredBookings.length,
              itemBuilder: ((context, index) {
                String formattedStartDate = DateFormat('MMMM dd')
                    .format(filteredBookings[index].startDate!);
                String formattedStartTime =
                    filteredBookings[index].startTime!.format(context);
                String formattedEndTime =
                    filteredBookings[index].endTime!.format(context);
                String formattedEndDate = DateFormat('MMMM dd')
                    .format(filteredBookings[index].endDate!);
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
                                  "Passengers: ${filteredBookings[index].guests}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                              ])),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * .5,
                            child: FilledButton(
                                onPressed: () {
                                  context.push(
                                    '/market/${filteredBookings[index].category.toLowerCase()}/booking_details',
                                    extra: {
                                      'booking': filteredBookings[index],
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
                          ))
                    ]));
              }));
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
            debugPrint('this is the end date: $endDate');
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
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

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

  Widget rooms() {
    Query query = FirebaseFirestore.instance
        .collectionGroup('availableTransport')
        .where('listingId', isEqualTo: widget.listing.uid!);

    return ref.watch(getTransportByPropertiesProvider(query)).when(
        data: (List<AvailableTransport> vehicles) {
          return Stack(
            children: [
              ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vehicles.length,
                  itemBuilder: ((context, index) {
                    final vehicle = vehicles[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('[${index + 1}]'),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Vehicle No: ${vehicle.vehicleNo}",
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
                                'Capacity: ${vehicle.guests} | ',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Luggage: ${vehicle.luggage}',
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
                                child: const Center(
                                    child: Text("No Vehicles Added")))
                            : Container(
                                padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.sizeOf(context).width * .1),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing:
                                      8, // Adjust the spacing between items as needed
                                  runSpacing:
                                      8, // Adjust the run spacing (vertical spacing) as needed
                                  children: List.generate(
                                    vehicle.departureTimes!.length,
                                    (index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          vehicle.departureTimes![index]
                                              .format(context),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                      ],
                    );
                  })),
              Container(
                margin: const EdgeInsets.only(bottom: 25, right: 25),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return addRoomDialog();
                            });
                      },
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(), // Circular shape
                        padding: const EdgeInsets.all(
                            15), // Padding to make the button larger
                      ),
                      child: const Icon(Icons.add), // Plus icon
                    )),
              )
            ],
          );
        },
        error: ((error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()))),
        loading: () => const Scaffold(body: Loader()));
  }
}

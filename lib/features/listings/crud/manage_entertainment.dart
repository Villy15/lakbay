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
import 'package:lakbay/payments/payment_with_paymaya.dart';

class ManageEntertainment extends ConsumerStatefulWidget {
  final ListingModel listing;
  const ManageEntertainment({super.key, required this.listing});

  @override
  ConsumerState<ManageEntertainment> createState() =>
      _ManageEntertainmentState();
}

class _ManageEntertainmentState extends ConsumerState<ManageEntertainment> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text(
          'Scheduled Bookings',
          textAlign: TextAlign.center,
        ),
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
        child: Text("Scheduling"),
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
                // bottomNavigationBar: currentTab == 2
                //     ? BottomAppBar(
                //         child: FilledButton(
                //           onPressed: () {},
                //           style: FilledButton.styleFrom(
                //             padding: const EdgeInsets.symmetric(vertical: 12.0),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   8.0), // Adjust the value as needed
                //             ),
                //           ),
                //           child: const Text('Edit Listing'),
                //         ),
                //       )
                //     : null,
                body: ref.watch(getListingProvider(widget.listing.uid!)).when(
                      data: (ListingModel listing) {
                        return TabBarView(
                          children: [
                            scheduledBookings(listing),
                            bookings(listing),
                            details(listing),
                            if (listing.entertainmentScheduling!.type ==
                                "dayScheduling")
                              scheduling(listing)
                            else
                              dateScheduling(listing)
                          ],
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                        stackTrace: '',
                      ),
                      loading: () => const Loader(),
                    ))));
  }

  Widget details(ListingModel listing) {
    final List<String?> imageUrls =
        listing.images!.map((listingImage) => listingImage.url).toList();
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ImageSlider(
          images: imageUrls,
          height: MediaQuery.sizeOf(context).height / 2,
          width: double.infinity,
          radius: BorderRadius.circular(0)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align elements to the top by default
                children: [],
              ),
            ),
            _displaySubHeader("Description"),
            TextInBottomSheet(listing.title, listing.description, context),
            _displaySubHeader('Getting There'),
            // Getting There Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 5,
                child: MapWidget(
                  address: listing.address,
                  radius: true,
                ),
              ),
            ),
            if (listing.entertainmentScheduling!.type == "dayScheduling")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _displaySubHeader("Operating Days"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: getWorkingDays(
                          listing.entertainmentScheduling!.availability!,
                          listing),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
      ref
          .watch(getCooperativeProvider(listing.cooperative.cooperativeId))
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
                    // createRoom(context, listing.publisherId);
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
      const Divider(),
      const SizedBox(height: 5),
    ]));
  }

  Text _displaySubHeader(String subHeader) {
    return Text(
      subHeader,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary
          // Add other styling as needed
          ),
    );
  }

  Widget getWorkingDays(List<AvailableDay> workingDays, ListingModel listing) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Map the available days to their respective time
    Map<String, dynamic> availableDays = {};

    // match the available days to the time through widget.listing
    for (int i = 0; i < workingDays.length; i++) {
      if (workingDays[i].available == true) {
        debugPrint('this is the day: ${daysOfWeek[i]}');
        debugPrint(
            'this is the time: ${listing.entertainmentScheduling!.availability![i].availableTimes}');

        // map according to the day
        for (int j = 0;
            j <
                listing.entertainmentScheduling!.availability![i].availableTimes
                    .length;
            j++) {
          debugPrint(
              'this is the time: ${listing.entertainmentScheduling!.availability![i].availableTimes[j].time}');
          // map according to the time
          if (availableDays.containsKey(daysOfWeek[i])) {
            availableDays[daysOfWeek[i]].add(widget
                .listing
                .entertainmentScheduling!
                .availability![i]
                .availableTimes[j]
                .time);
          } else {
            availableDays[daysOfWeek[i]] = [
              listing.entertainmentScheduling!.availability![i]
                  .availableTimes[j].time
            ];
          }
        }
      }
    }

    debugPrint('final available days: $availableDays');
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: availableDays.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
      ),
      itemBuilder: (context, index) {
        String day = availableDays.keys.elementAt(index);
        debugPrint('building card for $day');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 3,
                    ),
                    itemCount: availableDays[day].length,
                    itemBuilder: (context, timeIndex) {
                      var time = availableDays[day][timeIndex];
                      debugPrint('this is the time $time');
                      debugPrint(
                          'this is the item count: ${availableDays[day].length}');
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          time.format(context),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bookings(ListingModel listing) {
    return ref.watch(getAllBookingsProvider(listing.uid!)).when(
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
                                        "Start Time: $formattedStartTime | ",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "End Time: $formattedEndTime",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Guests: ${bookings[index].guests}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: SizedBox(
                              width: 150,
                              child: FilledButton(
                                onPressed: () async {
                                  if (bookings[index].bookingStatus ==
                                      'Request Refund') {
                                    final cancellationRate =
                                        listing.cancellationRate! *
                                            bookings[index].amountPaid!;
                                    final refundedPayment =
                                        bookings[index].amountPaid! -
                                            cancellationRate;
                                    debugPrint(
                                        'this is the amount that will be refunded: $refundedPayment');
                                    await refundWithPaymaya(
                                        bookings[index],
                                        listing,
                                        ref,
                                        context,
                                        'Refund',
                                        refundedPayment);
                                  } else {
                                    context.push(
                                      '/market/${bookings[index].category.toLowerCase()}/booking_details',
                                      extra: {
                                        'booking': bookings[index],
                                        'listing': listing
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        4.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: Text(bookings[index].bookingStatus ==
                                        'Request Refund'
                                    ? 'Refund'
                                    : 'Booking Details'),
                              ),
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

  Widget scheduledBookings(ListingModel listing) {
    if (currentTab == 0) {
      setState(() {
        bottomAppBar = null;
      });
    }

    return ref.watch(getAllBookingsProvider(listing.uid!)).when(
          data: (List<ListingBookings> bookings) {
            if (bookings.isEmpty) {
              return const Center(child: Text('No Bookings'));
            } else {
              // Group bookings by date
              Map<String, List<ListingBookings>> groupedBookings = {};
              for (var booking in bookings) {
                String formattedDate =
                    DateFormat('MMMM dd').format(booking.startDate!);
                if (!groupedBookings.containsKey(formattedDate)) {
                  groupedBookings[formattedDate] = [];
                }
                groupedBookings[formattedDate]!.add(booking);
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: groupedBookings.length,
                itemBuilder: (context, index) {
                  String date = groupedBookings.keys.elementAt(index);
                  List<ListingBookings> dailyBookings = groupedBookings[date]!;

                  // Assuming all bookings in a group have the same start and end times
                  String formattedStartTime =
                      TimeOfDay.fromDateTime(dailyBookings.first.startDate!)
                          .format(context);
                  String formattedEndTime =
                      TimeOfDay.fromDateTime(dailyBookings.first.endDate!)
                          .format(context);

                  // Sum the passenger count for the group
                  // ignore: avoid_types_as_parameter_names
                  num totalPassengers = dailyBookings.fold(
                      0, (sum, booking) => sum + booking.guests);

                  return Card(
                    elevation: 1.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 10, top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                                "Total Passengers: $totalPassengers",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: FilledButton(
                                onPressed: () {
                                  context.push(
                                    '/market/entertainment/entertainment_details',
                                    extra: {
                                      'bookings': dailyBookings,
                                      'listing': listing
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4.0), // Adjust the radius as needed
                                )),
                                child: Text('${listing.type} Details',
                                    textAlign: TextAlign.center))),
                      ],
                    ),
                  );
                },
              );
            }
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
                error: error.toString(), stackTrace: stackTrace.toString()),
          ),
          loading: () => const Scaffold(body: Loader()),
        );
  }

  Widget dateScheduling(ListingModel listing) {
    return const Placeholder();
  }

  Widget scheduling(ListingModel listing) {
    const daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: daysOfWeek.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 120,
          ),
          itemBuilder: (context, index) {
            String day = daysOfWeek[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Checkbox(
                          value: listing.entertainmentScheduling!
                              .availability![index].available,
                          onChanged: (value) {
                            var updatedAvailability = List<AvailableDay>.from(
                                listing.entertainmentScheduling!.availability!);

                            updatedAvailability[index] =
                                updatedAvailability[index]
                                    .copyWith(available: value!);

                            final updatedScheduling = listing
                                .entertainmentScheduling!
                                .copyWith(availability: updatedAvailability);
                            final updatedListing = listing.copyWith(
                                entertainmentScheduling: updatedScheduling);

                            ref
                                .read(listingControllerProvider.notifier)
                                .updateListing(context, updatedListing);
                          }),
                      title: Text(
                        day,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController timeController =
                                    TextEditingController();
                                TextEditingController capacityController =
                                    TextEditingController();
                                TimeOfDay time =
                                    const TimeOfDay(hour: 8, minute: 30);
                                return StatefulBuilder(
                                    builder: (context, setTime) {
                                  return AlertDialog(
                                    title: const Text("Start Time"),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height / 4,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: timeController,
                                              maxLines: 1,
                                              decoration: const InputDecoration(
                                                labelText: "Time",
                                                border: OutlineInputBorder(),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always, // Keep the label always visible
                                                hintText: "8:30 AM",
                                              ),
                                              readOnly: true,
                                              onTap: () async {
                                                final TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: time,
                                                  initialEntryMode:
                                                      TimePickerEntryMode
                                                          .inputOnly,
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              alwaysUse24HourFormat:
                                                                  false),
                                                      child: child!,
                                                    );
                                                  },
                                                );

                                                if (pickedTime != null) {
                                                  setTime(() {
                                                    timeController.text =
                                                        pickedTime
                                                            .format(context);
                                                    time = pickedTime;
                                                  });
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: capacityController,
                                              maxLines: null,
                                              decoration: const InputDecoration(
                                                labelText: 'Capacity',
                                                border: OutlineInputBorder(),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                hintText: "10",
                                                suffix: Text(
                                                  'person/s',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                            var times = [
                                              ...listing
                                                  .entertainmentScheduling!
                                                  .availability![index]
                                                  .availableTimes
                                            ];
                                            var newTime = AvailableTime(
                                                available: true,
                                                maxPax: num.parse(
                                                    capacityController.text),
                                                time: time);
                                            // Add the new time
                                            times.add(newTime);

                                            // Sort the list
                                            times.sort((a, b) => a.time
                                                .format(context)
                                                .compareTo(
                                                    b.time.format(context)));
                                            var updatedAvailability =
                                                List<AvailableDay>.from(listing
                                                    .entertainmentScheduling!
                                                    .availability!);

                                            updatedAvailability[index] =
                                                updatedAvailability[index]
                                                    .copyWith(
                                                        available: true,
                                                        availableTimes: times);

                                            final updatedScheduling = listing
                                                .entertainmentScheduling!
                                                .copyWith(
                                                    availability:
                                                        updatedAvailability);
                                            final updatedListing =
                                                listing.copyWith(
                                                    entertainmentScheduling:
                                                        updatedScheduling);

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
                        child: Icon(
                          Icons.more_time_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 3,
                        ),
                        itemCount: listing.entertainmentScheduling!
                            .availability![index].availableTimes.length,
                        itemBuilder: (context, timeIndex) {
                          var time = listing.entertainmentScheduling!
                              .availability![index].availableTimes[timeIndex];
                          return Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              time.time.format(context),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

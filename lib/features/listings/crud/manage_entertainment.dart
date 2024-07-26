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
                    scheduledBookings(),
                    bookings(),
                    details(),
                    scheduling(),
                  ],
                ))));
  }

  Widget details() {
    final List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();
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
            TextInBottomSheet(
                widget.listing.title, widget.listing.description, context),
            _displaySubHeader('Getting There'),
            // Getting There Address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height / 5,
                child: MapWidget(
                  address: widget.listing.address,
                  radius: true,
                ),
              ),
            ),
            if (widget.listing.entertainmentScheduling!.type == "dayScheduling")
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
                      child: getWorkingDays(widget
                          .listing.entertainmentScheduling!.availability!),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
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
                    // createRoom(context, widget.listing.publisherId);
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

  Widget getWorkingDays(List<AvailableDay> workingDays) {
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
      if (workingDays[i].available == true) {
        result.add(daysOfWeek[i]);
      }
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: result.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
      ),
      itemBuilder: (context, index) {
        String day = result[index];
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
                    itemCount: widget.listing.entertainmentScheduling!
                        .availability![index].availableTimes.length,
                    itemBuilder: (context, timeIndex) {
                      var time = widget.listing.entertainmentScheduling!
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
    );
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
                                  if (bookings[index].bookingStatus == 'Request Refund') {
                                    final cancellationRate = widget.listing.cancellationRate! * bookings[index].amountPaid!;
                                    final refundedPayment = bookings[index].amountPaid! - cancellationRate;
                                    debugPrint('this is the amount that will be refunded: $refundedPayment');
                                    await refundWithPaymaya(bookings[index], widget.listing, ref, context, 'Refund', refundedPayment);
                                  }
                                  else {
                                    context.push(
                                      '/market/${bookings[index].category.toLowerCase()}/booking_details',
                                      extra: {
                                        'booking': bookings[index],
                                        'listing': widget.listing
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
                                child: Text(
                                  bookings[index].bookingStatus == 'Request Refund' ? 'Refund' : 'Booking Details'
                                ),
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

  Widget scheduledBookings() {
    if (currentTab == 0) {
      setState(() {
        bottomAppBar = null;
      });
    }
    
  
  return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
    data: (List<ListingBookings> bookings) {
      if (bookings.isEmpty) {
        return const Center(child: Text('No Bookings'));
      } else {
        // Group bookings by date
        Map<String, List<ListingBookings>> groupedBookings = {};
        for (var booking in bookings) {
          String formattedDate = DateFormat('MMMM dd').format(booking.startDate!);
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
            String formattedStartTime = TimeOfDay.fromDateTime(dailyBookings.first.startDate!).format(context);
            String formattedEndTime = TimeOfDay.fromDateTime(dailyBookings.first.endDate!).format(context);

            // Sum the passenger count for the group
            // ignore: avoid_types_as_parameter_names
            num totalPassengers = dailyBookings.fold(0, (sum, booking) => sum + booking.guests);

            return Card(
              elevation: 1.0,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 10, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Departure: $formattedStartTime | ",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                            ),
                            Text(
                              "Arrival: $formattedEndTime",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                            ),
                          ],
                        ),
                        Text(
                          "Total Passengers: $totalPassengers",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: FilledButton(
                      onPressed: () {
                        context.push(
                          '/market/entertainment/entertainment_details',
                          extra: {
                            'bookings': dailyBookings,
                            'listing': widget.listing
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0), // Adjust the radius as needed
                        )
                      ),
                      child: Text(
                        '${widget.listing.type} Details',
                        textAlign: TextAlign.center
                      ) 
                    )
                  ),
                ],
              ),
            );
          },
        );
      }
    },
    error: (error, stackTrace) => Scaffold(
      body: ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
    ),
    loading: () => const Scaffold(body: Loader()),
  );


  }

  Widget scheduling() {
    return const Placeholder();
  }
}

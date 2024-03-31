// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';

class CustomerTransportation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerTransportation({super.key, required this.listing});

  @override
  ConsumerState<CustomerTransportation> createState() =>
      _CustomerTransportationState();
}

class _CustomerTransportationState
    extends ConsumerState<CustomerTransportation> {
  List<SizedBox> tabs = [
    const SizedBox(width: 100, child: Tab(child: Text('Details'))),
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
    final daysPlan = ref.read(daysPlanProvider);
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
                appBar: AppBar(
                  title: widget.listing.title.length > 20
                      ? Text('${widget.listing.title.substring(0, 20)}...',
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                      : Text(widget.listing.title,
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                  bottom: TabBar(
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
                body: TabBarView(children: [
                  details(),
                ]),
                // create a bottom navigation bar for the customer
                // so that they may be able to book the transport
                bottomNavigationBar: BottomAppBar(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 24),
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: '₱${widget.listing.price}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    TextSpan(
                                        text: ' per person',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary))
                                  ]))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: const Text(
                                                      'Transport Details'),
                                                  content: SizedBox(
                                                      height:
                                                          MediaQuery.sizeOf(
                                                                      context)
                                                                  .height /
                                                              4,
                                                      width: MediaQuery.sizeOf(
                                                                  context)
                                                              .width /
                                                          1.5,
                                                      child: Column(children: [
                                                        Row(children: [
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.5),
                                                            child: Icon(
                                                                Icons
                                                                    .people_alt_outlined,
                                                                size: 30),
                                                          ),
                                                          Text(
                                                              "Guests: ${widget.listing.availableTransport!.guests}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))
                                                        ]),
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(children: [
                                                          const Icon(
                                                              Icons
                                                                  .luggage_outlined,
                                                              size: 30),
                                                          Text(
                                                              "Pickup Point: ${widget.listing.availableTransport!.pickupPoint}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18))
                                                        ]),
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .location_on_outlined,
                                                                size: 30),
                                                            Text(
                                                                'Destination: ${widget.listing.availableTransport!.destination}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18))
                                                          ],
                                                        )
                                                      ])));
                                            });
                                      },
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: 'Transport Details',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontStyle: FontStyle.italic)),
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          )
                                        ]),
                                      )))
                            ]),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8.0, bottom: 8.0),
                                child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    child: FilledButton(
                                      onPressed: () async {
                                        final bookings = await ref.watch(
                                            getAllBookingsProvider(
                                                    widget.listing.uid!)
                                                .future);

                                        if (widget.listing.type == 'Public') {
                                          if (context.mounted) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: const Text(
                                                          'Select a Departure Time',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      content: SizedBox(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .height /
                                                                  3.5,
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width /
                                                                  1.5,
                                                          child: Column(
                                                              children: widget
                                                                  .listing
                                                                  .availableTransport!
                                                                  .departureTimes!
                                                                  .map(
                                                                      (departureTime) {
                                                            DateTime dateTimeSlot = DateTime(
                                                                daysPlan
                                                                    .currentDay!
                                                                    .year,
                                                                daysPlan
                                                                    .currentDay!
                                                                    .month,
                                                                daysPlan
                                                                    .currentDay!
                                                                    .day,
                                                                departureTime
                                                                    .hour,
                                                                departureTime
                                                                    .minute);
                                                            List<ListingBookings>
                                                                bookingsCopy =
                                                                bookings;
                                                            Map<DateTime?, num>
                                                                deptTimeAndGuests =
                                                                {
                                                              dateTimeSlot: widget
                                                                  .listing
                                                                  .availableTransport!
                                                                  .guests
                                                            };
                                                            // format the currentDate
                                                            String
                                                                formattedCurrentDate =
                                                                DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .format(daysPlan
                                                                        .currentDay!);

                                                            for (ListingBookings booking
                                                                in bookingsCopy) {
                                                              // only get the date and not the time from booking.startDate. trim it to only get the date

                                                              DateTime
                                                                  bookingStartDate =
                                                                  booking
                                                                      .startDate!;
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          bookingStartDate);

                                                              // check the formattedCurrentDate and the formattedDate if they are the same
                                                              if (formattedCurrentDate ==
                                                                  formattedDate) {
                                                                // remove duplicates of departure time, and get the total number of guests for each departure time

                                                                if (deptTimeAndGuests
                                                                    .containsKey(
                                                                        bookingStartDate)) {
                                                                  deptTimeAndGuests[
                                                                      bookingStartDate] = deptTimeAndGuests[
                                                                          bookingStartDate]! -
                                                                      booking
                                                                          .guests;
                                                                }
                                                                //  else {
                                                                //   deptTimeAndGuests[
                                                                //       booking
                                                                //           .startDate] = booking
                                                                //       .guests;
                                                                // }
                                                                // check if the selected departure time's availability through the number of guests. guests must not exceed the available transport's capacity
                                                              }
                                                            }
                                                            return ListTile(
                                                                title: Text(
                                                                    departureTime
                                                                        .format(
                                                                            context)),
                                                                trailing: Text(
                                                                    'Slots Left: ${deptTimeAndGuests[dateTimeSlot]}'),
                                                                onTap:
                                                                    () async {
                                                                  if (deptTimeAndGuests[
                                                                          dateTimeSlot] !=
                                                                      null) {
                                                                    if (deptTimeAndGuests[
                                                                            dateTimeSlot]! ==
                                                                        0) {
                                                                      // show an alert dialog that the selected departure time is already full
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(title: const Text('Departure Time is Full'), content: Text('The time ${departureTime.format(context)} has reached its capacity of ${deptTimeAndGuests[dateTimeSlot]}.  Please select another time.'), actions: [
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: const Text('Close'))
                                                                            ]);
                                                                          });
                                                                    } else {
                                                                      // show confirm booking
                                                                      showConfirmBooking(
                                                                              widget.listing.availableTransport!,
                                                                              widget.listing,
                                                                              daysPlan.currentDay!,
                                                                              daysPlan.currentDay!,
                                                                              departureTime,
                                                                              'Public')
                                                                          .then((value) {});
                                                                    }
                                                                  } else {
                                                                    // show confirm booking
                                                                    showConfirmBooking(
                                                                        widget
                                                                            .listing
                                                                            .availableTransport!,
                                                                        widget
                                                                            .listing,
                                                                        daysPlan
                                                                            .currentDay!,
                                                                        daysPlan
                                                                            .currentDay!,
                                                                        departureTime,
                                                                        'Public');
                                                                  }
                                                                });
                                                          }).toList())));
                                                });
                                          }
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text(
                                        'Book now',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))))
                      ],
                    )))));
  }

  Future<dynamic> showConfirmBooking(
      AvailableTransport transport,
      ListingModel listing,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay? departureTime,
      String typeOfTrip) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
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
          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return confirmOneWay(
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
                departureTime,
                typeOfTrip,
                user!,
                listing);
          }));
        });
  }

  SingleChildScrollView confirmOneWay(
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
      TimeOfDay? departureTime,
      String typeOfTrip,
      UserModel user,
      ListingModel listing) {
    return SingleChildScrollView(
        child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppBar(
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                }),
            title:
                Text(formattedStartDate, style: const TextStyle(fontSize: 18)),
            elevation: 0),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: [
              TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Number of Guests (Max: ${transport.guests})',
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "1"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    guests = int.tryParse(value) ?? 0;
                  }),
              const SizedBox(height: 10),
              TextFormField(
                  decoration: InputDecoration(
                      labelText:
                          'Number of Luggages (Max: ${transport.luggage})',
                      border: const OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "1"),
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixText: "+63 "),
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 10),
              TextFormField(
                  controller: emergencyContactNameController,
                  decoration: const InputDecoration(
                      labelText: 'Emergency Contact Name',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Lastname Firstname")),
              const SizedBox(height: 10),
              TextFormField(
                  controller: emergencyContactNoController,
                  decoration: const InputDecoration(
                      labelText: 'Emergency Contact No.',
                      border: OutlineInputBorder(),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixText: '+63 '),
                  keyboardType: TextInputType.phone),
              Column(children: [
                CheckboxListTile(
                  enabled: false,
                  value: governmentId,
                  title: const Text("Government ID"),
                  onChanged: (bool? value) {
                    setState(() {
                      governmentId = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                        'Your Government ID is required as a means to protect cooperatives.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)))
              ]),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        final currentTrip = ref.read(currentTripProvider);
                        ListingBookings booking = ListingBookings(
                            tripUid: currentTrip!.uid!,
                            tripName: currentTrip.name,
                            listingId: listing.uid!,
                            listingTitle: listing.title,
                            customerName: user.name,
                            bookingStatus: "Reserved",
                            price: listing.price!,
                            category: "Transport",
                            startDate: DateTime(
                                startDate.year,
                                startDate.month,
                                startDate.day,
                                departureTime!.hour,
                                departureTime.minute),
                            endDate: DateTime(
                                    endDate.year,
                                    endDate.month,
                                    endDate.day,
                                    departureTime.hour,
                                    departureTime.minute)
                                .add(Duration(
                                    hours: listing.duration!.hour,
                                    minutes: listing.duration!.minute)),
                            startTime: departureTime,
                            endTime: departureTime,
                            email: "",
                            governmentId:
                                "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                            guests: guests,
                            customerPhoneNo: phoneNoController.text,
                            customerId: user.uid,
                            emergencyContactName:
                                emergencyContactNameController.text,
                            emergencyContactNo:
                                emergencyContactNoController.text,
                            needsContributions: false,
                            tasks: listing.fixedTasks,
                            typeOfTrip: typeOfTrip);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog.fullscreen(
                                  child: CustomerTransportCheckout(
                                      listing: listing,
                                      transport: transport,
                                      booking: booking));
                            }).then((value) {
                          context.pop();
                          context.pop();
                        });
                      },
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              4.0), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text('Proceed')))
            ]))
      ]),
    ));
  }

  SingleChildScrollView details() {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1.0,
          height: 250.0,
          enlargeFactor: 0,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {},
        ),
        items: [
          Image(
            image: NetworkImage(
              widget.listing.images!.first.url!,
            ),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
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
      const SizedBox(height: 30),
      const Divider(),

      // if the type is public, add the departure times
      if (widget.listing.type == 'Public') ...[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: DisplayText(
            text: 'Departure Times: ',
            lines: 1,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            widget.listing.availableTransport!.departureTimes!
                .map((e) => e.format(context))
                .join(', '),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const Divider(),
      ],

      ListTile(
        leading: SizedBox(
          height: 40,
          width: 40,
          child: DisplayImage(
              imageUrl:
                  'cooperatives/${widget.listing.cooperative.cooperativeName}/download.jpg',
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
        title: Text('Hosted by ${widget.listing.cooperative.cooperativeName}',
            style: Theme.of(context).textTheme.labelLarge),
      ),
      const Divider(),

      const SizedBox(height: 5),
    ]));
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
}

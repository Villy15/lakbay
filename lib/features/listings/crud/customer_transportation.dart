// ignore_for_file: unused_local_variable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
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
            )));
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
                        var convertedEndDate = DateTime(
                                endDate.year,
                                endDate.month,
                                endDate.day,
                                departureTime!.hour,
                                departureTime.minute)
                            .add(Duration(
                                hours: listing.duration!.hour,
                                minutes: listing.duration!.minute));
                        var convertedStartDate = DateTime(
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            departureTime.hour,
                            departureTime.minute);
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
                            startDate: convertedStartDate,
                            endDate: convertedEndDate,
                            startTime: departureTime,
                            endTime: TimeOfDay.fromDateTime(convertedEndDate),
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
      // if (widget.listing.type == 'Public') ...[
      // Padding(
      //   padding: const EdgeInsets.only(left: 16.0),
      //   child: DisplayText(
      //     text: 'Departure Times: ',
      //     lines: 1,
      //     style: TextStyle(
      //       fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
      //     ),
      //   ),
      // ),
      // // Padding(
      // //   padding: const EdgeInsets.only(left: 32.0),
      // //   child: Text(
      // //     widget.listing.availableTransport!.departureTimes!
      // //         .map((e) => e.format(context))
      // //         .join(', '),
      // //     style: const TextStyle(fontSize: 12),
      // //   ),
      // // ),
      // const Divider(),
      // ],

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

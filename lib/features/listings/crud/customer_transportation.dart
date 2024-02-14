import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:lakbay/features/common/widgets/text_in_bottomsheet.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
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
    const SizedBox(width: 100, child: Tab(child: Text('Bookings')))
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
                              fontSize: 32.0, fontWeight: FontWeight.bold))
                      : Text(widget.listing.title,
                          style: const TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold)),
                  bottom: TabBar(
                    tabAlignment: TabAlignment.center,
                    labelPadding: EdgeInsets.zero,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: tabs,
                  ),
                ),
                body: TabBarView(children: [details(), bookings()]))));
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
      const SizedBox(height: 30),
      const Divider(),

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

      // add a book now button
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Transport details
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: '₱${widget.listing.availableTransport?.price}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary)),
                if (widget.listing.type == 'Private') ...[
                  TextSpan(
                    text: " per night",
                    style: TextStyle(
                        fontSize: 16, // Smaller size for 'per night'
                        fontStyle: FontStyle.italic, // Italicized 'per night'
                        fontWeight:
                            FontWeight.normal, // Normal weight for 'per night'
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ] else ...[
                  TextSpan(
                    text: " per person",
                    style: TextStyle(
                        fontSize: 16, // Smaller size for 'per night'
                        fontStyle: FontStyle.italic, // Italicized 'per night'
                        fontWeight:
                            FontWeight.normal, // Normal weight for 'per night'
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ]
              ])),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0),
              child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text('Transport Details'),
                              content: SizedBox(
                                  height: MediaQuery.sizeOf(context).height / 4,
                                  width: MediaQuery.sizeOf(context).width / 1.5,
                                  child: Column(children: [
                                    Row(children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 4.5),
                                        child: Icon(Icons.people_alt_outlined,
                                            size: 30),
                                      ),
                                      Text(
                                          "Guests: ${widget.listing.availableTransport!.guests}",
                                          style: const TextStyle(fontSize: 18))
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      const Icon(Icons.luggage_outlined,
                                          size: 30),
                                      Text(
                                          "Luggages: ${widget.listing.availableTransport!.luggage}",
                                          style: const TextStyle(fontSize: 18))
                                    ]),
                                    const SizedBox(height: 10),
                                    // pickup point and drop off point
                                    Row(children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 30),
                                      Text(
                                          "Pickup Point: ${widget.listing.availableTransport!.pickupPoint}",
                                          style: const TextStyle(fontSize: 18))
                                    ]),
                                    const SizedBox(height: 10),
                                    Row(children: [
                                      const Icon(Icons.location_on_outlined,
                                          size: 30),
                                      Text(
                                          "Destination: ${widget.listing.availableTransport!.destination}",
                                          style: const TextStyle(fontSize: 18))
                                    ]),
                                  ])));
                        });
                  },
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Transport Details',
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary,
                              fontStyle: FontStyle.italic)),
                      WidgetSpan(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      )
                    ]),
                  )),
            )
          ]),

          // Book Now button
          Container(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 2.3,
                child: ElevatedButton(
                  onPressed: () async {
                    // show a prompt that will allow the user to check if it is a two way trip or not
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.flight),
                              title: const Text('One Way Trip'),
                              onTap: () {
                                // Continue with booking a one way trip
                                Navigator.pop(context, 'One Way Trip');
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.flight_takeoff),
                              title: const Text('Two Way Trip'),
                              onTap: () {
                                // Continue with booking a two way trip
                                Navigator.pop(context, 'Two Way Trip');
                              },
                            ),
                          ],
                        );
                      },
                    ).then((value) async {
                      if (value == 'One Way Trip') {
                        // Show date picker for one way trip

                        final bookings = await ref.watch(
                            getAllBookingsProvider(widget.listing.uid!).future);
                        DateTime? endDate;
                        DateTime initialDate = DateTime.now();
                        TimeOfDay? firstBookedTime;
                        TimeOfDay? endBookedTime;
                        TimeOfDay? existingFirstTime;
                        TimeOfDay? existingEndTime;
                        DateTime? existingStartDate;
                        DateTime? existingEndDate;
                        List<ListingBookings> bookingsCopy =
                            List.from(bookings);

                        while (!widget.listing.availableTransport!
                            .workingDays[initialDate.weekday - 1]) {
                          initialDate =
                              initialDate.add(const Duration(days: 1));
                        }

                        // ignore: use_build_context_synchronously
                        DateTime? startDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2025),
                            selectableDayPredicate: (DateTime day) {
                              bool workingDays = widget
                                  .listing
                                  .availableTransport!
                                  .workingDays[day.weekday - 1];

                              // If the day is not a working day, disable it
                              if (!workingDays) {
                                return false;
                              }

                              // Enable all other days
                              return true;
                            });

                        if (startDate != null) {
                          // check if the user selected a date that is already booked
                          while (firstBookedTime == null) {
                            // ignore: use_build_context_synchronously
                            firstBookedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (firstBookedTime == null) {
                              // User pressed cancel
                              break;
                            }

                            TimeOfDay startWorkingHour =
                                widget.listing.availableTransport!.startTime;
                            TimeOfDay endWorkingHour =
                                widget.listing.availableTransport!.endTime;

                            if (firstBookedTime.hour < startWorkingHour.hour ||
                                firstBookedTime.hour > endWorkingHour.hour) {
                              // ignore: use_build_context_synchronously
                              showSnackBar(
                                  context,
                                  // ignore: use_build_context_synchronously
                                  'Please select a time between ${startWorkingHour.format(context)} and ${endWorkingHour.format(context)}');
                              firstBookedTime = null; // Reset startTime
                            }

                            // check if the user's selected time is already booked
                            for (ListingBookings booking in bookingsCopy) {
                              existingFirstTime = booking.startTime;
                              existingEndTime = booking.endTime;
                              existingStartDate = booking.startDate;
                              existingEndDate = booking.endDate;

                              // compare startDate (the selected date) with the existing start date. do the same with the end date
                              // check if it is a two way trip or not
                              if (existingStartDate == existingEndDate) {
                                if (existingStartDate != null) {
                                  if (existingStartDate
                                      .isAtSameMomentAs(startDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        firstBookedTime != null) {
                                      if (firstBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          firstBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        firstBookedTime = null;
                                      }
                                    }
                                  }
                                }
                              } else {
                                if (existingStartDate != null &&
                                    existingEndDate != null) {
                                  if (existingStartDate
                                      .isAtSameMomentAs(startDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        firstBookedTime != null) {
                                      if (firstBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          firstBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        firstBookedTime = null;
                                      }
                                    }
                                  } else if (existingEndDate
                                      .isAtSameMomentAs(startDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        firstBookedTime != null) {
                                      if (firstBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          firstBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        firstBookedTime = null;
                                      }
                                    }
                                  }
                                }
                              }
                            }

                            // show confirm booking, no need to show date picker for end date
                            if (firstBookedTime != null) {
                              showConfirmBooking(
                                  widget.listing.availableTransport!,
                                  startDate,
                                  startDate,
                                  firstBookedTime,
                                  firstBookedTime,
                                  value);
                            }
                          }
                        }
                      } else if (value == 'Two Way Trip') {
                        // Show date picker for two way trip

                        final bookings = await ref.watch(
                            getAllBookingsProvider(widget.listing.uid!).future);
                        debugPrint(
                          'There exists such booking: $bookings',
                        );
                        if (context.mounted) {
                          DateTime? endDate;
                          DateTime initialDate = DateTime.now();
                          TimeOfDay? firstBookedTime;
                          TimeOfDay? endBookedTime;
                          TimeOfDay? existingFirstTime;
                          TimeOfDay? existingEndTime;
                          DateTime? existingStartDate;
                          DateTime? existingEndDate;
                          List<ListingBookings> bookingsCopy =
                              List.from(bookings);

                          while (!widget.listing.availableTransport!
                              .workingDays[initialDate.weekday - 1]) {
                            initialDate =
                                initialDate.add(const Duration(days: 1));
                          }

                          DateTime? startDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2025),
                              selectableDayPredicate: (DateTime day) {
                                bool workingDays = widget
                                    .listing
                                    .availableTransport!
                                    .workingDays[day.weekday - 1];

                                // If the day is not a working day, disable it
                                if (!workingDays) {
                                  return false;
                                }

                                // Enable all other days
                                return true;
                              });

                          if (startDate != null) {
                            // check if the user selected a date that is already booked
                            while (firstBookedTime == null) {
                              // ignore: use_build_context_synchronously
                              firstBookedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (firstBookedTime == null) {
                                // User pressed cancel
                                break;
                              }

                              TimeOfDay startWorkingHour =
                                  widget.listing.availableTransport!.startTime;
                              TimeOfDay endWorkingHour =
                                  widget.listing.availableTransport!.endTime;

                              if (firstBookedTime.hour <
                                      startWorkingHour.hour ||
                                  firstBookedTime.hour > endWorkingHour.hour) {
                                // ignore: use_build_context_synchronously
                                showSnackBar(
                                    context,
                                    // ignore: use_build_context_synchronously
                                    'Please select a time between ${startWorkingHour.format(context)} and ${endWorkingHour.format(context)}');
                                firstBookedTime = null; // Reset startTime
                              }

                              // use existingFirstTime to check if the user's selected time is already booked
                              for (ListingBookings booking in bookingsCopy) {
                                existingFirstTime = booking.startTime;
                                existingEndTime = booking.endTime;
                                existingStartDate = booking.startDate;
                                existingEndDate = booking.endDate;

                                // compare startDate with existing startDate and endDate
                                if (existingStartDate != null &&
                                    existingEndDate != null) {
                                  if (existingStartDate
                                      .isAtSameMomentAs(startDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        firstBookedTime != null) {
                                      if (firstBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          firstBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        firstBookedTime = null;
                                      }
                                    }
                                  } else if (existingEndDate
                                      .isAtSameMomentAs(startDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        firstBookedTime != null) {
                                      if (firstBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          firstBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        firstBookedTime = null;
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }

                          if (startDate != null && firstBookedTime != null) {
                            // ignore: use_build_context_synchronously
                            endDate = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: startDate,
                              lastDate: DateTime(2025),
                              selectableDayPredicate: (DateTime day) {
                                bool workingDays = widget
                                    .listing
                                    .availableTransport!
                                    .workingDays[day.weekday - 1];
                                final bookedDates =
                                    getAllDatesFromBookings(bookings);

                                // If the day is not a working day, disable it
                                if (!workingDays) {
                                  return false;
                                }

                                // Enable all other days
                                return true;
                              },
                            );
                          }

                          if (startDate != null &&
                              endDate != null &&
                              firstBookedTime != null) {
                            while (endBookedTime == null) {
                              // ignore: use_build_context_synchronously
                              endBookedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (endBookedTime == null) {
                                // User pressed cancel
                                break;
                              }

                              TimeOfDay startWorkingHour =
                                  widget.listing.availableTransport!.startTime;
                              TimeOfDay endWorkingHour =
                                  widget.listing.availableTransport!.endTime;

                              if (endBookedTime.hour < startWorkingHour.hour ||
                                  endBookedTime.hour > endWorkingHour.hour) {
                                // ignore: use_build_context_synchronously
                                showSnackBar(
                                    context,
                                    // ignore: use_build_context_synchronously
                                    'Please select a time between ${startWorkingHour.format(context)} and ${endWorkingHour.format(context)}');
                                endBookedTime = null; // Reset startTime
                              }

                              for (ListingBookings booking in bookingsCopy) {
                                // check if the user's selected time is already booked on that specific date
                                existingFirstTime = booking.startTime;
                                existingEndTime = booking.endTime;
                                existingStartDate = booking.startDate;
                                existingEndDate = booking.endDate;

                                // compare the existingStartDate and existingEndDate with the selected endDate
                                if (existingStartDate != null &&
                                    existingEndDate != null) {
                                  if (existingStartDate
                                      .isAtSameMomentAs(endDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        endBookedTime != null) {
                                      if (endBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          endBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        endBookedTime = null;
                                      }
                                    }
                                  } else if (existingEndDate
                                      .isAtSameMomentAs(endDate)) {
                                    if (existingFirstTime != null &&
                                        existingEndTime != null &&
                                        endBookedTime != null) {
                                      if (endBookedTime.hour >=
                                              existingFirstTime.hour &&
                                          endBookedTime.hour <=
                                              existingEndTime.hour) {
                                        // ignore: use_build_context_synchronously
                                        showSnackBar(context,
                                            'This time is already booked. Please select another time.');
                                        endBookedTime = null;
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }

                          if (startDate != null &&
                              endDate != null &&
                              firstBookedTime != null &&
                              endBookedTime != null) {
                            showConfirmBooking(
                                widget.listing.availableTransport!,
                                startDate,
                                endDate,
                                firstBookedTime,
                                endBookedTime,
                                value);
                          }
                        }
                      }
                    });
                  },
                  child: const Text(
                    'Book now',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ]));
  }

  Widget bookings() {
    return ref.watch(getAllBookingsProvider(widget.listing.uid!)).when(
        data: (List<ListingBookings> bookings) {
          // get personal information (name) from listing's userId via userProvider
          return ListView.builder(
              shrinkWrap: true,
              itemCount: bookings.length,
              itemBuilder: ((context, index) {
                if (bookings[index].typeOfTrip == 'Two Way Trip') {
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(bookings[index].startDate!);
                  String formattedStartTime =
                      bookings[index].startTime!.format(context);
                  String formattedEndTime =
                      bookings[index].endTime!.format(context);
                  String formattedEndDate =
                      DateFormat('MMMM dd').format(bookings[index].endDate!);

                  debugPrint(
                      'this is the formatted end date : $formattedEndDate');

                  return Card(
                      elevation: 1.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10, bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Text(
                                    '${bookings[index].typeOfTrip}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formattedStartDate,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Departure Time: $formattedStartTime",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                formattedEndDate,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Departure Time: $formattedEndTime",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ])
                                      ])
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  context.push(
                                    '/market/${bookings[index].category}/booking_details',
                                    extra: {
                                      'booking': bookings[index],
                                      'listing': widget.listing
                                    },
                                  );
                                },
                                child: const Text('Booking Details')))
                      ]));
                } else {
                  debugPrint(
                      'this is the type of trip: ${bookings[index].typeOfTrip}');
                  String formattedStartDate =
                      DateFormat('MMMM dd').format(bookings[index].startDate!);
                  String formattedStartTime =
                      bookings[index].startTime!.format(context);

                  return Card(
                      elevation: 1.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10, bottom: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Text(
                                    '${bookings[index].typeOfTrip}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formattedStartDate,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "Departure Time: $formattedStartTime",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                            ])
                                      ])
                                ])),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  context.push(
                                    '/market/${bookings[index].category}/booking_details',
                                    extra: {
                                      'booking': bookings[index],
                                      'listing': widget.listing
                                    },
                                  );
                                },
                                child: const Text('Booking Details')))
                      ]));
                }
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
          
          TextEditingController phoneNoController = TextEditingController(text: user?.phoneNo);
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
                typeOfTrip, user!);
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
                typeOfTrip, user!);
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
      String typeOfTrip, UserModel user) {
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ListingBookings booking = ListingBookings(
                                        listingId: widget.listing.uid!,
                                        listingTitle: widget.listing.title,
                                        price: transport.price,
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
                                        totalPrice: transport.price * guests,
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
                                            listing: widget.listing, transport: transport, booking: booking)
                                        );
                                      }
                                    );
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
      String typeOfTrip, UserModel user) {
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
                                prefix: Text('+63')
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    
                                    ListingBookings booking = ListingBookings(
                                        listingId: widget.listing.uid!,
                                        listingTitle: widget.listing.title,
                                        price: transport.price,
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
                                        totalPrice: transport.price * guests,
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
                                            listing: widget.listing, transport: transport, booking: booking)
                                        );
                                      }
                                    );
                                  },
                                  child: const Text('Proceed'),
                                ))
                          ],
                        ))));
          });
        });
  }

  void showSelectDate(BuildContext context, List<ListingBookings> bookings, int index) {
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
              }
            )
          ),
          body: const Dialog.fullscreen(
            child: Column()
          )
        );
      }
    );
  }
}

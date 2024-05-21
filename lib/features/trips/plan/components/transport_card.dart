// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_transport_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class TransportCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? transportListings;
  const TransportCard(
      {super.key, required this.category, required this.transportListings});

  @override
  ConsumerState<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends ConsumerState<TransportCard> {
  @override
  Widget build(BuildContext context) {
    // final guests = ref.read(currentPlanGuestsProvider);
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);
    final currentUser = ref.read(userProvider);

    if (widget.transportListings != null) {
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.transportListings!.length,
              itemBuilder: ((context, index) {
                final List<String?> imageUrls = widget
                    .transportListings![index].images!
                    .map((listingImage) => listingImage.url)
                    .toList();
                final transport = widget.transportListings![index];
                return SizedBox(
                  // height: MediaQuery.sizeOf(context).height / 2,
                  width: MediaQuery.sizeOf(context).width / 2,
                  child: Card(
                      child: Column(
                    children: [
                      ImageSlider(
                          images: imageUrls,
                          height: MediaQuery.sizeOf(context).height / 4,
                          width: MediaQuery.sizeOf(context).width / 2,
                          radius: BorderRadius.circular(10)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 10,
                            top: 10,
                            bottom: 10), // Reduced overall padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transport.title,
                                      style: const TextStyle(
                                        fontSize:
                                            18, // Increased font size, larger than the previous one
                                        fontWeight:
                                            FontWeight.bold, // Bold text
                                      ),
                                    ),
                                    Text(
                                      transport.title,
                                      style: const TextStyle(
                                        fontSize:
                                            14, // Increased font size, larger than the previous one
                                        fontWeight:
                                            FontWeight.w500, // Bold text
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "₱${widget.transportListings![index].price}",
                                            style: TextStyle(
                                                fontSize:
                                                    14, // Size for the price
                                                fontWeight: FontWeight
                                                    .w500, // Bold for the price
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                          ),
                                          if (widget.transportListings![index]
                                                  .type ==
                                              'Public') ...[
                                            TextSpan(
                                              text: " per trip",
                                              style: TextStyle(
                                                  fontSize:
                                                      14, // Smaller size for 'per night'
                                                  fontStyle: FontStyle
                                                      .italic, // Italicized 'per night'
                                                  fontWeight: FontWeight
                                                      .normal, // Normal weight for 'per night'
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ),
                                          ] else ...[
                                            TextSpan(
                                              text: " / day",
                                              style: TextStyle(
                                                  fontSize:
                                                      14, // Smaller size for 'per night'
                                                  fontStyle: FontStyle
                                                      .italic, // Italicized 'per night'
                                                  fontWeight: FontWeight
                                                      .normal, // Normal weight for 'per night'
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                    // add rental per hour if the transport is private and offers hourly rental
                                    if (widget.transportListings![index].type ==
                                        'Private') ...[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "₱${transport.availableTransport!.priceByHour}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ),
                                            TextSpan(
                                              text: " / hour",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.normal,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 30,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FilledButton(
                                      onPressed: () {
                                        context.push(
                                            '/market/${widget.category}',
                                            extra: transport);
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text('View Listing',
                                          style: TextStyle(fontSize: 14))),
                                  FilledButton(
                                      onPressed: () async {
                                        if (currentUser?.name ==
                                                'Lakbay User' ||
                                            currentUser?.phoneNo == null ||
                                            currentUser?.emergencyContact ==
                                                null ||
                                            currentUser?.emergencyContactName ==
                                                null ||
                                            currentUser?.governmentId == null) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Profile Incomplete'),
                                                  content: const Text(
                                                      'To book a room, you need to complete your profile first.'),
                                                  actions: [
                                                    FilledButton(
                                                      onPressed: () async {
                                                        showUpdateProfile(
                                                            context,
                                                            currentUser!);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4.0), // Adjust the radius as needed
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Update Profile',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        } else {
                                          Map<TimeOfDay, num> timeSlots = {};

                                          Set<TimeOfDay> departureTimesSet = {};

                                          final bookings = await ref.watch(
                                              getAllBookingsProvider(
                                                      transport.uid!)
                                                  .future);
                                          Query query = FirebaseFirestore
                                              .instance
                                              .collectionGroup(
                                                  'availableTransport')
                                              .where('listingId',
                                                  isEqualTo: transport.uid);
                                          List<AvailableTransport> vehicles =
                                              await ref.watch(
                                                  getTransportByPropertiesProvider(
                                                          query)
                                                      .future);
                                          for (var vehicle in vehicles) {
                                            for (var departureTime
                                                in vehicle.departureTimes!) {
                                              // Check if the departure time is not already in the set
                                              if (!timeSlots.keys
                                                  .contains(departureTime)) {
                                                timeSlots[departureTime] =
                                                    vehicle.guests;
                                                departureTimesSet.add(
                                                    departureTime); // Add the unique departure time to the set
                                                timeSlots[departureTime] =
                                                    vehicle.guests;
                                              } else {
                                                timeSlots[departureTime] =
                                                    timeSlots[departureTime]! +
                                                        vehicle.guests;
                                              }
                                            }
                                          }

                                          if (transport.type == 'Public') {
                                            var sortedKeys = timeSlots.keys
                                                .toList()
                                              ..sort((a, b) {
                                                return a.hour.compareTo(
                                                            b.hour) !=
                                                        0
                                                    ? a.hour.compareTo(b.hour)
                                                    : a.minute
                                                        .compareTo(b.minute);
                                              });
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
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                children:
                                                                    sortedKeys.map(
                                                                        (key) {
                                                              num passengers =
                                                                  timeSlots[
                                                                      key]!;
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
                                                                  key.hour,
                                                                  key.minute);
                                                              List<ListingBookings>
                                                                  bookingsCopy =
                                                                  bookings;
                                                              Map<DateTime?,
                                                                      num>
                                                                  deptTimeAndGuests =
                                                                  {
                                                                dateTimeSlot:
                                                                    passengers
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
                                                                }
                                                              }
                                                              return ListTile(
                                                                  title: Text(
                                                                      key.format(
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
                                                                              return AlertDialog(title: const Text('Departure Time is Full'), content: Text('The time ${key.format(context)} has reached its capacity of $passengers.  Please select another time.'), actions: [
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
                                                                                transport.availableTransport!,
                                                                                transport,
                                                                                daysPlan.currentDay!,
                                                                                daysPlan.currentDay!,
                                                                                key,
                                                                                'Public',
                                                                                null)
                                                                            .then((value) {});
                                                                      }
                                                                    } else {
                                                                      // show confirm booking
                                                                      showConfirmBooking(
                                                                          transport
                                                                              .availableTransport!,
                                                                          transport,
                                                                          daysPlan
                                                                              .currentDay!,
                                                                          daysPlan
                                                                              .currentDay!,
                                                                          key,
                                                                          'Public',
                                                                          null);
                                                                    }
                                                                  });
                                                            }).toList()),
                                                          )),
                                                      actions: [
                                                        FilledButton(
                                                            onPressed: () {
                                                              context.pop();
                                                            },
                                                            child: const Text(
                                                                "Back"))
                                                      ],
                                                    );
                                                    // });
                                                  });
                                            }
                                            // showConfirmBooking(transport, listing, DateTime.now(), DateTime.now(), , endTime, typeOfTrip);
                                          } else if (transport.type ==
                                              'Private') {
                                            // check if the selected date is available
                                            final bookings = await ref.watch(
                                                getAllBookingsProvider(
                                                        transport.uid!)
                                                    .future);

                                            List<ListingBookings> bookingsCopy =
                                                List.from(bookings);

                                            bool flag = false;

                                            for (ListingBookings bookings
                                                in bookingsCopy) {
                                              // check if the listing id is already booked
                                              if (bookings.listingId ==
                                                  transport.uid) {
                                                // check if the current date is already booked
                                                if (bookings.startDate!
                                                    .isAtSameMomentAs(
                                                        daysPlan.currentDay!)) {
                                                  flag = true;
                                                }
                                              }
                                            }
                                            if (flag) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height /
                                                          3.5,
                                                      width: double.infinity,
                                                      child: const AlertDialog(
                                                        title: Text(
                                                            'Booking Unavailable'),
                                                        content: Text(
                                                            'Someone has rented the vehicle already. Please select another day from your plan or rent a new vehicle.'),
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    // ask the user if they want to rent the vehicle for the whole day or just for a specific time
                                                    return SizedBox(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height /
                                                                3.5,
                                                        width: double.infinity,
                                                        child: AlertDialog(
                                                            title: const Text(
                                                                'Select rental duration'),
                                                            content: const Text(
                                                                'Do you want to rent the vehicle for the whole day or just for a specific time?'),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Whole Day');
                                                                  },
                                                                  child: const Text(
                                                                      'Whole Day')),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Select Time');
                                                                  },
                                                                  child: const Text(
                                                                      'Select Time'))
                                                            ]));
                                                  }).then((value) {
                                                if (value == 'Whole Day') {
                                                  showConfirmBooking(
                                                      transport
                                                          .availableTransport!,
                                                      transport,
                                                      daysPlan.currentDay!,
                                                      daysPlan.currentDay!,
                                                      null,
                                                      'Private',
                                                      value);
                                                } else {
                                                  showConfirmBooking(
                                                      transport
                                                          .availableTransport!,
                                                      transport,
                                                      daysPlan.currentDay!,
                                                      daysPlan.currentDay!,
                                                      null,
                                                      'Private',
                                                      value);
                                                }
                                              });
                                            }
                                          }
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              4.0), // Adjust the radius as needed
                                        ),
                                      ),
                                      child: const Text('Book Now',
                                          style: TextStyle(fontSize: 14)))
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Row(children: [
                                    const Icon(Icons.car_rental),
                                    const SizedBox(width: 5),
                                    Text(widget.category,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
                                  ])),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Transport Details"),
                                              content: SizedBox(
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height /
                                                        4,
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width /
                                                        1.5,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .people_alt_outlined,
                                                            size: 30),
                                                        Text(
                                                          "Guests: ${transport.availableTransport!.guests}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.luggage,
                                                            size: 30),
                                                        Text(
                                                          "Luggages: ${transport.availableTransport!.luggage}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Transport Details",
                                              style: TextStyle(
                                                  // color: Colors.grey,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.5),
                                                  fontStyle: FontStyle
                                                      .italic // Underline for emphasis
                                                  ),
                                            ),
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons
                                                    .keyboard_arrow_down, // Arrow pointing down icon
                                                size:
                                                    16.0, // Adjust the size to fit your design
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ])
                          ],
                        ),
                      )
                    ],
                  )),
                );
              })));
    } else {
      return Center(
        child: Column(
          children: [
            const Text("No Transportation Available"),
            Text(
                "(${DateFormat('MMMM dd').format(startDate!)} - ${DateFormat('MMMM dd').format(endDate!)})")
          ],
        ),
      );
    }
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

  Future<dynamic> showConfirmBooking(
      AvailableTransport transport,
      ListingModel listing,
      DateTime startDate,
      DateTime endDate,
      TimeOfDay? departureTime,
      String typeOfTrip,
      String? privateBookingType) {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          num guests = 0;
          num luggage = 0;
          final numGuests = ref.read(currentPlanGuestsProvider);
          final user = ref.read(userProvider);
          guests = numGuests!;

          TextEditingController guestController =
              TextEditingController(text: numGuests.toString());
          TextEditingController luggageController =
              TextEditingController(text: transport.luggage.toString());
          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo ?? '');
          TextEditingController emergencyContactNameController =
              TextEditingController(text: user?.emergencyContactName ?? '');
          TextEditingController emergencyContactNoController =
              TextEditingController(text: user?.emergencyContact ?? '');
          TimeOfDay? startTime;
          TimeOfDay? endTime;
          DateTime? finalDate;
          TextEditingController startTimeController = TextEditingController();
          TextEditingController endTimeController = TextEditingController();
          bool governmentId = true;
          String formattedStartDate =
              DateFormat('MMMM dd, yyyy').format(startDate);
          return Dialog.fullscreen(
              child: confirmOneWay(
                  formattedStartDate,
                  transport,
                  guests,
                  luggage,
                  guestController,
                  luggageController,
                  phoneNoController,
                  emergencyContactNameController,
                  emergencyContactNoController,
                  startTimeController,
                  endTimeController,
                  governmentId,
                  startDate,
                  endDate,
                  finalDate,
                  startTime,
                  endTime,
                  departureTime,
                  typeOfTrip,
                  user!,
                  listing,
                  privateBookingType));
        }).then((value) => context.pop());
  }

  Widget confirmOneWay(
      String formattedStartDate,
      AvailableTransport transport,
      num guests,
      num luggage,
      TextEditingController guestController,
      TextEditingController luggageController,
      TextEditingController phoneNoController,
      TextEditingController emergencyContactNameController,
      TextEditingController emergencyContactNoController,
      TextEditingController? startTimeController,
      TextEditingController? endTimeController,
      bool governmentId,
      DateTime startDate,
      DateTime endDate,
      DateTime? finalDate,
      TimeOfDay? startTime,
      TimeOfDay? endTime,
      TimeOfDay? departureTime,
      String typeOfTrip,
      UserModel user,
      ListingModel listing,
      String? privateBookingType) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                }),
            title:
                Text(formattedStartDate, style: const TextStyle(fontSize: 18)),
            elevation: 1),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.only(top: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                          controller: guestController,
                          decoration: const InputDecoration(
                              labelText: 'Guests: ',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "1"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            guests = int.tryParse(value) ?? 0;
                          }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Luggage: (Max: ${transport.luggage})',
                              border: const OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "1"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            luggage = int.tryParse(value) ?? 0;
                          }),
                    ),
                  ]),
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
                  if (privateBookingType == 'Select Time') ...[
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: startTimeController,
                        decoration: InputDecoration(
                          labelText: 'Booking Start Time',
                          border: const OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: transport.startTime!.format(context),
                        ),
                        readOnly: true,
                        onTap: () async {
                          // show time picker
                          final time = await showTimePicker(
                              context: context,
                              initialTime: transport.startTime!,
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              builder: (context, child) {
                                return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: false),
                                    child: child!);
                              });

                          if (time != null) {
                            startTimeController!.text = time.format(context);
                            startTime = time;
                          }
                        }),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: endTimeController,
                        decoration: InputDecoration(
                            labelText: 'Booking End Time',
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: transport.endTime!.format(context)),
                        readOnly: true,
                        onTap: () async {
                          // show time picker
                          final time = await showTimePicker(
                              context: context,
                              initialTime: transport.endTime!,
                              initialEntryMode: TimePickerEntryMode.inputOnly,
                              builder: (context, child) {
                                return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: false),
                                    child: child!);
                              });

                          if (time != null) {
                            endTimeController!.text = time.format(context);
                            endTime = time;
                          }
                        }),
                  ],
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
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () async {
                          await proceedTransportCheckOut(
                              typeOfTrip,
                              listing,
                              user,
                              transport,
                              startDate,
                              departureTime,
                              endDate,
                              guests,
                              phoneNoController,
                              emergencyContactNameController,
                              emergencyContactNoController,
                              startTime,
                              endTime);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                4.0), // Adjust the radius as needed
                          ),
                        ),
                        child: const Text('Proceed')),
                  )
                ]))
          ]),
        )));
  }

  Future<UserModel> submitUpdateProfile(
      BuildContext context,
      UserModel user,
      UserModel updatedUser,
      GlobalKey<FormState> formKey,
      File? profilePicture,
      File? governmentId) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (profilePicture != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: profilePicture.path.split('/').last,
              file: profilePicture,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new profile picture
          updatedUser = updatedUser.copyWith(profilePic: imageUrl);
        });
      }

      if (governmentId != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: governmentId.path.split('/').last,
              file: governmentId,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new government id picture
          updatedUser = updatedUser.copyWith(governmentId: imageUrl);
        });
      }

      // transfer updatedUser to user
      ref
          .read(usersControllerProvider.notifier)
          .editProfile(context, user.uid, updatedUser);
    }

    return updatedUser;
  }

  void showUpdateProfile(BuildContext context, UserModel user) async {
    File? profilePicture;
    String? profilePicLink = user.profilePic;
    File? governmentId;
    // String? governmentIdLink = user.governmentId;
    ValueNotifier<File?> governmentIdNotifier = ValueNotifier<File?>(null);
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName ?? '');
    final TextEditingController phoneNoController =
        TextEditingController(text: user.phoneNo ?? '');
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController emergencyContactNameController =
        TextEditingController(text: user.emergencyContactName ?? '');
    final TextEditingController emergencyContactNoController =
        TextEditingController(text: user.emergencyContact ?? '');
    final TextEditingController addressController =
        TextEditingController(text: user.address ?? '');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBar(
                                leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                                title: const Text('Edit Profile',
                                    style: TextStyle(fontSize: 18)),
                                elevation: 0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      child: Row(
                                    children: [
                                      Icon(Icons.image,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: ImagePickerFormField(
                                          imageUrl: profilePicLink,
                                          initialValue: profilePicture,
                                          onSaved: (value) {
                                            this.setState(() {
                                              profilePicture = value;
                                              debugPrint(
                                                  'this is the value: $profilePicture');
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: 'Email*',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: "username@gmail.com",
                                          helperText: "*required"),
                                      keyboardType: TextInputType.emailAddress,
                                      // if email is not null, put the initial value
                                      onChanged: (value) {
                                        user = user.copyWith(email: value);
                                      },
                                      readOnly: true,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: firstNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'First Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "First Name",
                                        helperText: "*required"),
                                    // put initial value if the user's first name is not null
                                    // initialValue: user.firstName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(firstName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: lastNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Last Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Last Name",
                                        helperText: "*required"),
                                    // initialValue: user.lastName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(lastName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                        labelText: 'Address*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Street, City, Province",
                                        helperText: "*required"),
                                    // initialValue: user.address ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(address: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+63 ",
                                        helperText: "*required",
                                        hintText: '91234567891'),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.phoneNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(phoneNo: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  // text for government id
                                  ListTile(
                                    title: const Text('Government ID*'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    subtitle: ValueListenableBuilder<File?>(
                                      valueListenable: governmentIdNotifier,
                                      builder: (context, governmentId, child) {
                                        return governmentId == null
                                            ? const Text(
                                                'Upload a valid Government ID ')
                                            : Text(
                                                'Government ID selected: ${path.basename(governmentId.path)}');
                                      },
                                    ),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png',
                                          'pdf',
                                          'doc'
                                        ],
                                      );

                                      if (result != null) {
                                        this.setState(() {
                                          governmentId =
                                              File(result.files.single.path!);
                                          governmentIdNotifier.value =
                                              governmentId;
                                        });
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: emergencyContactNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Name',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Lastname Firstname",
                                        helperText: "*required"),
                                    // initialValue: user.emergencyContactName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContactName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: emergencyContactNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Number',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+63 ",
                                        hintText: '91234567891',
                                        helperText: "*required"),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.emergencyContactNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContact: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  FilledButton(
                                    onPressed: () async {
                                      formKey.currentState!.save();
                                      UserModel updatedUser = user.copyWith(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        name:
                                            "${firstNameController.text} ${lastNameController.text}",
                                        address: addressController.text,
                                        phoneNo: phoneNoController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        emergencyContact:
                                            emergencyContactNoController.text,
                                      );
                                      debugPrint(
                                          'this is the government id and the profile picture: $governmentId, $profilePicture');
                                      user = await submitUpdateProfile(
                                          context,
                                          user,
                                          updatedUser,
                                          formKey,
                                          profilePicture,
                                          governmentId);

                                      debugPrint('this is user: $user');

                                      // close dialog
                                      Navigator.of(context).pop();
                                      this.setState(() {
                                        user = user;
                                      });

                                      ref
                                          .read(userProvider.notifier)
                                          .setUser(user);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust the radius as needed
                                      ),
                                    ),
                                    child: const Text(
                                        'Update Profile Information'),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    )));
          }));
        });
  }

  Future<dynamic> proceedTransportCheckOut(
      String typeOfTrip,
      ListingModel listing,
      UserModel user,
      AvailableTransport transport,
      DateTime startDate,
      TimeOfDay? departureTime,
      DateTime endDate,
      num guests,
      TextEditingController phoneNoController,
      TextEditingController emergencyContactNameController,
      TextEditingController emergencyContactNoController,
      TimeOfDay? startTime,
      TimeOfDay? endTime) async {
    final currentTrip = ref.read(currentTripProvider);
    DateFormat('MMMM dd, yyyy').format(startDate);
    DateFormat('MMMM dd, yyyy').format(endDate);
    // final query = FirebaseFirestore.instance
    //     .collectionGroup(
    //         'bookings') // Perform collection group query for 'bookings'
    //     .where('category', isEqualTo: 'Transport')
    //     .where('bookingStatus', isEqualTo: "Reserved")
    //     .where('listingId', isEqualTo: listing.uid);

    // List<ListingBookings> todaysBookings =
    //     await ref.read(getBookingsByPropertiesProvider(query).future);
    // todaysBookings = todaysBookings.where((booking) {
    //   // Assuming 'startDate' is a DateTime property in 'ListingBookings'
    //   return booking.startDate!.year == startDate.year &&
    //       booking.startDate!.month == startDate.month &&
    //       booking.startDate!.day == startDate.day;
    // }).toList();

    // debugPrint('todaysbookings: $todaysBookings');
    ListingBookings booking = ListingBookings(
        tripUid: currentTrip!.uid!,
        tripName: currentTrip.name,
        listingId: listing.uid!,
        listingTitle: listing.title,
        customerName: user.name,
        bookingStatus: "Reserved",
        price: listing.price!,
        category: "Transport",
        startDate: DateTime(startDate.year, startDate.month, startDate.day,
            departureTime!.hour, departureTime.minute),
        endDate: DateTime(endDate.year, endDate.month, endDate.day,
                departureTime.hour, departureTime.minute)
            .add(Duration(
                hours: listing.duration!.hour,
                minutes: listing.duration!.minute)),
        startTime: departureTime,
        endTime: departureTime,
        email: user.email!,
        governmentId: user.governmentId!,
        guests: guests,
        customerPhoneNo: phoneNoController.text,
        customerId: user.uid,
        emergencyContactName: emergencyContactNameController.text,
        emergencyContactNo: emergencyContactNoController.text,
        needsContributions: false,
        tasks: listing.fixedTasks,
        typeOfTrip: typeOfTrip);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: CustomerTransportCheckout(
                  listing: listing, transport: transport, booking: booking));
        }).then((value) {
      context.pop();
    });
  }
}

class PrepareTravel extends StatelessWidget {
  const PrepareTravel({
    super.key,
    required List<TextEditingController> textFormFieldControllers,
  }) : _textFormFieldControllers = textFormFieldControllers;

  final List<TextEditingController> _textFormFieldControllers;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(child: StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                          leading: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                context.pop();
                              }),
                          title: const Text('Choose Travel',
                              style: TextStyle(fontSize: 18))),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Booking Start Time',
                                  border: OutlineInputBorder(),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintText: '11:00 AM',
                                ),
                                readOnly: true,
                                onTap: () {}),
                            const SizedBox(height: 10),
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Booking End Time',
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: '11:00 PM'),
                                readOnly: true,
                                onTap: () {}),
                            // make a button that adds more textformfields if the user wishes to add their locations
                            Column(
                                children:
                                    _textFormFieldControllers.map((controller) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          labelText: 'Location',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: 'Mariveles City, Bulacan'),
                                      readOnly: true,
                                      onTap: () {
                                        // navigate to the SelectLocation page
                                        Navigator.of(context).pop();

                                        // testing the location page for future implementations
                                        context.push('/select_location');
                                      }),
                                ],
                              );
                            }).toList()),
                            const SizedBox(height: 10),
                            FilledButton(
                                onPressed: () {
                                  // when pressed, it adds more textformfields for adding a location
                                  setState(() {
                                    // add more textformfields
                                    _textFormFieldControllers
                                        .add(TextEditingController());
                                  });
                                },
                                child: const Text('Add Location')),
                          ]))
                    ])));
      },
    ));
  }
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    String? imageUrl,
  }) : super(
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      state.didChange(File(pickedFile.path));
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: state.value != null
                        ? Image.file(state.value!, fit: BoxFit.cover)
                        : (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Center(child: Text('Select an image')),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

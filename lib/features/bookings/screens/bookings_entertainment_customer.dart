// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/listings/crud/customer_transport_receipt.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
import 'package:lakbay/features/trips/plan/plan_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/plan_model.dart';
import 'package:lakbay/models/sale_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookingsEntertainmentCustomer extends ConsumerStatefulWidget {
  final ListingModel listing;
  final ListingBookings booking;

  const BookingsEntertainmentCustomer(
      {super.key, required this.listing, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingsEntertainmentCustomerState();
}

class _BookingsEntertainmentCustomerState
    extends ConsumerState<BookingsEntertainmentCustomer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('File Name: booking_transport_customer.dart');
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          ref.read(navBarVisibilityProvider.notifier).show();
          context.pop();
        },
        child: ref
            .watch(getBookingByIdProvider(
                (widget.booking.listingId, widget.booking.id!)))
            .when(
                data: (ListingBookings booking) {
                  List<String?> imageUrls = widget.listing.images!
                      .map((listingImage) => listingImage.url)
                      .toList();
                  Map<String, Map<String, dynamic>> generalActions = {
                    "listing": {
                      "icon": Icons.location_on_outlined,
                      "title": "View Listing",
                      "action": () {
                        context.push(
                            "/market/${widget.listing.category.toLowerCase()}",
                            extra: widget.listing);
                      }
                    },
                    "message": {
                      "icon": Icons.chat_outlined,
                      "title": "Message Host",
                      "action": () => context.push("/chat")
                    },
                  };

                  Map<String, Map<String, dynamic>> reservationActions = {
                    "receipt": {
                      "icon": Icons.receipt_long_outlined,
                      "title": "View receipt",
                      "action": () => showDialog(
                          context: context,
                          builder: ((context) {
                            return Dialog.fullscreen(
                              child: CustomerTransportReceipt(
                                  listing: widget.listing,
                                  booking: widget.booking),
                            );
                          }))
                    },
                    "booking": {
                      "icon": Icons.cancel_outlined,
                      "title": "Cancel Booking",
                      "action": () {
                        cancelBookingProcess(context, booking);
                      }
                    },
                  };
                  return Scaffold(
                      extendBodyBehindAppBar: true,
                      appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          leading: IconButton(
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                context.pop();
                              })),
                      body: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Stack(children: [
                              if (booking.bookingStatus == "Emergency Request")
                                Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.only(
                                      top: 15, left: 7.5, right: 7.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                                Icons.warning_amber_outlined,
                                                color: Colors.red,
                                                size: 30),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Emergency Request",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "We regret to inform you that your service provider has encountered issues, making the service unavailable. You may either Cancel (entitled to a refund) or Re-Book the service",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.report_problem,
                                                color: Colors.red, size: 30),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: FilledButton(
                                                onPressed: () =>
                                                    erCancel(context, booking),
                                                style: FilledButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Adjust the value as needed
                                                  ),
                                                ),
                                                child: const Text("Cancel"),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: FilledButton(
                                                onPressed: () =>
                                                    erRebook(booking),
                                                style: FilledButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // Adjust the value as needed
                                                  ),
                                                ),
                                                child: const Text("Re-Book"),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              else
                                Container(
                                    foregroundDecoration: BoxDecoration(
                                        color: Colors.black.withOpacity(
                                            booking.bookingStatus ==
                                                        "Cancelled" ||
                                                    booking.bookingStatus ==
                                                        "Request Refund"
                                                ? 0.5
                                                : 0.0)),
                                    child: ImageSlider(
                                        images: imageUrls,
                                        height:
                                            MediaQuery.sizeOf(context).height /
                                                2,
                                        width: double.infinity,
                                        radius: BorderRadius.circular(0))),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 70.0, left: 30),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                            booking.bookingStatus == 'Cancelled'
                                                ? "Your Booking Has Been Cancelled"
                                                : booking.bookingStatus ==
                                                        "Request Refund"
                                                    ? "Your refund has been requested"
                                                    : '',
                                            style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  ],
                                ),
                              )
                            ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              DateFormat('E, MMM d')
                                                  .format(booking.startDate!),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          // Checkin time
                                          Text(
                                            DateFormat.jm().format(
                                                widget.booking.startDate!),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.sizeOf(context).height / 7.5,
                                    width: 1,
                                    color: Colors
                                        .grey, // Choose the color of the line
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'End',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              DateFormat('E, MMM d')
                                                  .format(booking.endDate!),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500)),
                                          // Checkout time
                                          Text(
                                            DateFormat.jm().format(
                                                widget.booking.endDate!),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ...generalActions.entries.map((entry) {
                              final generalAction = entry.value;
                              return Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
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
                                      size: 24,
                                    ),
                                    title: Text(generalAction['title']),
                                    onTap: generalAction["action"],
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: 10,
                              width: double.infinity,
                              color: Colors.grey[200],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 20,
                              ),
                              child: Text(
                                'Reservation Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (booking.bookingStatus != 'Cancelled' &&
                                booking.bookingStatus != 'Completed')
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                  top: 10,
                                  bottom: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Cancellation Policy: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (booking.paymentOption == "Full Payment")
                                      Text(
                                          'Cancellation before ${DateFormat('MMM d, HH:mm a').format(booking.endDate!.subtract(Duration(days: int.parse(widget.listing.cancellationPeriod.toString()))))}'
                                          ' entitles you to a refund amount of ₱${(booking.amountPaid!).toStringAsFixed(2)}\n'
                                          'Cancellation after stated date entitles you to a refund amount of ₱${(booking.amountPaid! - (booking.amountPaid! * widget.listing.cancellationRate!)).toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),

                            ...reservationActions.entries.map((entry) {
                              final reservationAction = entry.value;
                              if (booking.bookingStatus == "Cancelled" &&
                                      entry.key == 'booking' ||
                                  booking.bookingStatus == 'Completed' &&
                                      entry.key == 'booking') {
                                return Container();
                              } else {
                                return Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
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
                                        reservationAction['icon'],
                                        size: 24,
                                      ),
                                      title: Text(reservationAction['title']),
                                      onTap: reservationAction["action"],
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),

                            // Getting There Header
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Getting There',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Getting There Address
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height / 5,
                                child: MapWidget(
                                    address: widget.listing.address,
                                    radius: true),
                              ),
                            ),

                            // Hosted By Header
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Hosted By',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Hosted by Cooperative Name
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.people_alt_outlined),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.listing.cooperative.cooperativeName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Payment Information Header
                            // const Padding(
                            //   padding: EdgeInsets.all(8.0),
                            //   child: Text(
                            //     'Payment Information',
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                          ])));
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString(), stackTrace: ''),
                loading: () => const CircularProgressIndicator()));
  }

  void erRebook(ListingBookings booking) async {
    final schedType = widget.listing.entertainmentScheduling!.type;
    List<AvailableDay> availableDays;
    List<AvailableDate> availableDates;
    if (schedType == "dayScheduling") {
      availableDays = [
        ...widget.listing.entertainmentScheduling!.availability!
      ];
      final result = await showDialog<PickerDateRange>(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height: MediaQuery.of(context).size.height *
                0.6, // 60% of screen height
            child: SfDateRangePicker(
              // onSelectionChanged: _onDateSelection,
              selectionMode: DateRangePickerSelectionMode.single,
              showActionButtons: true, // Enable the confirm and cancel buttons
              selectableDayPredicate: (DateTime day) {
                for (AvailableDay aDay in availableDays) {
                  if (dayOfTheWeek(day.weekday - 1) == aDay.day &&
                      aDay.available == true) {
                    return true;
                  }
                }
                return false;
              },
              enablePastDates: false,
              onSubmit: (value) async {
                if (value is DateTime) {
                  if (context.mounted) {
                    final bookings = await ref.watch(
                        getAllBookingsProvider(widget.listing.uid!).future);

                    showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text('Select a time',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            content: Column(
                                children: availableDays[value.weekday - 1]
                                    .availableTimes
                                    .map((availableTime) {
                              {
                                DateTime dateTimeSlot = DateTime(
                                    value.year,
                                    value.month,
                                    value.day,
                                    availableTime.time.hour,
                                    availableTime.time.minute);
                                List<ListingBookings> bookingsCopy = bookings;
                                Map<DateTime?, num> availableTimeAndCapacity = {
                                  dateTimeSlot: availableTime.maxPax
                                };
                                // format the currentDate
                                String formattedCurrentDate =
                                    DateFormat('yyyy-MM-dd').format(value);

                                for (ListingBookings booking in bookingsCopy) {
                                  // only get the date and not the time from booking.startDate. trim it to only get the date
                                  if (booking.bookingStatus != "Cancelled") {
                                    DateTime bookingStartDate =
                                        booking.startDate!;
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(bookingStartDate);

                                    // check the formattedCurrentDate and the formattedDate if they are the same
                                    if (formattedCurrentDate == formattedDate) {
                                      // remove duplicates of departure time, and get the total number of guests for each departure time

                                      if (availableTimeAndCapacity
                                          .containsKey(bookingStartDate)) {
                                        availableTimeAndCapacity[
                                                bookingStartDate] =
                                            availableTimeAndCapacity[
                                                    bookingStartDate]! -
                                                booking.guests;
                                      }
                                    }
                                  }
                                }
                                return ListTile(
                                    title: Text(
                                        availableTime.time.format(context)),
                                    trailing: Text(
                                        'Slots Left: ${availableTimeAndCapacity[dateTimeSlot]}'),
                                    onTap: () async {
                                      num capacity = availableTimeAndCapacity[
                                              dateTimeSlot] ??
                                          0;

                                      if (capacity == 0) {
                                        // show an alert dialog that the selected departure time is already full
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: const Text(
                                                      'No units available'),
                                                  content: Text(
                                                      'The time ${availableTime.time.format(context)} has reached its capacity of ${availableTimeAndCapacity[dateTimeSlot]}.  Please select another time.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Close'))
                                                  ]);
                                            });
                                      } else {
                                        DateTime startDate = value.copyWith(
                                            hour: availableTime.time.hour,
                                            minute: availableTime.time.minute);
                                        DateTime endDate = startDate.add(
                                            Duration(
                                                hours: widget
                                                    .listing.duration!.hour,
                                                minutes: widget
                                                    .listing.duration!.minute));
                                        final updatedBooking = booking.copyWith(
                                            bookingStatus: "Re-Booked",
                                            startDate: startDate,
                                            endDate: endDate);
                                        ref
                                            .read(listingControllerProvider
                                                .notifier)
                                            .updateBooking(
                                                context,
                                                booking.listingId,
                                                updatedBooking,
                                                "");
                                        //add code to edit the activity and update the plan
                                        context.pop();
                                        context.pop();
                                      }
                                    });
                              }
                            }).toList()),
                            actions: [
                              FilledButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("Back"))
                            ],
                          );
                          // });
                        });
                  }
                }
              },
              onCancel: () {
                Navigator.pop(context, null);
              },
            ),
          ),
        ),
      );
    } else {
      availableDates = [...widget.listing.entertainmentScheduling!.fixedDates!];
    }
  }

  Future<dynamic> erCancel(BuildContext context, ListingBookings booking) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Request Refund"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Column(
                children: [
                  Text(
                      "Your booking will be cancelled, and a full refund will be requested from the service provider."),
                ],
              ),
            ),
            actions: [
              FilledButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Back')),
              FilledButton(
                  onPressed: () {
                    final updatedBooking =
                        booking.copyWith(bookingStatus: "Request Refund");
                    ref.read(listingControllerProvider.notifier).updateBooking(
                        context, booking.listingId, updatedBooking, "");
                    context.pop();
                  },
                  child: const Text('Confirm')),
            ],
          );
        });
  }

  Future<dynamic> cancelBookingProcess(
      BuildContext context, ListingBookings booking) {
    return showDialog(
      context: context,
      builder: (context) {
        Map<String, bool> reasons = {
          'I don\'t want to go anymore': false,
          'My travel plans changed': false,
          'I have an emergency': false,
          'Other': false,
        };

        Map<String, num> paymentDetails = {
          'Original Booking': (booking.amountPaid!),
          'Your total refund': (booking.amountPaid! -
              (booking.amountPaid! * widget.listing.cancellationRate!)),
        };

        String? selectedReason;
        return StatefulBuilder(builder: (context, setDialogState) {
          return Dialog.fullscreen(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              bottomNavigationBar: PreferredSize(
                preferredSize: Size.fromHeight(
                    MediaQuery.sizeOf(context).height /
                        30), // Adjust the height as needed
                child: BottomAppBar(
                  surfaceTintColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: FilledButton(
                          onPressed: selectedReason != null
                              ? () {
                                  cancellationPaymentDetails(
                                      context, booking, paymentDetails);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the value as needed
                            ),
                          ),
                          child: const Text(
                            'Confirm Cancellation',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "Why do you need to cancel?",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 20,
                  ),
                  Column(
                    children: reasons.entries.map((entry) {
                      final reasonKey = entry.key;
                      return Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(reasonKey),
                              trailing: Radio(
                                value: reasonKey,
                                groupValue: selectedReason,
                                onChanged: (newValue) {
                                  setDialogState(() {
                                    reasons.forEach((key, value) {
                                      reasons[key] = key == newValue;
                                    });
                                    selectedReason = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[300],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<dynamic> cancellationPaymentDetails(BuildContext context,
      ListingBookings booking, Map<String, num> paymentDetails) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FilledButton(
                      onPressed: () {
                        onTapCancel(context, booking).then((value) {
                          context.pop();
                          context.pop();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the value as needed
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Cancellation",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      "Cancellation is effective immediately. The payment method you used to reserve this accommodation will be refunded in 5 - 7 business days.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height / 20),
                    const Text(
                      "Payment Details",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ...paymentDetails.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "₱${entry.value.toStringAsFixed(2)} PHP",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey[200],
                            ),
                          ],
                        ),
                      );
                    }),
                  ]),
            ),
          ));
        });
  }

  Future<dynamic> onTapCancel(
      BuildContext context, ListingBookings booking) async {
    final updatedBooking = booking.copyWith(
        amountPaid: booking.amountPaid! * widget.listing.cancellationRate!,
        bookingStatus: "Cancelled",
        paymentStatus: "Cancelled");
    final entertainmentUserNotif = NotificationsModel(
      title: "Booking Reservation Cancelled!",
      message:
          "Your booking for ${widget.listing.title} has been cancelled. You will receive a refund of ₱${booking.amountPaid! * widget.listing.cancellationRate!}",
      type: 'listing',
      bookingId: booking.id,
      listingId: booking.listingId,
      ownerId: booking.customerId,
      createdAt: DateTime.now(),
      isRead: false,
    );
    final sale = await ref.read(getSaleByBookingIdProvider(booking.id!).future);
    SaleModel updatedSale = sale.copyWith(
        transactionType: "Cancellation",
        saleAmount: booking.amountPaid! * widget.listing.cancellationRate!);
    final trip = await ref.read(getPlanByUidProvider(booking.tripUid).future);
    PlanModel updatedTrip = trip.copyWith(
      activities: trip.activities
          ?.where((activity) => activity.bookingId != booking.id)
          .toList(),
    );

    if (context.mounted) {
      ref.read(salesControllerProvider.notifier).updateSale(
          context, updatedSale,
          booking: updatedBooking, trip: updatedTrip);
      ref
          .read(notificationControllerProvider.notifier)
          .addNotification(entertainmentUserNotif, context);
    }
  }
}

// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_transport_receipt.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class BookingsTransportCustomer extends ConsumerStatefulWidget {
  final ListingModel listing;
  final ListingBookings booking;

  const BookingsTransportCustomer(
      {super.key, required this.listing, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingsTransportCustomerState();
}

class _BookingsTransportCustomerState
    extends ConsumerState<BookingsTransportCustomer> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          ref.read(navBarVisibilityProvider.notifier).show();
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
                        // cancelBookingProcess(context, booking);
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
                              Container(
                                  foregroundDecoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          booking.bookingStatus == "Cancelled"
                                              ? 0.5
                                              : 0.0)),
                                  child: ImageSlider(
                                      images: imageUrls,
                                      height:
                                          MediaQuery.sizeOf(context).height / 2,
                                      width: double.infinity,
                                      radius: BorderRadius.circular(0))),
                              if (booking.bookingStatus == "Cancelled")
                                Positioned.fill(
                                    top:
                                        MediaQuery.sizeOf(context).height / 7.5,
                                    left: MediaQuery.sizeOf(context).width / 15,
                                    child: const Flexible(
                                        child: Text(
                                            "Your Booking Has Been Cancelled",
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))))
                            ]),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(widget.listing.title,
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(height: 5),
                                                  // put the date here
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 20),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                            // format the date that does not include the time
                                                            "Booked Date: ${DateFormat('MMMM d, yyyy').format(widget.booking.startDate!)}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16))
                                                      ]),
                                                  const SizedBox(height: 10),
                                                  if (widget
                                                          .booking.typeOfTrip ==
                                                      'Public')
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Icon(
                                                              Icons
                                                                  .schedule_outlined,
                                                              size: 20),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                              // format the startTime
                                                              "Departure Time: ${widget.booking.startTime!.format(context)}",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16))
                                                        ]),
                                                ])),
                                      )
                                    ])),
                            ...generalActions.entries.map((entry) {
                              final generalAction = entry.value;
                              return Column(children: [
                                Container(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 15.0, right: 15.0),
                                    child: const Divider(
                                        color: Colors.grey, height: 1.0)),
                                ListTile(
                                    leading:
                                        Icon(generalAction["icon"], size: 24),
                                    title: Text(generalAction["title"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        )),
                                    onTap: generalAction["action"],
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded))
                              ]);
                            }),
                            Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: 10,
                                width: double.infinity,
                                color: Colors.grey[200]),

                            // reservation details
                            const Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 20),
                                child: Text('Reservation Details',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),

                            if (booking.bookingStatus != 'Cancelled' &&
                                booking.bookingStatus != 'Completed')
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 15),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Cancellation Policy: ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        if (booking.paymentOption ==
                                            'Full Payment')
                                          Text('Cancell')
                                      ])),

                            ...reservationActions.entries.map((entry) {
                              final reservationAction = entry.value;
                              if (booking.bookingStatus == 'Cancelled' &&
                                      entry.key == 'booking' ||
                                  booking.bookingStatus == 'Completed' &&
                                      entry.key == 'booking') {
                                return Container();
                              } else {
                                return Column(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 15.0, right: 15.0),
                                        child: const Divider(
                                            color: Colors.grey, height: 1.0)),
                                    ListTile(
                                        leading: Icon(reservationAction["icon"],
                                            size: 24),
                                        title: Text(reservationAction["title"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                            )),
                                        onTap: reservationAction["action"],
                                        trailing: const Icon(
                                            Icons.arrow_forward_ios_rounded))
                                  ]
                                );
                              }
                            }),

                            const Padding(
                              padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 20),
                              child: Text(
                                'Getting There',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.listing.city}, ${widget.listing.province}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15, right: 15, top: 20
                              ),
                              child: Text(
                                "Hosted By",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ),

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
                                      fontWeight: FontWeight.normal
                                    )
                                  )
                                ]
                              )
                            ),

                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15, right: 15, top: 20
                              ),
                              child: Text(
                                "Payment Information",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            ),
                          ])));
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString(), stackTrace: ''),
                loading: () => const CircularProgressIndicator()));
  }
}

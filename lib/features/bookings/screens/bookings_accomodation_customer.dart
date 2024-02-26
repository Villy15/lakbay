import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_accommodation_receipt.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class BookingsAccomodationCustomer extends ConsumerStatefulWidget {
  final ListingModel listing;
  final ListingBookings booking;
  const BookingsAccomodationCustomer(
      {super.key, required this.listing, required this.booking});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingsAccomodationCustomerState();
}

class _BookingsAccomodationCustomerState
    extends ConsumerState<BookingsAccomodationCustomer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String?> imageUrls =
        widget.listing.images!.map((listingImage) => listingImage.url).toList();
    Map<String, Map<String, dynamic>> generalActions = {
      "listing": {
        "icon": Icons.location_on_outlined,
        "title": "View Listing",
        "action": () => context.push(
            "/market/${widget.listing.category.toLowerCase()}",
            extra: widget.listing)
      },
      "message": {
        "icon": Icons.chat_outlined,
        "title": "Message Host",
        "action": () => context.push("/chat")
      },
    };

    Map<String, Map<String, dynamic>> reservationActions = {
      "booking": {
        "icon": Icons.cancel_outlined,
        "title": "Cancel Booking",
        "action": () {
          showDialog(
            context: context,
            builder: (context) {
              Map<String, bool> reasons = {
                'I don\'t want to go anymore': false,
                'My travel plans changed': false,
                'I have an emergency': false,
                'Other': false,
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
                    body: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            "Why do you need to cancel?",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
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
                              child: ElevatedButton(
                                onPressed:
                                    selectedReason != null ? () {} : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
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
                    ),
                  ),
                );
              });
            },
          );
        }
      },
      "receipt": {
        "icon": Icons.receipt_long_outlined,
        "title": "View receipt",
        "action": () => showDialog(
            context: context,
            builder: ((context) {
              return Dialog.fullscreen(
                child: CustomerAccomodationReceipt(
                    listing: widget.listing, booking: widget.booking),
              );
            }))
      },
    };
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            iconSize: 20,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
              ref.read(navBarVisibilityProvider.notifier).show();
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(
                images: imageUrls,
                height: MediaQuery.sizeOf(context).height / 2,
                width: double.infinity,
                radius: BorderRadius.circular(0)),

            // Check in Checkout
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check In',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              DateFormat('E, MMM d')
                                  .format(widget.booking.startDate!),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          // Checkin time
                          Text(
                            DateFormat.jm().format(widget.listing.checkIn!),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height / 7.5,
                    width: 1,
                    color: Colors.grey, // Choose the color of the line
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check Out',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              DateFormat('E, MMM d')
                                  .format(widget.booking.endDate!),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          // Checkout time
                          Text(
                            DateFormat.jm().format(widget.listing.checkOut!),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
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
            // // Plan Trip Header
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'Plan Trip',
            //     style: TextStyle(
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),

            // // Filled Button Add to a trip
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: const Text('Go to your trip'),
            //   ),
            // ),

            // Reservation Details Header
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

            // Cancellation Policy Text
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
                  if (widget.booking.paymentOption == "Downpayment")
                    Text(
                        'Cancellation before ${DateFormat('MMM d, HH:mm a').format(widget.booking.endDate!.subtract(const Duration(days: 5)))}'
                        ' entitles you to a refund amount of ₱${widget.booking.amountPaid!}.\n'
                        'Cancellation after stated date entitles you to a refund amount of ₱${widget.booking.amountPaid! - (widget.booking.amountPaid! * widget.listing.cancellationRate!)}.'),
                  if (widget.booking.paymentOption == "Full Payment")
                    Text(
                        'Cancellation before ${DateFormat('MMM d, HH:mm a').format(widget.booking.endDate!.subtract(const Duration(days: 5)))}'
                        ' entitles you to a refund amount of ₱${widget.booking.amountPaid! - (widget.booking.amountPaid! * widget.listing.downpaymentRate!)}.\n'
                        'Cancellation after stated date entitles you to a refund amount of ₱${widget.booking.amountPaid! - (widget.booking.amountPaid! * widget.listing.cancellationRate!)}.'),
                ],
              ),
            ),

            ...reservationActions.entries.map((entry) {
              final reservationAction = entry.value;
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Payment Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
